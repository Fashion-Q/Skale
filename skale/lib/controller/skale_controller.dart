import 'dart:core';
import 'package:flutter/material.dart';
import 'package:skale/interface/task_interface.dart';
import 'package:skale/pages/task_page.dart';
import '../entidade/task_entity.dart';
import '../module/skale_count_look.dart';
import '../module/task_look.dart';
import '../share/box_decoration.dart';
import '../share/text_style.dart';
import 'skale_count_controller.dart';
import 'task_controller.dart';

class SkaleController extends ChangeNotifier {
  final List<TaskEntity> task;
  final List<TaskInterface> queueWidget = [];
  int indexQueueWidget = 0;
  final List<Map<String, dynamic>> jsonTodasTarefas = [];
  final List<Widget> informacaoDoAlgoritmo = [];
  final List<Widget> tabelaDeChegada = [];
  final List<List<double>> infoChegada = [];
  int indexInfoChegada = 0;
  final List<Widget> informacaoDoEscalonamento = [];
  final SkaleCountLook skaleCount =
      SkaleCountLook(controller: SkaleCountController());

  final Map<String, String> jsonMonotonicTabela = {};
  String? charMonotonic;

  bool counterNotifier = true;
  bool playButton = false;
  bool playButtonOnePerTime = true;
  bool animationButton = true;
  bool allButton = true;
  int sleep = 2;

  TaskInterface? taskEmExecucao;
  final List<String> taskInfo = [
    "Tarefa(s)",
    "Período",
    "Tempo",
    "Chegada",
    "First Come First Serve",
  ];
  final double x;
  Function? executarAlgoritmo;

  SkaleController(
      {required this.task, required this.x, required this.checarAlgoritmos});

  void setTasks() {
    for (int i = 0; i < task.length; i++) {
      jsonTodasTarefas.add(task[i].toJason());
    }
    executarAlgoritmo = tipoAlgoritmo();

    preencherTabelaDeInformacao();

    preencherTabelaDeChegada();

    comecarFilaEscalonamento();
  }

  void comecarFilaEscalonamento() {
    if (verificarSeAlguemChegouNaFila()) {
      indexInfoChegada++;
    }
    taskEmExecucao = tipoExecucao();

    informacaoDoEscalonamento.add(
      taskEmExecucao == null
          ? addColumnRowEscalonamento("0", " ")
          : addColumnRowEscalonamento(
              "0", "${taskEmExecucao!.name}${taskEmExecucao!.chegada}"),
    );
  }

  Widget addColumnRowEscalonamento(String chegada, String nomeTarefa) {
    List<Text> text = [];
    text.add(
      Text(
        nomeTarefa,
        style: primaryStyle(size: 16),
      ),
    );
    String skale = "--------";
    for (int i = 0; i < nomeTarefa.length; i++) {
      skale += "-";
      if (i % 6 == 0) {
        skale += "-";
      }
    }
    text.add(
      Text(
        skale,
        style: primaryStyle(size: 16),
      ),
    );
    return Row(
      children: [
        Column(
          children: [
            const Text(" "),
            Text(
              chegada,
              style: primaryStyle(size: 16),
            ),
          ],
        ),
        Column(
          children: text,
        ),
      ],
    );
  }

  Widget addChegada(String nome, double fixWidth) {
    return boxDecorationBorderStroke(
      width: fixWidth,
      child: Text(
        nome,
        style: primaryStyle(
          size: 16,
        ),
      ),
    );
  }

  double fixWidthWidgetsTableChegada(double number) {
    double fixWidth = 1;
    while (number >= 10) {
      fixWidth++;
      number = double.parse((number / 10).toStringAsFixed(0));
    }
    return double.parse((34 + fixWidth * 13).toStringAsFixed(0));
  }

  Widget addFirstTableTempoChegadaX() {
    List<Widget> firstColumnChegada = [];
    for (int i = 0; i < task.length; i++) {
      firstColumnChegada.add(
        boxDecorationBorderStroke(
          width: 50,
          child: Text(
            task[i].name,
            style: primaryStyle(size: 16),
          ),
        ),
      );
    }
    return Column(
      children: firstColumnChegada,
    );
  }

  Widget widgetTaskEmExecucao() {
    return taskEmExecucao ??
        Container(
          alignment: Alignment.center,
          width: 50,
          color: Colors.green,
          child: Text(
            " ",
            style: primaryStyle(size: 25),
          ),
        );
  }

