import 'dart:core';
import 'package:flutter/material.dart';
import 'package:skale/interface/task_interface.dart';
import 'package:skale/pages/task_page.dart';
import '../entidade/tarefa.dart';
import '../module/skale_count_look.dart';
import '../module/task_look.dart';
import '../share/box_decoration.dart';
import '../share/text_style.dart';
import 'skale_count_controller.dart';
import 'task_controller.dart';

class SkaleController extends ChangeNotifier {
  final List<Task> task;
  final List<TaskInterface> queueWidget = [];
  int indexQueueWidget = 0;
  final List<Map<String, dynamic>> jsonTodasTarefas;
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
  final List<String> taskInfo;
  final double x;
  Function? executarAlgoritmo;

  SkaleController(
      {required this.task,
      required this.x,
      required this.taskInfo,
      required this.jsonTodasTarefas});

  void setTasks() async {
    executarAlgoritmo = tipoAlgoritmo();
    //jsonMonotonic();
    preencherTabelaDeInformacao();

    preencherTabelaDeChegada();

    comecarFilaEscalonamento();
    //charMonotonic = null;
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
              "0", "${taskEmExecucao!.nome}${taskEmExecucao!.chegada}"),
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
    return double.parse((34 + fixWidth * 12).toStringAsFixed(0));
  }

  Widget addFirstTableTempoChegadaX() {
    List<Widget> firstColumnChegada = [];
    for (int i = 0; i < task.length; i++) {
      firstColumnChegada.add(
        boxDecorationBorderStroke(
          width: 50,
          child: Text(
            task[i].nome,
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
    notifyListeners();
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
    if (taskInfo[taskInfo.length - 1] == "Prioridade") {
      return algoritimoDePrioridade;
    } else if (taskInfo[taskInfo.length - 1] == "First Come First Serve") {
      return algoritimoDeFirstComeFirstServes;
    } else if (taskInfo[taskInfo.length - 1] == "Shortest Job First") {
      return algoritimoDeShortestJobFirst;
    } else if (taskInfo[taskInfo.length - 1] ==
        "Shortest Remaining Time Next") {
      return algoritimoDeShortestRemainingTimeNext;
    } else if (taskInfo[taskInfo.length - 1] == "Rate Monotonic") {
      return algoritimoDeRateMonotonic;
    }
    return null;
  }

  TaskLook getTaskLook({int? indexQueueAnterior}) {
    if (indexQueueAnterior != null) {
      queueWidget[indexQueueAnterior].setBoolExecucao = false;
      queueWidget[indexQueueAnterior] =
          TaskPage(task: queueWidget[indexQueueAnterior].task);
    }
    queueWidget[indexQueueWidget].setBoolExecucao = true;
    return (queueWidget[indexQueueWidget] = TaskLook(
      controller: TaskController(
        task: queueWidget[indexQueueWidget].task,
      ),
    ));
  }

  void preencherTabelaDeInformacao() {
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
      bool achou = false;
      int index = 0;
      for (int j = 0; j < auxChegada.length; j++) {
        if (auxChegada[j] == i) {
          achou = true;
          index = j;
          break;
        }
      }
      if (achou) {
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
    List<Task> aux = List.from(task);
    aux.sort((t1, t2) => t1.periodo.compareTo(t2.periodo));
    int k = 0;
    for (int i = 0; i < aux.length; i++) {
      if (i > 0 && aux[i - 1].periodo != aux[i].periodo) {
        k++;
      }
      jsonMonotonicTabela[aux[i].nome] = (k + 1).toString();
    }
  }

  void algoritimoDeRateMonotonic() {
    skaleCount.increment(counterNotifier);
    bool proximaExec = false;
    bool chegouAlguem = false;
    proximaExec = incrementTask();
    chegouAlguem = verificarSeAlguemChegouNaFila();
    if (chegouAlguem) {
      TaskInterface? taskAnterior = taskEmExecucao;
      taskEmExecucao = tipoExecucao();
      if (taskAnterior != taskEmExecucao) {
        informacaoDoEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2),
            "${taskEmExecucao!.nome}${taskEmExecucao!.chegada}"));
      }
      indexInfoChegada++;
    } else if (proximaExec) {
      taskEmExecucao = tipoExecucao();
      if (taskEmExecucao != null) {
        informacaoDoEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2),
            "${taskEmExecucao!.nome}${taskEmExecucao!.chegada}"));
      } else {
        informacaoDoEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2), " "));
      }
    }
    if (animationButton) {
      notifyListeners();
    }
  }

  TaskLook? rateMonotonicProximaExecucao() {
    // if (taskLook.isEmpty) {
    //   return null;
    // }
    // int index = -1;
    // double menorPeriodo = double.infinity;
    // if (taskEmExecucao != null) {
    //   menorPeriodo = taskEmExecucao!.periodo;
    // }
    // for (int i = 0; i < taskLook.length; i++) {
    //   if (taskLook[i].noZero && menorPeriodo > taskLook[i].periodo) {
    //     menorPeriodo = taskLook[i].periodo;
    //     index = i;
    //   }
    // }
    // if (taskEmExecucao != null && index == -1) {
    //   return taskEmExecucao;
    // }
    // return index > -1 ? taskLook[index] : null;
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
      if (queueWidget[i].noZero && menorExecucao > queueWidget[i].dTempo) {
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
    int prioridade = taskEmExecucao == null
        ? 9223372036854775
        : taskEmExecucao!.prioridade!; //780
    int index = -1;
    int indexQueueAnterior = indexQueueWidget;
    for (int i = 0; i < queueWidget.length; i++) {
      if (queueWidget[i].noZero && prioridade > queueWidget[i].prioridade!) {
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

  void algoritimoDeFirstComeFirstServes() {
    skaleCount.increment(counterNotifier);
    bool proximaExec = false;
    bool chegouAlguem = false;
    proximaExec = incrementTask();
    chegouAlguem = verificarSeAlguemChegouNaFila();
    if (chegouAlguem) {
      if (taskEmExecucao == null) {
        taskEmExecucao = tipoExecucao();
        informacaoDoEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2),
            "${taskEmExecucao!.nome}${taskEmExecucao!.chegada}"));
      }
    } else if (proximaExec) {
      taskEmExecucao = tipoExecucao();
      if (taskEmExecucao != null) {
        informacaoDoEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2),
            "${taskEmExecucao!.nome}${taskEmExecucao!.chegada}"));
      } else {
        informacaoDoEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2), " "));
      }
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
      if (queueWidget[i].noZero) {
        queueWidget[i] = TaskLook(
          controller: TaskController(
            task: queueWidget[i].task,
          ),
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
      if (!taskEmExecucao!.noZero) {
        queueWidget[indexQueueWidget] =
            TaskPage(task: taskEmExecucao!.task.copyWith(novoNoZero: false));
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
              task: task[i].copyWith(
                  novoNome: task[i].nome,
                  novoChegada: infoChegada[indexInfoChegada][i],
                  prioridade: task[i].prioridade,
                  novoTempo: jsonTodasTarefas[i]["Tempo"])));
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
          "${taskEmExecucao!.nome}${taskEmExecucao!.chegada}"));
    }
  }

  void adicionarEscalonamentoProxExe() {
    taskEmExecucao = tipoExecucao();
    if (taskEmExecucao != null) {
      informacaoDoEscalonamento.add(addColumnRowEscalonamento(
          skaleCount.count.toStringAsFixed(2),
          "${taskEmExecucao!.nome}${taskEmExecucao!.chegada}"));
    } else {
      informacaoDoEscalonamento.add(
          addColumnRowEscalonamento(skaleCount.count.toStringAsFixed(2), " "));
    }
  }

  @override
  void dispose() {
    super.dispose();
    jsonTodasTarefas.clear();
    // taskController.clear();
    // taskLook.clear();
    informacaoDoAlgoritmo.clear();
    tabelaDeChegada.clear();
    infoChegada.clear();
    informacaoDoEscalonamento.clear();
  }

  void testador() {
    if (sleep == 2) {
      sleep = 500;
    } else {
      sleep = 2;
    }
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

  