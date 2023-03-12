
import 'package:flutter/material.dart';

import '../controller/skale_count.dart';
import '../pages/skale_count.dart';

class SkaleCountLook extends StatelessWidget {
  const SkaleCountLook({super.key, required this.controller});
  final SkaleCountController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => SkaleCount(controller: controller),
    );
  }
}
