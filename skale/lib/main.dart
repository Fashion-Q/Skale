import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'controller/algorithm_controller.dart';
import 'entidade/tarefa.dart';
//import 'module/formulario_look.dart';
//import 'controller/formulario_controller.dart';
import 'module/skale_look.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const Root(),
    ),
  );
}

// void main() {
//   runApp(const Root());
// }

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: "Scaling Algorithm",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: FormularioLook(controller: ListaDeFormulario()),
      home: teste(),
    );
  }
}

SkaleLook teste() {
  List<Task> tarefa = [];
  List<String> char = ["A"];
  int quant = 2;
  for (int i = 0; i < quant; i++) {
    int nextChar = char[i].codeUnitAt(0) + 1;
    char.add(String.fromCharCode(nextChar));
  }

  List<double> periodo = [5, 10, 15];
  for (int i = 0; i < char.length; i++) {
    tarefa.add(
      Task(
          nome: char[i],
          periodo: periodo[i],
          tempo: (i + 1) * 2.4,
          chegada: 0,
          prioridade: i),
    );
  }
  final List<Map<String, dynamic>> jsonTodasTarefas = [];
  for (int i = 0; i < tarefa.length; i++) {
      jsonTodasTarefas.add(tarefa[i].toJason());
    }
  SkaleController a = SkaleController(task: tarefa, x: 50, taskInfo: [
    "Tarefa(s)",
    "Período",
    "Tempo",
    "Chegada",
    "Prioridade"
  ],jsonTodasTarefas: jsonTodasTarefas);
  a.setTasks();
  //Shortest Job First
  //"Shortest Remaining Time Next"
  //Rate Monotonic
  //"First Come First Serve"
  //Prioridade
  SkaleLook p = SkaleLook(
    controller: a,
  );

  return p;
}
