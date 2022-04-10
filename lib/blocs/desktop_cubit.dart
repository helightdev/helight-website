import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../widgets/quick_menu.dart';

part 'desktop_state.dart';

var desktop = DesktopCubit();

class DesktopCubit extends Cubit<DesktopState> {
  DesktopCubit() : super(DesktopState(popups: List.empty()));

  void addPopup(Widget widget) {
   emit(state.copyWith(popups: state.popups.toList()..add(widget)));
  }

  void removePopupsOfType<T>() {
    emit(state.copyWith(popups: state.popups.toList()..removeWhere((element) => element is T)));
  }

  bool isPopup<T>() => state.popups.where((element) => element is T).isNotEmpty;

  void clickOutside() {
    removePopupsOfType<QuickMenu>();
  }

  void removePopup(Widget widget) {
    emit(state.copyWith(popups: state.popups.toList()..remove(widget)));
  }

}
