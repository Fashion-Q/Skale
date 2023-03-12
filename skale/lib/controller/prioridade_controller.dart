import 'dart:core';
import 'package:flutter/material.dart';
import '../entidade/tarefa.dart';
import '../module/skale_count_look.dart';
import '../module/task_look.dart';
import '../share/box_decoration.dart';
import '../share/text_style.dart';
import 'skale_count.dart';
import 'task_controller.dart';

class PrioridadeController extends ChangeNotifier {
  final List<Task> task;
  final List<Map<String, dynamic>> jsonTodasTarefas = [];
  final List<TaskController> taskController = [];
  final List<TaskLook> taskLook = [];
  final List<Widget> infoTable = [];
  final List<Widget> widgetsTableChegada = [];
  final List<List<double>> infoChegada = [];
  final List<Widget> columnRowEscalonamento = [];
  final SkaleCountLook skaleCount =
      SkaleCountLook(controller: SkaleCountController());
  bool counterNotifier = true;

  int indexInfoChegada = 0;
  //double escalonamentoX = 0.00;
  bool playButton = false;
  bool playButtonOnePerTime = true;
  bool skipperButton = true;
  bool allButton = true;
  int sleep = 100;

  TaskLook? taskEmExecucao;
  final List<String> info;
  final double x;

  PrioridadeController(
      {required this.task, required this.x, required this.info});

