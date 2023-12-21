import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skale/share/drawer.dart';

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
        drawer: baseDrawer(),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 8, right: 8, top: 18),
            child: Column(
              children: [
                //Text(size.width.toString()),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 8, top: 8),
                  width: 360,
                  child: Column(
                    children: controller.listForm,
                  ),
                ),
                Visibility(
                  visible: controller.listForm.isNotEmpty,
                  child: Container(
                    color: Colors.black12,
                    width: 360,
                    margin: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Text(
                            "Escalonamento: ",
                            textAlign: TextAlign.end,
                            style: primaryStyle(size: 18),
                          ),
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.blue,
                          size: 18,
                        ),
                        Container(
                          width: 50,
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
                  width: size.width,
                  alignment: Alignment.center,
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
                                if (!controller.addForm()) {
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
                    onPressed:
                        controller.listForm.isNotEmpty && controller.allButton
                            ? () async {
                                if (await controller.checkFuncionalidades()) {
                                } else if (controller.allButton) {
                                  controller.controllSnackBar();
                                  // ignore: use_build_context_synchronously
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
                                  builder: (context) => controller.skaleP!,
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
