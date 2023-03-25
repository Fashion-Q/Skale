import 'package:flutter/material.dart';
import '../controller/algorithm_controller.dart';
import '../share/box_decoration.dart';
import '../share/text_style.dart';
//import 'dart:developer';

class Prioridade extends StatelessWidget {
  const Prioridade({super.key, required this.controller});
  final SkaleController controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Algoritmo de Escalonamento",
          style: primaryStyle(size: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          margin: const EdgeInsets.all(10),
          decoration: boxDecorationAll(
              radius: 16, color: const Color.fromARGB(82, 6, 232, 191)),
          child: Column(
            children: [
              Container(
                width: size.width,
                height: 50,
                padding: const EdgeInsets.only(top: 8,bottom: 2,left: 8),
                decoration:
                    boxDecorationTopRightLeft(radius: 16, color: Colors.blue),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    boxDecorationBorderStroke(
                      cor: Colors.red,
                      borderWidth: 2,
                      child: IconButton(
                        onPressed: controller.allButton ? (){
                          
                        } : null,
                        icon: const Icon(
                          Icons.keyboard_arrow_up,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12,),
                    Text(
                      "Escolha o algoritmo",
                      style: primaryStyle(size: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width,
                height: 200,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: boxDecorationBottomLeftRight(
                  radius: 8,
                  color: const Color.fromARGB(255, 163, 163, 163),
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [],
                    )
                  ],
                ),
              ),
              Container(
                width: size.width,
                height: 40,
                margin: const EdgeInsets.only(bottom: 8),
                decoration:
                    boxDecorationTopRightLeft(radius: 16, color: Colors.blue),
                alignment: Alignment.center,
                child: Text(
                  controller.taskInfo[controller.taskInfo.length - 1],
                  style: primaryStyle(size: 20, color: Colors.white),
                ),
              ),
              Container(
                width: size.width,
                height: controller.fixHeightInfoTable(),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: boxDecorationTopRightLeft(
                  radius: 8,
                  color: Colors.amber,
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: controller.informacaoDoAlgoritmo,
                ),
              ),
              Container(
                width: size.width,
                height: 40,
                margin: const EdgeInsets.only(bottom: 8),
                decoration:
                    boxDecorationTopRightLeft(radius: 16, color: Colors.blue),
                alignment: Alignment.center,
                child: Text(
                  "Tempo de chegada (X) < ${controller.x.toStringAsFixed(2)}",
                  style: primaryStyle(size: 18, color: Colors.white),
                ),
              ),
              Container(
                decoration: boxDecorationTopRightLeft(
                  radius: 8,
                  color: Colors.amber,
                ),
                margin: const EdgeInsets.only(bottom: 8),
                child: SizedBox(
                  width: size.width,
                  height: controller.fixHeightTableChegada() + 2,
                  child: ListView(
                    reverse: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Row(
                        children: controller.tabelaDeChegada,
                      ),
                      const SizedBox(
                        width: 60,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: size.width,
                height: 55,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: boxDecorationTopRightLeft(
                  radius: 16,
                  color: Colors.grey,
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 40,
                      decoration:
                          boxDecorationTopLeft(radius: 16, color: Colors.blue),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Spacer(
                            flex: 1,
                          ),
                          Text(
                            "Fila",
                            style: primaryStyle(size: 18),
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: controller.queueWidget.isNotEmpty
                          ? controller.queueWidget
                          : <Widget>[],
                    ),
                    const SizedBox(
                      width: 60,
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width,
                color: Colors.blue,
                margin: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    Text(
                      "Tarefa em execução",
                      style: primaryStyle(size: 20, color: Colors.white),
                    ),
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: controller.widgetTaskEmExecucao(),
                    ),
                    //controller.widgetTaskEmExecucao(),
                    //parei aqui
                  ],
                ),
              ),
              Container(
                width: size.width,
                alignment: Alignment.center,
                color: const Color.fromARGB(72, 0, 150, 135),
                child: Text(
                  "Escalonamento ${controller.skaleCount.controller.count.toStringAsFixed(2)} < ${controller.x}",
                  style: primaryStyle(size: 18, color: Colors.black),
                ),
              ),
              Container(
                width: size.width,
                height: 60,
                margin: const EdgeInsets.only(bottom: 15),
                color: const Color.fromARGB(72, 0, 150, 135),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: controller.informacaoDoEscalonamento,
                            ),
                            Column(
                              children: [
                                Text(
                                  "X",
                                  style: primaryStyle(size: 16),
                                ),
                                Text(
                                  controller.skaleCount.controller.count
                                      .toStringAsFixed(2),
                                  style: primaryStyle(size: 16),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 80,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              //const SizedBox(height: 20,),
              SizedBox(
                width: size.width * 0.90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      color: const Color.fromARGB(104, 158, 158, 158),
                      width: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            color: controller.allButton ? Colors.blue : null,
                            child: IconButton(
                              onPressed: controller.allButton
                                  ? controller.tempoAnimacaoDescrementa
                                  : null,
                              icon: const Icon(
                                Icons.arrow_back_ios_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            controller.sleep.toString(),
                            style: primaryStyle(size: 20),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            width: 40,
                            color: controller.allButton ? Colors.blue : null,
                            child: IconButton(
                              onPressed: controller.allButton
                                  ? controller.tempoAnimacaoIncrementa
                                  : null,
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50,
                            color: controller.allButton &&
                                    controller.skaleCount.controller.count <
                                        controller.x
                                ? Colors.blue
                                : null,
                            child: IconButton(
                              onPressed: controller.allButton &&
                                      controller.skaleCount.controller.count <
                                          controller.x
                                  ? controller.playOrPauseButton
                                  : null,
                              icon: Icon(
                                controller.playButton
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: 50,
                            color: controller.allButton &&
                                    controller.skaleCount.controller.count <
                                        controller.x
                                ? Colors.blue
                                : null,
                            child: IconButton(
                              onPressed: controller.allButton &&
                                      controller.skaleCount.controller.count <
                                          controller.x
                                  ? controller.skipTaskAnimation
                                  : null,
                              icon: const Icon(
                                Icons.double_arrow_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: 50,
                            color: controller.allButton ? Colors.blue : null,
                            child: IconButton(
                              onPressed: controller.allButton
                                  ? controller.resetarAtual
                                  : null,
                              icon: const Icon(
                                Icons.restart_alt,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 50,
                margin: const EdgeInsets.only(top: 20),
                color: controller.allButton ? Colors.blue : null,
                child: IconButton(
                  onPressed: controller.testador,
                  icon: const Icon(
                    Icons.restart_alt,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}
