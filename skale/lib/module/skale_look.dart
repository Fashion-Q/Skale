import 'package:flutter/material.dart';

import '../controller/algorithm_controller.dart';
import '../pages/prio_page.dart';

class SkaleLook extends StatelessWidget {
  const SkaleLook({super.key, required this.controller});
  final SkaleController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Prioridade(controller: controller),
    );
  }
}
