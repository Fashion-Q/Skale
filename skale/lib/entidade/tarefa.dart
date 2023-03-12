class Task {
  String nome;
  double periodo;
  double tempo;
  double chegada;
  double? deadLine;
  double? quantum;
  int? prioridade;
  bool noZero = true;

  Task copyWith(
    {
      required String novoNome,
      required double novoChegada,
      required double novoTempo,
      double? deadLine,
      double? quantum,
      int? prioridade,
    }
  ) => Task(
      nome: novoNome,
      periodo: periodo,
      tempo: novoTempo,
      chegada: novoChegada,
      deadLine: deadLine,
      quantum: quantum,
      prioridade: prioridade);

  Task({
    required this.nome,
    required this.periodo,
    required this.tempo,
    required this.chegada,
    this.deadLine,
    this.quantum,
    this.prioridade,
  });

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
