
import 'package:flutter/material.dart';

import '../controller/formulario_controller.dart';
import '../pages/formulario_page.dart';

class FormularioLook extends StatelessWidget {
  const FormularioLook({super.key, required this.controller});
  final ListaDeFormulario controller;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => FormularioPage(
        controller: controller,
      ),
    );
  }
}
