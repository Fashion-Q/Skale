import 'package:flutter/material.dart';
import 'package:skale/interface/task_interface.dart';
import '../entidade/task_entity.dart';
import '../share/text_style.dart';

class TaskPage extends StatelessWidget implements TaskInterface {
  const TaskPage(
      {super.key, required this.taskEntity, required this.tipoAlgoritmo});
  final String tipoAlgoritmo;
  @override
  final TaskEntity taskEntity;
  @override
  bool get isOnPrompt => taskEntity.isOnPrompt;
  @override
  String get name => taskEntity.name;
  @override
  int? get prioridade => taskEntity.prioridade;
  @override
  double? get quantum => taskEntity.quantum;
  @override
  double? get deadLine => taskEntity.deadLine;
  @override
  bool get timeIsNotFinished => taskEntity.timeIsNotFinished;
  @override
  double get chegada => taskEntity.chegada;
  @override
  double get periodo => taskEntity.periodo;
  @override
  double get dTempo => taskEntity.tempo;

  @override
  set setIsOnPromptBool(bool boo) {
    taskEntity.isOnPrompt = boo;
  }

  double fixWidth() {
    double fixWidhtForTime = 0;
    double fixWidthForPeriod = 0;
    double roundRobin = 0;
    double deadLine = 0;
    for (int i = 10;
        i <= double.parse(periodo.toString());
        i *= 10, fixWidthForPeriod += 11) {}
    for (int i = 10;
        i <= double.parse(dTempo.toString());
        i *= 10, fixWidhtForTime += 11) {}
    if (tipoAlgoritmo == "Round Robin") {
      for (int i = 10;
          i <= double.parse(quantum.toString());
          i *= 10, roundRobin += 11) {}
    }
    if (tipoAlgoritmo == "DeadLine") {
      for (int i = 10;
          i <= double.parse(deadLine.toString());
          i *= 10, deadLine += 11) {}
    }
    double maiorNumero = fixWidhtForTime;
    if (fixWidhtForTime < fixWidthForPeriod) maiorNumero = fixWidthForPeriod;
    if (fixWidthForPeriod < roundRobin) maiorNumero = roundRobin;
    if (roundRobin < deadLine) maiorNumero = deadLine;
    return maiorNumero;
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        color: isOnPrompt
            ? Colors.amber
            : (tipoAlgoritmo == "Round Robin" && quantum == 0 && dTempo != 0)
                ? const Color.fromARGB(205, 211, 70, 0)
                : (timeIsNotFinished ? Colors.green : Colors.red),
        width: 60 + fixWidth(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "$name${chegada.toStringAsFixed(2)}",
              style: primaryStyle(size: 16),
            ),
            Text(
              dTempo.toStringAsFixed(2),
              style: primaryStyle(size: 16),
            ),
            Visibility(
              visible: tipoAlgoritmo == "Round Robin",
              child: Text(
                quantum != null ? quantum!.toStringAsFixed(2) : "",
                style: primaryStyle(size: 16),
              ),
            ),
            Visibility(
              visible: tipoAlgoritmo == "DeadLine",
              child: Text(
                deadLine != null ? deadLine!.toStringAsFixed(2) : "",
                style: primaryStyle(size: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
