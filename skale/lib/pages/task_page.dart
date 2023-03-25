import 'package:flutter/material.dart';
import 'package:skale/interface/task_interface.dart';
import '../entidade/tarefa.dart';
import '../share/text_style.dart';

class TaskPage extends StatelessWidget implements TaskInterface {
  const TaskPage({super.key, required this.task});
  @override
  final Task task;
  @override
  bool get boolExecucao => task.boolExecucao;
  @override
  String get nome => task.nome;
  @override
  int? get prioridade => task.prioridade;
  @override
  bool get noZero => task.noZero;
  @override
  double get chegada => task.chegada;
  @override
  double get periodo => task.periodo;
  @override
  double get dTempo => task.tempo;

  @override
  set setBoolExecucao(bool boo) {
    task.boolExecucao = boo;
  }

  double fixWidth() {
    double fixWidhtForTime = 0;
    double fixWidthForPeriod = 0;
    for (int i = 10;
        i <= double.parse(task.periodo.toString());
        i *= 10, fixWidthForPeriod += 11) {}
    for (int i = 10;
        i <= double.parse(task.tempo.toString());
        i *= 10, fixWidhtForTime += 11) {}
    return fixWidhtForTime > fixWidthForPeriod
        ? fixWidhtForTime
        : fixWidthForPeriod;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        color: task.boolExecucao ? Colors.amber : (task.noZero ? Colors.green : Colors.red),
        width: 60 + fixWidth(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "${task.nome}${task.chegada.toStringAsFixed(2)}",
              style: primaryStyle(size: 16),
            ),
            Text(
              task.tempo.toStringAsFixed(2),
              style: primaryStyle(size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
