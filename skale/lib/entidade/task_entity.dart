class TaskEntity {
  String name;
  double periodo;
  double tempo;
  double chegada;
  double? deadLine;
  double? quantum;
  int? prioridade;
  bool timeIsNotFinished;
  bool isOnPrompt;

  TaskEntity copyWith({
    String? novoNome,
    double? novoChegada,
    double? novoTempo,
    double? novoDeadLine,
    double? novoQuantum,
    int? novaPrioridade,
    bool? newTimeIsNotFinished,
    bool? novaTaskEmExecucao,
  }) =>
      TaskEntity(
          name: novoNome ?? name,
          periodo: periodo,
          tempo: novoTempo ?? tempo,
          chegada: novoChegada ?? chegada,
          deadLine: novoDeadLine ?? deadLine,
          quantum: novoQuantum ?? quantum,
          prioridade: novaPrioridade ?? prioridade,
          timeIsNotFinished: newTimeIsNotFinished ?? true,
          isOnPrompt: novaTaskEmExecucao ?? false);

  TaskEntity(
      {required this.name,
      required this.periodo,
      required this.tempo,
      required this.chegada,
      this.deadLine,
      this.quantum,
      this.prioridade,
      this.timeIsNotFinished = true,
      this.isOnPrompt = false});

  Map<String, dynamic> toJason() => {
        "Tarefa(s)": name,
        "Período": periodo,
        "Tempo": tempo,
        "Chegada": chegada,
        "DeadLine": deadLine,
        "Round Robin": quantum,
        "Prioridade": prioridade,
      };
}
