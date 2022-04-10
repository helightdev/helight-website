part of 'window_cubit.dart';

abstract class WindowState {

  List<Window> windows = List.empty();
  List<Window> minimized = List.empty();

  List<Window> get visible => windows.toList(growable: true)..removeWhere((element) => minimized.contains(element));

}

class WindowInitial extends WindowState {}

class WindowUpdated extends WindowState {

  List<Window> windows;
  List<Window> minimized;
  WindowUpdated(this.windows, this.minimized);
}
