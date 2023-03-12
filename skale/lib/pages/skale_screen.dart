
import 'package:flutter/material.dart';

import '../module/skale_look.dart';
import '../share/text_style.dart';

class ScaleScreen extends StatelessWidget {
  const ScaleScreen({super.key, required this.prioridade});
  final SkaleLook prioridade;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Algoritmo de Escalonamento",
          style: primaryStyle(size: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            prioridade,
          ],
        ),
      ),
    );
  }
}
