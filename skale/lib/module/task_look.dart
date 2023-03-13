import 'package:flutter/material.dart';
import '../controller/task_controller.dart';
import '../pages/task_page.dart';

class TaskLook extends StatelessWidget {
  const TaskLook({super.key, required this.controller});
  final TaskController controller;
  String get nome => controller.nome;
  int? get prioridade => controller.prioridade;
  bool get noZero => controller.noZero;
  double get chegada => controller.chegada;
  double get periodo => controller.periodo;
  double get dTempo => controller.dTempo;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => TaskPage(
        controller: controller,
      ),
    );
  }
}
