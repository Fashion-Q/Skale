
import 'package:flutter/material.dart';

import '../controller/task_controller.dart';
import '../share/text_style.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key, required this.controller});
  final TaskController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        color: controller.task.noZero ? Colors.green : Colors.red,
        width: 60 + controller.fixWidth(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "${controller.task.nome}${controller.task.chegada.toStringAsFixed(2)}",
              style: primaryStyle(size: 16),
            ),
            Text(
              controller.task.tempo.toStringAsFixed(2),
              style: primaryStyle(size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
