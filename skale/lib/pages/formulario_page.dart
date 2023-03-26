import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/formulario_controller.dart';
import '../share/snackbar.dart';
import '../share/text_style.dart';

class FormularioPage extends StatelessWidget {
  const FormularioPage({super.key, required this.controller});
  final ListaDeFormulario controller;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Skale",
            style: primaryStyle(size: 20),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 8, right: 8, top: 12),
            child: Column(
              children: [
                Column(
                  children: controller.listForm,
                ),
                Visibility(
                  visible: controller.listForm.isNotEmpty,
                  child: Container(
                    color: Colors.black12,
                    width: size.width - 50,
                    margin: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.6,
                          child: Text(
                            "Escalonamento: ",
                            textAlign: TextAlign.end,
                            style: primaryStyle(size: 18),
                          ),
                        ),
                        Container(
                          width: 80,
                          margin: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: TextField(
                            controller: controller.escalonamento,
                            maxLength: 4, // 10 000 000
                            decoration: const InputDecoration(
                                counterText: "",
                                isCollapsed: true,
                                border: InputBorder.none),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  width: size.width * 0.91,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: controller.allButton
                            ? controller.removeLastForm
                            : null,
                        child: const Icon(Icons.remove),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: controller.allButton
                            ? () {
                                if (!controller.addForm(size)) {
                                  controller.controllSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    snackMessage(
                                      controller.mensagem,
                                    ),
                                  );
                                }
                              }
                            : null,
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                    onPressed: controller.listForm.isNotEmpty &&
                            controller.allButton
                        ? () async{
                            if (await controller.checkPrinciaisFuncionalidades()) {
                            } else if (controller.allButton) {
                              controller.controllSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                snackMessage(
                                  controller.mensagem,
                                ),
                              );
                            }
                          }
                        : null,
                    child: Text(
                      "Válidar Informações",
                      style: primaryStyle(size: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                    onPressed: controller.validarInformacoes 
                        ? () {
                            if (controller.validarInformacoes) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  controller.skaleP!,
                                ),
                              );
                            } else if (controller.allButton) {
                              controller.controllSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                snackMessage(
                                  controller.mensagem,
                                ),
                              );
                            }
                          }
                        : null,
                    child: Text(
                      "Página de Escalonamento",
                      style: primaryStyle(size: 18),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
