import 'package:flutter/material.dart';

import '../controller/skale_count_controller.dart';
import '../pages/skale_count_page.dart';

class SkaleCountLook extends StatelessWidget {
  const SkaleCountLook({super.key, required this.controller});
  final SkaleCountController controller;
  Function(bool) get increment => controller.increment;
  double get count => controller.count;
  set setCounter(double novoValor) {
    controller.count = novoValor;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => SkaleCount(controller: controller),
    );
  }
}