  String formatNomeTabelaDeInformacao(String chave, dynamic valor) {
    if (chave == "First Come First Serve" ||
        chave == "Shortest Job First" ||
        chave == "Shortest Remaining Time Next") {
      return " ";
    } else if (chave == "Rate Monotonic") {
      charMonotonic = charMonotonic == null
          ? "A"
          : String.fromCharCode(charMonotonic!.codeUnitAt(0) + 1);

      return jsonMonotonicTabela[charMonotonic!]!;
    }
    return chave == "Tarefa(s)" || chave == "Prioridade"
        ? valor.toString()
        : valor.toStringAsFixed(2);
  }

  double fixHeightInfoTable() {
    double fixHeight = task.length * 21 + 30;
    return fixHeight;
  }

  double fixHeightTableChegada() {
    double fixHeight = task.length * 23;
    return fixHeight;
  }

  double fixHeightFila() {
    double fixHeight = 0;
    if (taskInfo[taskInfo.length - 1] == "Round Robin" ||
        taskInfo[taskInfo.length - 1] == "DeadLine") {
      fixHeight = 25;
    }
    return fixHeight;
  }

  TaskInterface? tipoExecucao() {
    if (taskInfo[taskInfo.length - 1] == "Prioridade") {
      return prioridadeProximaExecucao();
    } else if (taskInfo[taskInfo.length - 1] == "First Come First Serve") {
      return firstComeFirstServesProximaExecucao();
    } else if (taskInfo[taskInfo.length - 1] == "Shortest Job First" ||
        taskInfo[taskInfo.length - 1] == "Shortest Remaining Time Next") {
      return shortestJobFirstProximaExecucao();
    } else if (taskInfo[taskInfo.length - 1] == "Rate Monotonic") {
      return rateMonotonicProximaExecucao();
    } else if (taskInfo[taskInfo.length - 1] == "Round Robin") {
      return roundRobinProximaExecucao();
    } else if (taskInfo[taskInfo.length - 1] == "DeadLine") {
      return deadLineProximaExecucao();
    }
    //"Shortest Job First"
    return null;
  }

  void playOrPauseButton() async {
    if (skaleCount.count < x) {
      playButton = !playButton;
      notifyListeners();
      if (playButton) {
        if (playButtonOnePerTime) {
          playButtonOnePerTime = false;
          while (playButton && skaleCount.count < x) {
            executarAlgoritmo!();
            await Future.delayed(Duration(milliseconds: sleep));
          }
          playButtonOnePerTime = true;
          if (skaleCount.count >= x) {
            playButton = false;
            notifyListeners();
          }
        }
      }
    }
  }

  void tempoAnimacaoDescrementa() {
    if (sleep > 0) {
      if (sleep == 10) {
        sleep += 2;
      }
      sleep -= 10;
      if (sleep < 0) {
        sleep = 0;
      }
    }
    notifyListeners();
  }

  void tempoAnimacaoIncrementa() {
    if (sleep < 500) {
      if (sleep == 2) {
        sleep = 10;
      } else {
        sleep += 10;
      }
    }
    notifyListeners();
  }

  void resetarAtual() async {
    allButton = false;
    playButton = false;
    notifyListeners();
    queueWidget.clear();
    informacaoDoEscalonamento.clear();
    taskEmExecucao = null;
    indexInfoChegada = 0;
    indexQueueWidget = 0;
    animationButton = true;
    skaleCount.setCounter = 0.00;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    comecarFilaEscalonamento();
    allButton = true;
    notifyListeners();
  }

  void resetarTudo() async {
    charMonotonic = null;
    allButton = false;
    notifyListeners();
    jsonTodasTarefas.clear();
    queueWidget.clear();
    informacaoDoAlgoritmo.clear();
    tabelaDeChegada.clear();
    infoChegada.clear();
    informacaoDoEscalonamento.clear();
    taskEmExecucao = null;
    indexInfoChegada = 0;
    indexQueueWidget = 0;
    playButton = false;
    animationButton = true;
    skaleCount.setCounter = 0.00;
    await Future.delayed(const Duration(milliseconds: 500));
    setTasks();
    allButton = true;
    notifyListeners();
  }

  void skipTaskAnimation() async {
    allButton = false;
    playButton = false;
    animationButton = false;
    counterNotifier = false;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    while (skaleCount.count < x) {
      executarAlgoritmo!();
    }
    counterNotifier = true;
    allButton = true;
    notifyListeners();
  }

