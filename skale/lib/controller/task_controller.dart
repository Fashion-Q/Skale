import 'package:flutter/material.dart';

import '../entidade/tarefa.dart';

class TaskController extends ChangeNotifier {
  Task task;
  TaskController({required this.task});

  void incrementNotifier() {
    task.tempo = double.parse((task.tempo - 0.01).toStringAsFixed(2));
    if (task.tempo <= 0) {
      task.tempo = 0;
      task.noZero = false;
    }
    notifyListeners();
  }

  void justNotifier() {
    notifyListeners();
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

  String get nome => task.nome;
  double get periodo => task.periodo;
  int? get prioridade => task.prioridade;
  bool get noZero => task.noZero;
  double get chegada => task.chegada;
  double get dTempo => task.tempo;
}
