import 'package:flutter/material.dart';
import '../controller/task_controller.dart';
import '../pages/task_page.dart';

class TaskLook extends StatelessWidget {
  const TaskLook({super.key, required this.controller});
  final TaskController controller;

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
