import 'package:flutter/material.dart';

import '../entidade/task_entity.dart';

class TaskController extends ChangeNotifier {
  TaskEntity task;
  TaskController({required this.task});

  void incrementNotifier() {
    task.tempo = double.parse((task.tempo - 0.01).toStringAsFixed(2));
    if (task.tempo <= 0) {
      task.tempo = 0;
      task.timeIsNotFinished = false;
    }
    notifyListeners();
  }

  void decrementQuantum() {
    if (task.quantum == null) {
      throw Exception("Tentando decrementar task quantum == null em $this");
    }
    task.quantum = double.parse((task.quantum! - 0.01).toStringAsFixed(2));
    if (task.quantum! <= 0) {
      task.quantum = 0;
      task.timeIsNotFinished = false;
    }
    notifyListeners();
  }

  void justNotifier() {
    notifyListeners();
  }

  String get nome => task.name;
  double get periodo => task.periodo;
  int? get prioridade => task.prioridade;
  bool get timeIsNotFinished => task.timeIsNotFinished;
  double get chegada => task.chegada;
  double get dTempo => task.tempo;
}
