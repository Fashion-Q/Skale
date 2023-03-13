import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../entidade/tarefa.dart';
import '../module/skale_look.dart';
import '../share/text_style.dart';
import 'algorithm_controller.dart';

class ListaDeFormulario extends ChangeNotifier {
  final List<Widget> listForm = [];
  final List<List<TextEditingController>> controller = [];
  final TextEditingController escalonamento = TextEditingController();
  final List<String> info = [
    "Período:",
    "Tempo de execução:",
    "Chegada:",
    "Deadline:",
    "Quantum:",
    "Prioridade:"
  ];
  bool allButton = true;

  void addForm(Size size) {
    listForm.add(novoForm(size));
    notifyListeners();
  }

  Widget getRow(
    int linha,
    int coluna,
    String nome,
    Size size,
    bool aberto,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: size.width * 0.6,
          child: Text(
            nome,
            style: primaryStyle(size: 20),
            textAlign: TextAlign.end,
          ),
        ),
        Container(
          width: 80,
          margin: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: TextField(
            controller: controller[linha][coluna],
            maxLength: nome == info[5] ? 2 : null,
            enabled: aberto,
            decoration: const InputDecoration(
                counterText: "", isCollapsed: true, border: InputBorder.none),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: tipoRestricao(nome),
          ),
        ),
      ],
    );
  }

  List<TextInputFormatter> tipoRestricao(String nome) {
    if (nome != info[5]) {
      return [
        FilteringTextInputFormatter.allow(
          RegExp(r'^\d{1,8}(\.\d{0,2})?'),
          replacementString: '',
        ),
      ];
    } else {
      return [
        FilteringTextInputFormatter.digitsOnly,
      ];
    }
  }

  Widget novoForm(Size size) {
    List<Widget> rows = [];
    controller.add([]);
    controller[controller.length - 1] = List<TextEditingController>.generate(
        6, (index) => TextEditingController());

    for (int i = 0; i < 6; i++) {
      rows.add(getRow(controller.length - 1, i, info[i], size, true));
    }

    return Container(
      color: Colors.black12,
      width: size.width - 50,
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        children: rows,
      ),
    );
  }

  void removeLastForm() {
    if (listForm.isNotEmpty) {
      listForm.removeAt(listForm.length - 1);
      controller.removeAt(controller.length - 1);
    }
    notifyListeners();
  }

  void controllSnackBar() async {
    allButton = false;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 7));
    allButton = true;
    notifyListeners();
  }

  SnackBar snackMessage(String texto) {
    return SnackBar(
      content: Text(
        texto,
        style: primaryStyle(size: 18),
      ),
      duration: const Duration(seconds: 7),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (int i = 0; i < controller.length; i++) {
      for (int j = 0; j < controller[controller[i].length].length; j++) {
        controller[i][j].dispose();
      }
    }
    escalonamento.dispose();
  }
  //######################################################
  //######################################################
  //######################################################
  //######################################################
  //######################################################
  //######################################################
  //######################################################
  //######################################################
  //######################################################
  //######################################################
  //######################################################
  //######################################################
  //######################################################
  //######################################################
  //######################################################
  //######################################################
  //######################################################
  //######################################################
  //######################################################
  //######################################################

  SkaleLook skalePage({required String tipoAlgoritmo}) {
    List<Task> tarefa = [];
    List<String> char = ["A"];
    int quant = listForm.length;
    for (int i = 0; i < quant - 1; i++) {
      int nextChar = char[i].codeUnitAt(0) + 1;
      char.add(String.fromCharCode(nextChar));
    }
    for (int i = 0; i < char.length; i++) {
      tarefa.add(
        Task(
          nome: char[i],
          periodo: double.parse(controller[i][0].text),
          tempo: double.parse(controller[i][1].text),
          chegada: double.parse(controller[i][2].text),
          deadLine: controller[i][3].text.isNotEmpty
              ? double.parse(controller[i][3].text)
              : null,
          quantum: controller[i][4].text.isNotEmpty
              ? double.parse(controller[i][4].text)
              : null,
          prioridade: controller[i][5].text.isNotEmpty
              ? int.parse(controller[i][5].text)
              : null,
        ),
      );
    }
    SkaleController a = SkaleController(
        task: tarefa,
        x: double.parse(escalonamento.text),
        taskInfo: ["Tarefa(s)", "Período", "Tempo", "Chegada", tipoAlgoritmo]);
    a.addTasks();

    SkaleLook p = SkaleLook(
      controller: a,
    );
    return p;
  }

  bool checkPrioridade() {
    for (int i = 0; i < controller.length; i++) {
      for (int j = 0; j < controller[i].length; j++) {
        if (controller[i][j].text.isEmpty && j != 3 && j != 4) {
          return false;
        } else if ((j == 0 || j == 1) &&
            double.parse(controller[i][j].text) <= 0.00) {
          return false;
        }
      }
    }
    if (escalonamento.text.isEmpty || double.parse(escalonamento.text) < 1) {
      return false;
    }
    return true;
  }

  bool checkPeriodoTempoChegada() {
    for (int i = 0; i < controller.length; i++) {
      for (int j = 0; j < 3; j++) {
        if (controller[i][j].text.isEmpty) {
          return false;
        } else if (j != 2 && double.parse(controller[i][j].text) <= 0.00) {
          return false;
        }
      }
    }
    if (escalonamento.text.isEmpty || double.parse(escalonamento.text) < 1) {
      return false;
    }
    return true;
  }
}
