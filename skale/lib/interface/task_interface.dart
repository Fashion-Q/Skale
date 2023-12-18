import 'package:flutter/material.dart';
import '../entidade/task_entity.dart';

abstract class TaskInterface extends Widget {
  const TaskInterface({super.key});
  set setIsOnPromptBool(bool boo);
  TaskEntity get taskEntity;
  bool get isOnPrompt;
  String get name;
  int? get prioridade;
  bool get timeIsNotFinished;
  double get chegada;
  double get periodo;
  double get dTempo;
  double? get quantum;
  double? get deadLine;
}
