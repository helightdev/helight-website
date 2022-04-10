part of 'task_cubit.dart';

abstract class TaskState {

  List<TaskInstance> tasks = List.empty();

}

class TaskInstance {

  Widget image;
  String tooltip;
  String id;
  bool isSelected;

  TaskInstance({required this.image, required this.tooltip, required this.id, this.isSelected = true});

}

class TaskInitial extends TaskState {
  List<TaskInstance> tasks = List.empty();
}

class TaskUpdated extends TaskState {
  List<TaskInstance> tasks;
  TaskUpdated(this.tasks);
}