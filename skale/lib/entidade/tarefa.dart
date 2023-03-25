class Task {
  String nome;
  double periodo;
  double tempo;
  double chegada;
  double? deadLine;
  double? quantum;
  int? prioridade;
  bool noZero;
  bool boolExecucao;

  Task copyWith({
    String? novoNome,
    double? novoChegada,
    double? novoTempo,
    double? deadLine,
    double? quantum,
    int? prioridade,
    bool? novoNoZero,
    bool? novaTaskEmExecucao,
  }) =>
      Task(
          nome: novoNome ?? nome,
          periodo: periodo,
          tempo: novoTempo ?? tempo,
          chegada: novoChegada ?? chegada,
          deadLine: deadLine,
          quantum: quantum,
          prioridade: prioridade,
          noZero: novoNoZero ?? true,
          boolExecucao: novaTaskEmExecucao ?? false);

  Task(
      {required this.nome,
      required this.periodo,
      required this.tempo,
      required this.chegada,
      this.deadLine,
      this.quantum,
      this.prioridade,
      this.noZero = true,
      this.boolExecucao = false});

  Map<String, dynamic> toJason() => {
        "Tarefa(s)": nome,
        "Período": periodo,
        "Tempo": tempo,
        "Chegada": chegada,
        "DeadLine": deadLine,
        "Quantum": quantum,
        "Prioridade": prioridade,
      };
}
