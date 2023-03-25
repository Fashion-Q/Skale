import 'package:flutter/material.dart';
import 'package:skale/interface/task_interface.dart';
import '../controller/task_controller.dart';
import '../entidade/tarefa.dart';
import '../pages/task_page.dart';

class TaskLook extends StatelessWidget implements TaskInterface {
  const TaskLook({super.key, required this.controller});
  final TaskController controller;

  @override
  Task get task => controller.task;
  @override
  bool get boolExecucao => controller.task.boolExecucao;
  @override
  String get nome => controller.nome;
  @override
  int? get prioridade => controller.prioridade;
  @override
  bool get noZero => controller.noZero;
  @override
  double get chegada => controller.chegada;
  @override
  double get periodo => controller.periodo;
  @override
  double get dTempo => controller.dTempo;
  
  @override
  set setBoolExecucao(bool boo) {
    controller.task.boolExecucao = boo;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => TaskPage(
        task: controller.task,
      ),
    );
  }
  
}
