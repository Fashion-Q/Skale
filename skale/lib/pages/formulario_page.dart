import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/formulario_controller.dart';
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
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  color: const Color.fromARGB(117, 189, 188, 185),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Período precisa ser >= 0.01",
                        style: primaryStyle(
                          size: 18,
                        ),
                      ),
                      Text(
                        "Tempo de execução precisa ser >= 0.01",
                        style: primaryStyle(
                          size: 18,
                        ),
                      ),
                      Text(
                        "Tamanho de tarefas precisa ser >= 1",
                        style: primaryStyle(size: 18),
                      ),
                      Text(
                        "Escalonamento precisa ser >= 1",
                        style: primaryStyle(size: 18),
                      ),
                    ],
                  ),
                ),
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
                            maxLength: 8, // 10 000 000
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
                        onPressed: controller.removeLastForm,
                        child: const Icon(Icons.remove),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () {
                          controller.addForm(size);
                        },
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
                            ? () {
                                if (controller.checkPrioridade()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          controller.prioridadeLook(),
                                    ),
                                  );
                                } else if (controller.allButton) {
                                  controller.controllSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    controller.snackMessage(
                                        "Algoritmo de Prioridade não está de acordo"),
                                  );
                                }
                              }
                            : null,
                    child: Text(
                      "Prioridade",
                      style: primaryStyle(size: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                    onPressed:
                        controller.listForm.isNotEmpty && controller.allButton
                            ? () {
                                if (controller.checkFCFS()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          controller.fcfsLook(),
                                    ),
                                  );
                                } else if (controller.allButton) {
                                  controller.controllSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    controller.snackMessage("Algoritmo de FCFS não está de acordo"),
                                  );
                                }
                              }
                            : null,
                    child: Text(
                      "FCFS - First Come First Serve",
                      style: primaryStyle(size: 20),
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