  void addTasks() {
    for (int i = 0; i < task.length; i++) {
      jsonTodasTarefas.add(task[i].toJason());
    }
    for (int i = 0; i < task.length; i++) {
      if (task[i].chegada == 0) {
        taskController.add(
          TaskController(task: task[i].copyWith(
                  novoNome: task[i].nome,
                  novoChegada: task[i].chegada,
                  prioridade: task[i].prioridade,
                  novoTempo: jsonTodasTarefas[i]["Tempo"])),
        );
        taskLook.add(
          TaskLook(controller: taskController[taskController.length - 1]),
        );
        indexInfoChegada = 1;
      }
    }
    taskEmExecucao = tipoExecucao();
    //taskEmExecucao = prioridadeProximaExecucao();

    for (int i = 0; i < info.length; i++) {
      List<Widget> text = [];
      text.add(
        Text(
          info[i],
          style: primaryStyle(size: 16),
        ),
      );
      for (int j = 0; j < task.length; j++) {
        text.add(
          Text(
            formatName(info[i], jsonTodasTarefas[j][info[i]]),
            style: primaryStyle(size: 16),
          ),
        );
      }
      infoTable.add(
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            children: text,
          ),
        ),
      );
    }
    widgetsTableChegada.add(addFirstTableTempoChegadaX());
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
        widgetsTableChegada.add(Column(
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
              "${taskEmExecucao!.controller.nome}${taskEmExecucao!.controller.chegada}"),
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
    ); //Cria uma row e a primeira string é só o numero
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

  String formatName(String chave, dynamic valor) {
    if (chave == "First Come First Serve") {
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
    if (info[info.length - 1] == "Prioridade") {
      return prioridadeProximaExecucao();
    } else if (info[info.length - 1] == "First Come First Serve") {
      return fcfsProximaExecucao();
    }
    return null;
  }

  void playOrPauseButton() async {
    if (skaleCount.controller.count < x) {
      playButton = !playButton;
      notifyListeners();
      if (playButton) {
        if (playButtonOnePerTime) {
          playButtonOnePerTime = false;
          while (playButton && skaleCount.controller.count < x) {
            //algoritimoDePrioridade();
            tipoAlgoritmo();
            await Future.delayed(Duration(milliseconds: sleep));
          }
          playButtonOnePerTime = true;
          if (skaleCount.controller.count == x) {
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
    // for (int i = 0; i < task.length; i++) {
    //   task[i].tempo = jsonTodasTarefas[i][info[2]];
    //   task[i].noZero = true;
    // }
    jsonTodasTarefas.clear();
    taskController.clear();
    taskLook.clear();
    infoTable.clear();
    widgetsTableChegada.clear();
    infoChegada.clear();
    columnRowEscalonamento.clear();
    taskEmExecucao = null;
    indexInfoChegada = 0;
    playButton = false;
    skipperButton = true;
    skaleCount.controller.count = 0.00;
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
    while (skaleCount.controller.count < x) {
      tipoAlgoritmo();
      //algoritimoDePrioridade();
    }
    counterNotifier = true;
    allButton = true;
    notifyListeners();
  }

  void tipoAlgoritmo() {
    if (info[info.length - 1] == "Prioridade") {
      algoritimoDePrioridade();
    } else if (info[info.length - 1] == "First Come First Serve") {
      algoritimoDeFCFS();
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

  bool incrementTask() {
    bool proximaExec = false;
    if (taskEmExecucao != null && taskEmExecucao!.controller.task.noZero) {
      taskEmExecucao!.controller.incrementNotifier();
      if (!taskEmExecucao!.controller.task.noZero) {
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
        if (infoChegada[indexInfoChegada][i] == skaleCount.controller.count) {
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

  void algoritimoDePrioridade() {
    skaleCount.controller.increment(counterNotifier);
    bool proximaExec = false;
    bool chegouAlguem = false;
    proximaExec = incrementTask();
    chegouAlguem = verificarSeAlguemChegouNaFila();
    if (chegouAlguem) {
      TaskLook? taskAnterior = taskEmExecucao;
      taskEmExecucao = tipoExecucao();
      if (taskAnterior != taskEmExecucao && taskEmExecucao != null) {
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.controller.count.toStringAsFixed(2),
            "${taskEmExecucao!.controller.nome}${taskEmExecucao!.controller.chegada}"));
      }
      indexInfoChegada++;
    } else if (proximaExec) {
      taskEmExecucao = tipoExecucao();
      if (taskEmExecucao != null) {
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.controller.count.toStringAsFixed(2),
            "${taskEmExecucao!.controller.nome}${taskEmExecucao!.controller.chegada}"));
      } else {
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.controller.count.toStringAsFixed(2), " "));
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
        : taskEmExecucao!.controller.prioridade!; //780
    int index = -1;
    for (int i = 0; i < taskLook.length; i++) {
      if (taskLook[i].controller.noZero &&
          prioridade > taskLook[i].controller.prioridade!) {
        prioridade = taskLook[i].controller.prioridade!;
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

  void algoritimoDeFCFS() {
    skaleCount.controller.increment(counterNotifier);
    //escalonamentoX = double.parse((escalonamentoX + 0.01).toStringAsFixed(2));
    bool proximaExec = false;
    bool chegouAlguem = false;
    proximaExec = incrementTask();
    chegouAlguem = verificarSeAlguemChegouNaFila();
    if (chegouAlguem) {
      if (taskEmExecucao == null) {
        taskEmExecucao = tipoExecucao();
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.controller.count.toStringAsFixed(2),
            "${taskEmExecucao!.controller.nome}${taskEmExecucao!.controller.chegada}"));
        proximaExec = false;
      }
      indexInfoChegada++;
    }
    if (proximaExec) {
      taskEmExecucao = tipoExecucao();
      if (taskEmExecucao != null) {
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.controller.count.toStringAsFixed(2),
            "${taskEmExecucao!.controller.nome}${taskEmExecucao!.controller.chegada}"));
      } else {
        columnRowEscalonamento.add(addColumnRowEscalonamento(
            skaleCount.controller.count.toStringAsFixed(2), " "));
      }
    }
    if (skipperButton) {
      notifyListeners();
    }
  }

  TaskLook? fcfsProximaExecucao() {
    if (taskLook.isEmpty) {
      return null;
    }
    for (int i = 0; i < taskLook.length; i++) {
      if (taskLook[i].controller.noZero) {
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
  int abismo = 0;
}
