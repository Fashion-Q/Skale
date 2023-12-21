import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../entidade/task_entity.dart';
import '../module/skale_look.dart';
import '../share/box_decoration.dart';
import '../share/text_style.dart';
import 'skale_controller.dart';

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
  SkaleLook? skaleP;
  final List<bool> checarAlgoritmos = [
    true,
    true,
    true,
    true,
    true,
    true,
    true
  ];
  bool allButton = true;
  bool validarInformacoes = false;

  bool addForm() {
    if (listForm.length > 25) {
      mensagem = "O tamanho de tarefas não pode ser maior que 25";
      return false;
    }
    validarInformacoes = false;
    listForm.add(novoForm());
    notifyListeners();
    return true;
  }

  Widget getRow(
    int linha,
    int coluna,
    String nome,
    bool aberto,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 198,
          child: Text(
            nome,
            style: primaryStyle(size: 20),
            textAlign: TextAlign.end,
          ),
        ),
        Visibility(
          visible: coluna < 3,
          child: const Icon(
            Icons.star,
            color: Colors.blue,
            size: 18,
          ),
        ),
        Visibility(
          visible: coluna > 2,
          child: const Icon(
            Icons.star,
            color: Colors.transparent,
            size: 18,
          ),
        ),
        Container(
          width: 65,
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: TextField(
            controller: controller[linha][coluna],
            onChanged: (String? texto) {
              if (validarInformacoes) {
                validarInformacoes = false;
                notifyListeners();
              }
            },
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
          RegExp(r'^\d{1,4}(\.\d{0,2})?'),
          replacementString: '',
        ),
      ];
    } else {
      return [
        FilteringTextInputFormatter.digitsOnly,
      ];
    }
  }

  Widget novoForm() {
    List<Widget> rows = [];
    controller.add([]);
    controller[controller.length - 1] = List<TextEditingController>.generate(
        6, (index) => TextEditingController());

    for (int i = 0; i < 6; i++) {
      rows.add(getRow(controller.length - 1, i, info[i], true));
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: boxDecorationTopRightLeft(radius: 16, color: Colors.black12),
      child: Column(
        children: [
          Container(
            width: 360,
            height: 40,
            decoration:
                boxDecorationTopRightLeft(radius: 16, color: Colors.blue),
            alignment: Alignment.center,
            child: Text(
              "Tarefa: ${String.fromCharCode(listForm.length + 65)}",
              style: primaryStyle(size: 20, color: Colors.white),
            ),
          ),
          ...rows
          // Column(
          //   children: rows,
          // )
        ],
      ),
    );
  }

  void removeLastForm() {
    if (listForm.length > 1) {
      validarInformacoes = false;
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

  String mensagem = "";

  SkaleLook skalePage() {
    List<TaskEntity> tarefas = [];
    List<String> char = ["A"];
    int quant = listForm.length;
    for (int i = 0; i < quant - 1; i++) {
      int nextChar = char[i].codeUnitAt(0) + 1;
      char.add(String.fromCharCode(nextChar));
    }
    for (int i = 0; i < char.length; i++) {
      tarefas.add(
        TaskEntity(
          name: char[i],
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
      task: tarefas,
      x: double.parse(escalonamento.text),
      checarAlgoritmos: checarAlgoritmos,
    );
    a.setTasks();

    SkaleLook p = SkaleLook(
      controller: a,
    );
    return p;
  }

  Future<bool> checkFuncionalidades() async {
    validarInformacoes = false;
    allButton = false;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    /**
     * teoricamente, posicao 0,1 e 2 de checarAlgoritmos servem para fazer
     * a funcionalidade de FCFS, SJF, SRTN
     * A posicao 3 eh pra ver se o algoritmo de prioridade pode, e o Rate
     * monotonic (n lembro como faz isso) é sempre possível fazer também.
     * Posicao 5 é RoundRobin
     * posicao 6 é DeadLine
     */
    checarAlgoritmos[0] = checkPeriodo();
    checarAlgoritmos[1] = checkTempoExecucao();
    checarAlgoritmos[2] = checkChegada();
    checarAlgoritmos[3] = checkPrioridade();
    checarAlgoritmos[4] = true;
    checarAlgoritmos[5] = checkRoundRobin();
    checarAlgoritmos[6] = checkDeadLine();
    //principais funcionalidades sao as 3 primeira
    for (int i = 0; i < 3; i++) {
      if (!checarAlgoritmos[i]) {
        mensagem = "Preencha o campo de: ${info[i]}";
        mensagem = mensagem.substring(0, mensagem.length - 1);
        allButton = true;
        notifyListeners();
        return false;
      }
    }
    if (escalonamento.text.isEmpty || double.parse(escalonamento.text) < 1) {
      mensagem = 'Preencha o único campo de "Escalonamento"';
      allButton = true;
      notifyListeners();
      return false;
    }
    skaleP = skalePage();
    validarInformacoes = true;
    allButton = true;
    notifyListeners();
    return true;
  }

  bool checkPeriodo() {
    for (int i = 0; i < controller.length; i++) {
      if (controller[i][0].text.isEmpty ||
          double.parse(controller[i][0].text) <= 0.00) {
        return false;
      }
    }
    return true;
  }

  bool checkTempoExecucao() {
    for (int i = 0; i < controller.length; i++) {
      if (controller[i][1].text.isEmpty ||
          double.parse(controller[i][1].text) <= 0.00) {
        return false;
      }
    }
    return true;
  }

  bool checkChegada() {
    for (int i = 0; i < controller.length; i++) {
      if (controller[i][2].text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  bool checkPrioridade() {
    for (int i = 0; i < controller.length; i++) {
      if (controller[i][5].text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  bool checkRoundRobin() {
    for (int i = 0; i < controller.length; i++) {
      if (controller[i][4].text.isEmpty) {
        return false;
      } else if (double.parse(controller[i][4].text) <= 0) {
        return false;
      }
    }
    return true;
  }

  bool checkDeadLine() {
    for (int i = 0; i < controller.length; i++) {
      if (controller[i][3].text.isEmpty) {
        return false;
      } else if (double.parse(controller[i][3].text) <= 0) {
        return false;
      }
    }
    return true;
  }
}
