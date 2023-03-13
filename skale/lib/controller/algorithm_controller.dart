import 'dart:core';
import 'package:flutter/material.dart';
import '../entidade/tarefa.dart';
import '../module/skale_count_look.dart';
import '../module/task_look.dart';
import '../share/box_decoration.dart';
import '../share/text_style.dart';
import 'skale_count_controller.dart';
import 'task_controller.dart';

class SkaleController extends ChangeNotifier {
  final List<Task> task;
  final List<TaskLook> taskLook = [];
  final List<TaskController> taskController = [];
  final List<Map<String, dynamic>> jsonTodasTarefas = [];
  final List<Widget> informacaoDoEscalonamento = [];
  final List<Widget> tabelaDeChegada = [];
  final List<List<double>> infoChegada = [];
  int indexInfoChegada = 0;
  final List<Widget> columnRowEscalonamento = [];
  final SkaleCountLook skaleCount =
      SkaleCountLook(controller: SkaleCountController());
  bool counterNotifier = true;
  bool playButton = false;
  bool playButtonOnePerTime = true;
  bool skipperButton = true;
  bool allButton = true;
  int sleep = 100;

  TaskLook? taskEmExecucao;
  final List<String> taskInfo;
  final double x;

  SkaleController(
      {required this.task, required this.x, required this.taskInfo});