  Function? tipoAlgoritmo() {
    if (taskInfo[taskInfo.length - 1] == "Prioridade" ||
        taskInfo[taskInfo.length - 1] == "Rate Monotonic") {
      return algoritimoDePrioridade;
    } else if (taskInfo[taskInfo.length - 1] == "First Come First Serve") {
      return algoritimoDeFirstComeFirstServes;
    } else if (taskInfo[taskInfo.length - 1] == "Shortest Job First") {
      return algoritimoDeShortestJobFirst;
    } else if (taskInfo[taskInfo.length - 1] ==
        "Shortest Remaining Time Next") {
      return algoritimoDeShortestRemainingTimeNext;
    } else if (taskInfo[taskInfo.length - 1] == "Round Robin") {
      return algoritimoRoundRobin;
    } else if (taskInfo[taskInfo.length - 1] == "DeadLine") {
      return algoritimoDeadLine;
    }
    //aqui
    return null;
  }

  TaskLook getTaskLook({int? indexQueueAnterior}) {
    if (indexQueueAnterior != null) {
      queueWidget[indexQueueAnterior].setIsOnPromptBool = false;
      queueWidget[indexQueueAnterior] = TaskPage(
        taskEntity: queueWidget[indexQueueAnterior].taskEntity,
        tipoAlgoritmo: taskInfo[taskInfo.length - 1],
      );
    }
    queueWidget[indexQueueWidget].setIsOnPromptBool = true;
    return (queueWidget[indexQueueWidget] = TaskLook(
      controller: TaskController(
        task: queueWidget[indexQueueWidget].taskEntity,
      ),
      tipoAlgoritmo: taskInfo[taskInfo.length - 1],
    ));
  }

