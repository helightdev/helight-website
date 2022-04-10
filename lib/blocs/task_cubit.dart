import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:helightv3/widgets/tasklist_item.dart';
import 'package:helightv3/widgets/window.dart';
import 'package:meta/meta.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  void addTask(TaskInstance task) {
    var list = state.tasks.toList(growable: true);

    try {
      list.removeWhere((element) => element.id == task.id);
    } catch (_,__) {}

    list.add(task);
    emit(TaskUpdated(list));
  }

  void closeTask(TaskInstance task) {
    var list = state.tasks.toList(growable: true);
    list.remove(task);
    emit(TaskUpdated(list));
  }

  void closeRelatedTask(Window related) {
    var list = state.tasks.toList(growable: true);
    list.removeWhere((element) => element.id == related.id);
    emit(TaskUpdated(list));
  }

}

var tasks = TaskCubit();