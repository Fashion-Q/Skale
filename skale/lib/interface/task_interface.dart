import 'package:flutter/material.dart';
import '../entidade/tarefa.dart';

abstract class TaskInterface extends Widget {
  const TaskInterface({super.key});
// set setCounter(double novoValor) {
//     controller.count = novoValor;
//   }
  set setBoolExecucao(bool boo);
  Task get task;
  bool get boolExecucao;
  String get nome;
  int? get prioridade;
  bool get noZero;
  double get chegada;
  double get periodo;
  double get dTempo;
}