  void addTasks() {
    for (int i = 0; i < task.length; i++) {
      jsonTodasTarefas.add(task[i].toJason());
    }
    for (int i = 0; i < task.length; i++) {
      if (task[i].chegada == 0) {
        taskController.add(TaskController(
            task: task[i].copyWith(
                novoNome: task[i].nome,
                novoChegada: task[i].chegada,
                prioridade: task[i].prioridade,
                novoTempo: jsonTodasTarefas[i]["Tempo"])));
        taskLook.add(
            TaskLook(controller: taskController[taskController.length - 1]));
        indexInfoChegada = 1;
      }
    }
    taskEmExecucao = tipoExecucao();

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
      informacaoDoEscalonamento.add(
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            children: text,
          ),
        ),
      );
    }
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
    columnRowEscalonamento.add(
      taskEmExecucao == null
          ? addColumnRowEscalonamento("0", " ")
          : addColumnRowEscalonamento("0",
              "${taskEmExecucao!.controller.nome}${taskEmExecucao!.chegada}"),
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
    return boxDecorationTableTempoChegadaX(
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
        boxDecorationTableTempoChegadaX(
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

  TaskLook? tipoExecucao() {
    if (taskInfo[taskInfo.length - 1] == "Prioridade") {
      return prioridadeProximaExecucao();
    } else if (taskInfo[taskInfo.length - 1] == "First Come First Serve") {
      return firstComeFirstServesProximaExecucao();
    } else if (taskInfo[taskInfo.length - 1] == "Shortest Job First" ||
        taskInfo[taskInfo.length - 1] == "Shortest Remaining Time Next") {
      return shortestJobFirstProximaExecucao();
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
            //algoritimoDePrioridade();
            tipoAlgoritmo();
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

  void resetarTudo() async {
    allButton = false;
    notifyListeners();
    jsonTodasTarefas.clear();
    taskController.clear();
    taskLook.clear();
    informacaoDoEscalonamento.clear();
    tabelaDeChegada.clear();
    infoChegada.clear();
    columnRowEscalonamento.clear();
    taskEmExecucao = null;
    indexInfoChegada = 0;
    playButton = false;
    skipperButton = true;
    skaleCount.setCounter = 0.00;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    addTasks();
    allButton = true;
    notifyListeners();
  }

  void skipTaskAnimation() async {
    allButton = false;
    playButton = false;
    skipperButton = false;
    counterNotifier = false;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1000));
    while (skaleCount.count < x) {
      tipoAlgoritmo();
    }
    counterNotifier = true;
    allButton = true;
    notifyListeners();
  }

  void tipoAlgoritmo() {
    if (taskInfo[taskInfo.length - 1] == "Prioridade") {
      algoritimoDePrioridade();
    } else if (taskInfo[taskInfo.length - 1] == "First Come First Serve") {
      algoritimoDeFirstComeFirstServes();
    } else if (taskInfo[taskInfo.length - 1] == "Shortest Job First") {
      algoritimoDeShortestJobFirst();
    } else if (taskInfo[taskInfo.length - 1] ==
        "Shortest Remaining Time Next") {
      algoritimoDeShortestRemainingTimeNext();
    }
  } //"Shortest Job First"

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
      TaskLook? taskAnterior = taskEmExecucao;
      taskEmExecucao = tipoExecucao();
      if (taskAnterior != taskEmExecucao) {
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2),
            "${taskEmExecucao!.nome}${taskEmExecucao!.chegada}"));
      }
      indexInfoChegada++;
    } else if (proximaExec) {
      taskEmExecucao = tipoExecucao();
      if (taskEmExecucao != null) {
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2),
            "${taskEmExecucao!.nome}${taskEmExecucao!.chegada}"));
      } else {
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2), " "));
      }
    }
    if (skipperButton) {
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
        taskEmExecucao = tipoExecucao();
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2),
            "${taskEmExecucao!.nome}${taskEmExecucao!.chegada}"));
      }
      indexInfoChegada++;
    }
    else if (proximaExec) {
      taskEmExecucao = tipoExecucao();
      if (taskEmExecucao != null) {
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2),
            "${taskEmExecucao!.nome}${taskEmExecucao!.chegada}"));
      } else {
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2), " "));
      }
    }
    if (skipperButton) {
      notifyListeners();
    }
  }

  TaskLook? shortestJobFirstProximaExecucao() {
    if (taskLook.isEmpty) {
      return null;
    }
    int index = -1;
    double menorExecucao = double.infinity;
    for (int i = 0; i < taskLook.length; i++) {
      if (taskLook[i].controller.noZero && menorExecucao > taskLook[i].dTempo) {
        menorExecucao = taskLook[i].dTempo;
        index = i;
      }
    }
    return index > -1 ? taskLook[index] : null;
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
      TaskLook? taskAnterior = taskEmExecucao;
      taskEmExecucao = tipoExecucao();
      if (taskAnterior != taskEmExecucao) {
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2),
            "${taskEmExecucao!.nome}${taskEmExecucao!.chegada}"));
      }
      indexInfoChegada++;
    } else if (proximaExec) {
      taskEmExecucao = tipoExecucao();
      if (taskEmExecucao != null) {
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2),
            "${taskEmExecucao!.nome}${taskEmExecucao!.chegada}"));
      } else {
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2), " "));
      }
    }
    if (skipperButton) {
      notifyListeners();
    }
  }

  TaskLook? prioridadeProximaExecucao() {
    if (taskLook.isEmpty) {
      return null;
    }
    int prioridade = taskEmExecucao == null
        ? 9223372036854775
        : taskEmExecucao!.prioridade!; //780
    int index = -1;
    for (int i = 0; i < taskLook.length; i++) {
      if (taskLook[i].noZero &&
          prioridade > taskLook[i].prioridade!) {
        prioridade = taskLook[i].prioridade!;
        index = i;
      }
    }
    if (prioridade != 9223372036854775) {
      return index > -1 ? taskLook[index] : taskEmExecucao;
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
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2),
            "${taskEmExecucao!.nome}${taskEmExecucao!.chegada}"));
        proximaExec = false;
      }
      indexInfoChegada++;
    }
    if (proximaExec) {
      taskEmExecucao = tipoExecucao();
      if (taskEmExecucao != null) {
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2),
            "${taskEmExecucao!.nome}${taskEmExecucao!.chegada}"));
      } else {
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.count.toStringAsFixed(2), " "));
      }
    }
    if (skipperButton) {
      notifyListeners();
    }
  }

  TaskLook? firstComeFirstServesProximaExecucao() {
    if (taskLook.isEmpty) {
      return null;
    }
    for (int i = 0; i < taskLook.length; i++) {
      if (taskLook[i].noZero) {
        return taskLook[i];
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
    if (taskEmExecucao != null && taskEmExecucao!.noZero) {
      taskEmExecucao!.controller.incrementNotifier();
      if (!taskEmExecucao!.noZero) {
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
          taskController.add(
            TaskController(
              task: task[i].copyWith(
                  novoNome: task[i].nome,
                  novoChegada: infoChegada[indexInfoChegada][i],
                  prioridade: task[i].prioridade,
                  novoTempo: jsonTodasTarefas[i]["Tempo"]),
            ),
          );
          taskLook.add(
            TaskLook(
              controller: taskController[taskController.length - 1],
            ),
          );
          chegouAlguem = true;
        }
      }
    }
    return chegouAlguem;
  }

  @override
  void dispose() {
    super.dispose();
    jsonTodasTarefas.clear();
    taskController.clear();
    taskLook.clear();
    informacaoDoEscalonamento.clear();
    tabelaDeChegada.clear();
    infoChegada.clear();
    columnRowEscalonamento.clear();
  }
}