  void preencherTabelaDeInformacao() async {
    for (int i = 0; i < taskInfo.length; i++) {
      List<Widget> text = [];
      text.add(
        Text(
          taskInfo[i],
          style: primaryStyle(size: 16),
        ),
      );
      for (int j = 0; j < task.length; j++) {
        text.add(
          Text(
            formatNomeTabelaDeInformacao(
                taskInfo[i], jsonTodasTarefas[j][taskInfo[i]]),
            style: primaryStyle(size: 16),
          ),
        );
      }
      informacaoDoAlgoritmo.add(
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            children: text,
          ),
        ),
      );
    }
  }

  void preencherTabelaDeChegada() {
    tabelaDeChegada.add(addFirstTableTempoChegadaX());
    List<double> auxChegada = [];
    for (int i = 0; i < task.length; i++) {
      auxChegada.add(task[i].chegada);
    }

    for (double i = 0; i < x;) {
      bool chegouAguemNaFila = false;
      int index = 0;
      for (int j = 0; j < auxChegada.length; j++) {
        if (auxChegada[j] == i) {
          chegouAguemNaFila = true;
          index = j;
          break;
        }
      }
      if (chegouAguemNaFila) {
        double fixWidth = fixWidthWidgetsTableChegada(auxChegada[index]);
        List<Widget> columnChegada = [];
        List<double> copyList = [];
        for (int k = 0; k < auxChegada.length; k++) {
          if (auxChegada[k] == i) {
            columnChegada.add(
              addChegada(auxChegada[k].toStringAsFixed(2), fixWidth),
            );
            copyList.add(auxChegada[k]);
            auxChegada[k] = double.parse(
                ((auxChegada[k] + task[k].periodo)).toStringAsFixed(2));
          } else {
            //lambd
            columnChegada.add(
              addChegada(" ", fixWidth),
            );
            copyList.add(-1);
          }
        }
        infoChegada.add(List.from(copyList));
        tabelaDeChegada.add(Column(
          children: columnChegada,
        ));
      }
      i = i + 0.01;
      i = double.parse(i.toStringAsFixed(2));
    }
  }

  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################

  void jsonMonotonic() {
    if (jsonMonotonicTabela.isNotEmpty) {
      return;
    }
    List<TaskEntity> aux = List.from(task);
    aux.sort((t1, t2) => t1.periodo.compareTo(t2.periodo));
    int k = 0;
    for (int i = 0; i < aux.length; i++) {
      if (i > 0 && aux[i - 1].periodo != aux[i].periodo) {
        k++;
      }
      jsonMonotonicTabela[aux[i].name] = (k + 1).toString();
    }
  }

  void algoritimoDeRateMonotonic() {
    skaleCount.increment(counterNotifier);
    bool proximaExec = false;
    bool chegouAlguem = false;
    proximaExec = incrementTask();
    chegouAlguem = verificarSeAlguemChegouNaFila();
    if (chegouAlguem) {
      adicionarEscalonamentoChegouAlguem();
      indexInfoChegada++;
    } else if (proximaExec) {
      adicionarEscalonamentoProxExe();
    }
    if (animationButton) {
      notifyListeners();
    }
  }

  TaskInterface? rateMonotonicProximaExecucao() {
    if (queueWidget.isEmpty) {
      return null;
    }
    int index = -1;
    int indexQueueAnterior = indexQueueWidget;
    double menorPeriodo = 9223372036;
    if (taskEmExecucao != null) {
      menorPeriodo = taskEmExecucao!.periodo;
    }
    for (int i = 0; i < queueWidget.length; i++) {
      if (queueWidget[i].timeIsNotFinished &&
          menorPeriodo > queueWidget[i].periodo) {
        menorPeriodo = queueWidget[i].periodo;
        index = i;
        indexQueueWidget = i;
      }
    }
    if (menorPeriodo != 9223372036) {
      return index > -1
          ? getTaskLook(indexQueueAnterior: indexQueueAnterior)
          : taskEmExecucao;
    }
    return null;
  }

  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################

  void algoritimoDeShortestRemainingTimeNext() {
    skaleCount.increment(counterNotifier);
    bool proximaExec = false;
    bool chegouAlguem = false;
    proximaExec = incrementTask();
    chegouAlguem = verificarSeAlguemChegouNaFila();
    if (chegouAlguem) {
      adicionarEscalonamentoChegouAlguem();
      indexInfoChegada++;
    } else if (proximaExec) {
      adicionarEscalonamentoProxExe();
    }
    if (animationButton) {
      notifyListeners();
    }
  }

  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################

  void algoritimoDeShortestJobFirst() {
    skaleCount.increment(counterNotifier);
    bool proximaExec = false;
    bool chegouAlguem = false;
    proximaExec = incrementTask();
    chegouAlguem = verificarSeAlguemChegouNaFila();
    if (chegouAlguem) {
      if (taskEmExecucao == null) {
        adicionarEscalonamentoChegouAlguem();
      }
      indexInfoChegada++;
    } else if (proximaExec) {
      adicionarEscalonamentoProxExe();
    }
    if (animationButton) {
      notifyListeners();
    }
  }

  TaskInterface? shortestJobFirstProximaExecucao() {
    if (queueWidget.isEmpty) {
      return null;
    }
    int index = -1;
    int indexQueueAnterior = indexQueueWidget;
    double menorExecucao = double.infinity;
    for (int i = 0; i < queueWidget.length; i++) {
      if (queueWidget[i].timeIsNotFinished &&
          menorExecucao > queueWidget[i].dTempo) {
        menorExecucao = queueWidget[i].dTempo;
        index = i;
        indexQueueWidget = i;
      }
    }
    return index > -1
        ? getTaskLook(indexQueueAnterior: indexQueueAnterior)
        : null;
  }

  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################

  void algoritimoDePrioridade() {
    skaleCount.increment(counterNotifier);
    bool proximaExec = false;
    bool chegouAlguem = false;
    proximaExec = incrementTask();
    chegouAlguem = verificarSeAlguemChegouNaFila();
    if (chegouAlguem) {
      adicionarEscalonamentoChegouAlguem();
      indexInfoChegada++;
    } else if (proximaExec) {
      adicionarEscalonamentoProxExe();
    }
    if (animationButton) {
      notifyListeners();
    }
  }

  TaskInterface? prioridadeProximaExecucao() {
    if (queueWidget.isEmpty) {
      return null;
    }
    int prioridade =
        taskEmExecucao == null ? 9223372036854775 : taskEmExecucao!.prioridade!;
    int index = -1;
    int indexQueueAnterior = indexQueueWidget;
    for (int i = 0; i < queueWidget.length; i++) {
      if (queueWidget[i].timeIsNotFinished &&
          prioridade > queueWidget[i].prioridade!) {
        prioridade = queueWidget[i].prioridade!;
        index = i;
        indexQueueWidget = i;
      }
    }
    if (prioridade != 9223372036854775) {
      return index > -1
          ? getTaskLook(indexQueueAnterior: indexQueueAnterior)
          : taskEmExecucao;
    }
    return null;
  }

  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################

  void addWidgetRoundRobin() {
    if (taskEmExecucao!.dTempo > 0) {
      queueWidget.add(TaskPage(
        taskEntity: taskEmExecucao!.taskEntity.copyWith(
          novoNome: taskEmExecucao!.name,
          novoChegada: taskEmExecucao!.chegada,
          novaPrioridade: taskEmExecucao!.prioridade,
          novoTempo: taskEmExecucao!.dTempo,
          novoQuantum: jsonTodasTarefas[jsonTodasTarefas.indexWhere(
                  (element) => element["Tarefa(s)"] == taskEmExecucao!.name)]
              ["Round Robin"],
        ),
        tipoAlgoritmo: taskInfo[taskInfo.length - 1],
      ));
    }
  }

  void algoritimoRoundRobin() {
    skaleCount.increment(counterNotifier);
    bool proximaExec = false;
    bool chegouAlguem = false;
    if (taskEmExecucao != null) {
      if (taskEmExecucao is TaskLook) {
        (taskEmExecucao! as TaskLook).controller.decrementQuantum();
      }
    }
    chegouAlguem = verificarSeAlguemChegouNaFila();
    proximaExec = incrementTask();
    if (chegouAlguem) {
      if (!proximaExec) {
        adicionarEscalonamentoChegouAlguem();
      }
      indexInfoChegada++;
    }
    if (proximaExec) {
      adicionarEscalonamentoProxExe();
    }
    if (animationButton) {
      notifyListeners();
    }
  }

  TaskInterface? roundRobinProximaExecucao() {
    if (queueWidget.isEmpty) {
      return null;
    }
    if (taskEmExecucao != null) {
      return taskEmExecucao;
    }

    if (indexQueueWidget < queueWidget.length) {
      if (queueWidget[indexQueueWidget].timeIsNotFinished) {
        return getTaskLook(indexQueueAnterior: null);
      } else if (indexQueueWidget + 1 < queueWidget.length) {
        indexQueueWidget++;
        return getTaskLook(indexQueueAnterior: indexQueueWidget - 1);
      }
    }
    return null;
  }

  void algoritimoDeadLine() {
    skaleCount.increment(counterNotifier);
    bool proximaExec = false;
    bool chegouAlguem = false;
    proximaExec = incrementTask();
    chegouAlguem = verificarSeAlguemChegouNaFila();
    if (chegouAlguem) {
      adicionarEscalonamentoChegouAlguem();
      indexInfoChegada++;
    } else if (proximaExec) {
      adicionarEscalonamentoProxExe();
    }
    if (animationButton) {
      notifyListeners();
    }
  }

  TaskInterface? deadLineProximaExecucao() {
    if (queueWidget.isEmpty) {
      return null;
    }
    double menorDeadLine =
        taskEmExecucao == null ? 99999999 : taskEmExecucao!.deadLine!;
    int index = -1;
    int indexQueueAnterior = indexQueueWidget;

    for (int i = 0; i < queueWidget.length; i++) {
      if (queueWidget[i].timeIsNotFinished &&
          menorDeadLine > queueWidget[i].deadLine!) {
        menorDeadLine = queueWidget[i].deadLine!;
        index = i;
        indexQueueWidget = i;
      }
    }
    if (menorDeadLine != 99999999) {
      return index > -1
          ? getTaskLook(indexQueueAnterior: indexQueueAnterior)
          : taskEmExecucao;
    }
    return null;
  }

  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################

  void algoritimoDeFirstComeFirstServes() {
    skaleCount.increment(counterNotifier);
    bool proximaExec = false;
    bool chegouAlguem = false;
    proximaExec = incrementTask();
    chegouAlguem = verificarSeAlguemChegouNaFila();
    if (chegouAlguem) {
      if (taskEmExecucao == null) {
        adicionarEscalonamentoChegouAlguem();
      }
      indexInfoChegada++;
    } else if (proximaExec) {
      adicionarEscalonamentoProxExe();
    }
    if (animationButton) {
      notifyListeners();
    }
  }

  TaskInterface? firstComeFirstServesProximaExecucao() {
    if (queueWidget.isEmpty) {
      return null;
    }
    int indexQueueAnterior = indexQueueWidget;
    for (int i = 0; i < queueWidget.length; i++) {
      if (queueWidget[i].timeIsNotFinished) {
        queueWidget[i] = TaskLook(
          controller: TaskController(
            task: queueWidget[i].taskEntity,
          ),
          tipoAlgoritmo: taskInfo[taskInfo.length - 1],
        );
        indexQueueWidget = i;
        return getTaskLook(indexQueueAnterior: indexQueueAnterior);
      }
    }
    return null;
  }

  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  //########################################################################
  bool incrementTask() {
    bool proximaExec = false;
    if (taskEmExecucao != null) {
      if (taskEmExecucao is TaskLook) {
        (taskEmExecucao! as TaskLook).controller.incrementNotifier();
      }
      if (!taskEmExecucao!.timeIsNotFinished) {
        queueWidget[indexQueueWidget] = TaskPage(
          taskEntity:
              taskEmExecucao!.taskEntity.copyWith(newTimeIsNotFinished: false),
          tipoAlgoritmo: taskInfo[taskInfo.length - 1],
        );
        if (taskInfo[taskInfo.length - 1] == "Round Robin") {
          addWidgetRoundRobin();
        }
        taskEmExecucao = null;
        proximaExec = true;
      }
    }
    return proximaExec;
  }

  bool verificarSeAlguemChegouNaFila() {
    bool chegouAlguem = false;
    if (infoChegada.isNotEmpty && indexInfoChegada < infoChegada.length) {
      for (int i = 0; i < infoChegada[indexInfoChegada].length; i++) {
        if (infoChegada[indexInfoChegada][i] == skaleCount.count) {
          queueWidget.add(TaskPage(
            taskEntity: task[i].copyWith(
                novoNome: task[i].name,
                novoChegada: infoChegada[indexInfoChegada][i],
                novaPrioridade: task[i].prioridade,
                novoTempo: jsonTodasTarefas[i]["Tempo"],
                novoQuantum: task[i].quantum,
                novoDeadLine: task[i].deadLine != null
                    ? task[i].deadLine! + infoChegada[indexInfoChegada][i]
                    : 0),
            tipoAlgoritmo: taskInfo[taskInfo.length - 1],
          ));
          chegouAlguem = true;
          notifyListeners();
        }
      }
    }
    return chegouAlguem;
  }

  void adicionarEscalonamentoChegouAlguem() {
    TaskInterface? taskAnterior = taskEmExecucao;
    taskEmExecucao = tipoExecucao();
    if (taskAnterior != taskEmExecucao) {
      informacaoDoEscalonamento.add(addColumnRowEscalonamento(
          skaleCount.count.toStringAsFixed(2),
          "${taskEmExecucao!.name}${taskEmExecucao!.chegada}"));
    }
  }

  void adicionarEscalonamentoProxExe() {
    taskEmExecucao = tipoExecucao();
    if (taskEmExecucao != null) {
      informacaoDoEscalonamento.add(addColumnRowEscalonamento(
          skaleCount.count.toStringAsFixed(2),
          "${taskEmExecucao!.name}${taskEmExecucao!.chegada}"));
    } else {
      informacaoDoEscalonamento.add(
          addColumnRowEscalonamento(skaleCount.count.toStringAsFixed(2), " "));
    }
  }

  @override
  void dispose() {
    super.dispose();
    jsonTodasTarefas.clear();
    informacaoDoAlgoritmo.clear();
    tabelaDeChegada.clear();
    infoChegada.clear();
    informacaoDoEscalonamento.clear();
  }

