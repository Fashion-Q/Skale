import 'package:flutter/material.dart';
import 'package:skale/interface/task_interface.dart';
import '../controller/task_controller.dart';
import '../entidade/task_entity.dart';
import '../pages/task_page.dart';

class TaskLook extends StatelessWidget implements TaskInterface {
  const TaskLook(
      {super.key, required this.controller, required this.tipoAlgoritmo});
  final TaskController controller;

  final String tipoAlgoritmo;
  @override
  TaskEntity get taskEntity => controller.task;
  @override
  bool get isOnPrompt => controller.task.isOnPrompt;
  @override
  String get name => controller.nome;
  @override
  int? get prioridade => controller.prioridade;
  @override
  double? get quantum => taskEntity.quantum;
  @override
  double? get deadLine => taskEntity.deadLine;
  @override
  bool get timeIsNotFinished => controller.timeIsNotFinished;
  @override
  double get chegada => controller.chegada;
  @override
  double get periodo => controller.periodo;
  @override
  double get dTempo => controller.dTempo;

  @override
  set setIsOnPromptBool(bool boo) => controller.task.isOnPrompt = boo;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => TaskPage(
        taskEntity: controller.task,
        tipoAlgoritmo: tipoAlgoritmo,
      ),
    );
  }
}
