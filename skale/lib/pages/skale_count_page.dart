
import 'package:flutter/material.dart';

import '../controller/skale_count_controller.dart';
import '../share/text_style.dart';

class SkaleCount extends StatelessWidget {
  const SkaleCount({super.key, required this.controller});
  final SkaleCountController controller;
  @override
  Widget build(BuildContext context) {
    return Text(
      controller.count.toStringAsFixed(2),
      style: primaryStyle(size: 16),
    );
  }
}