//########################################################################
//########################################################################
//########################################################################
//########################################################################
//########################################################################
//########################################################################
//########################################################################
//########################################################################
//########################################################################
//########################################################################
//########################################################################
//########################################################################

  final List<bool> checarAlgoritmos;

  final List<String> nomesAlgoritmo = [
    "First Come First Serve",
    "Shortest Job First",
    "Shortest Remaining Time Next",
    "Prioridade",
    "Rate Monotonic",
    "Round Robin",
    "DeadLine"
  ];

  String? mensagemSnackBar;

  void controllSnackBar() async {
    allButton = false;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 7));
    allButton = true;
    notifyListeners();
  }

  bool dropDownButton(String valor) {
    for (int i = 0; i < nomesAlgoritmo.length; i++) {
      if (nomesAlgoritmo[i] == valor) {
        if (checarAlgoritmos[i] == false) {
          mensagemSnackBar =
              "Algoritmo não está totalmente preenchido: (${nomesAlgoritmo[i]})";
          return false;
        }
      }
      if (valor == taskInfo[taskInfo.length - 1]) {
        return true;
      }
    }
    taskInfo[taskInfo.length - 1] = valor;
    if (valor == "Rate Monotonic" && jsonMonotonicTabela.isEmpty) {
      jsonMonotonic();
    }
    resetarTudo();
    return true;
  }
}
