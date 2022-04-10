import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:helightv3/blocs/task_cubit.dart';
import 'package:helightv3/main.dart';
import 'package:helightv3/views/console_view.dart';
import 'package:helightv3/widgets/window.dart';
import 'package:meta/meta.dart';

part 'window_state.dart';

class WindowCubit extends Cubit<WindowState> {
  WindowCubit() : super(WindowInitial());

  late Size mq;
  late double maxW;
  late double maxH;
  late double maxOX;
  late double maxOY;

  void openDefaults(BuildContext context) {
    var list = state.windows.toList(growable: true);

    mq = MediaQuery.of(context).size;
    maxW = mq.width - 128;
    maxH = mq.height - 128;
    maxOX = (mq.width - maxW) / 2;
    maxOY = (mq.height - maxH - 64) / 4 - 8;

    emit(WindowUpdated(list, state.minimized));
  }

  void createdSized(Widget widget, String title, double width, double height, Widget icon) => pushToTop(
      Window(child: widget, width: width, height: height, title: title, image: icon,)
        ..offsetX = (maxW - width) / 2
        ..offsetY = (maxH - height) / 4
  );

  void createBig(Widget widget, String title, Widget icon) => windows.pushToTop(
      Window(child: widget, width: windows.maxW, height: windows.maxH, title: title, image: icon)
        ..offsetX = windows.maxOX
        ..offsetY = windows.maxOY
  );

  void pushToTop(Window window) {
    runAnalyticsOperation((analytics) {
      analytics.logScreenView(screenClass: window.child.runtimeType.toString(),
        screenName: window.title,
      );
    });
    var list = state.windows.toList(growable: true);
    list.remove(window);
    list.add(window);
    emit(WindowUpdated(list, state.minimized));
  }

  void hide(Window window) {
    var list = state.minimized.toList(growable: true);
    list.remove(window);
    list.add(window);
    emit(WindowUpdated(state.windows, list));
  }

  void show(Window window) {
    var list = state.minimized.toList(growable: true);
    list.remove(window);
    emit(WindowUpdated(state.windows, list));
  }

  void closeWindow(Window window) {
    var list = state.windows.toList(growable: true);
    list.remove(window);
    emit(WindowUpdated(list, state.minimized));
    try {
      tasks.closeRelatedTask(window);
    } catch(_,__) {}
  }

  Window resolve(String id) => state.windows.firstWhere((x) => x.id == id);
}

var windows = WindowCubit();
