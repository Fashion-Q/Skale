## Sumário

- [Introdução](#introdução)
- [FCFS](#FCFS-First-Come-First-Serve-Não-Preemptivo)
- [SJF](#SJF-Shortest-Job-First-Não-Preemptivo)
- [SRTN](#SRTN-Shortest-Remaining-Time-Next-Preemptivo)
- [Prioridade](#Prioridade-Preemptivo)
- [Rate Monotonic](#Rate-Monotonic-Preemptivo)

  ## Introdução
    Aplicação feita na linguagem `Dart` utilizando o framework `flutter` que resolve algoritmos de escalonamento apresentado pelo professor André Luiz na aula de Sistemas Operacionais. Os algoritmos selecionados são: FCFS, SJF, SRTN, Prioridade, Rate Monotinic, Round Robin e DeadLine

  ## FCFS First Come First Serve Não-Preemptivo
    Executa o primeiro processo que está na fila até o tempo acabar e depois segue consecutivamente a fila.

  ## SJF Shortest Job First Não-Preemptivo
    Escolhe o processo que tem menos tempo de execução até finalizar. Ao finalizar, escolhe novamente o processo que tem menos tempo de execução.

  ## SRTN Shortest Remaining Time Next Preemptivo
    Escolhe o processo que tem menos tempo de execução, caso chegue um novo processo na fila, verifica se o tempo de execução de quem chegou é menor do que está sendo executado, se sim, há preempção para dar espaço ao processo que tem menos tempo de execução.

  ## Prioridade Preemptivo
    Executa o processo que tem a maior prioridade (dar preferência a valores menores), caso chegue um novo processo na fila, será feito uma checagem para verificar quem tem maior prioridade, se o novo processo tem maior prioridade, o que está sendo executado sai da fila para dar espaço para o que tem maior prioridade.

  ## Rate Monotonic Preemptivo
    Parecido com o de ##Prioridade, a diferença é que a `prioridade` vai depender do `período` da tarefa, a tarefa que tiver o menor `período` será executado. Caso chegue novos processo na fila, será feito checagem para ver quem tem o menor período e se houver, a tarefa sai da fila e dará espaço para quem tem menor `período`.
