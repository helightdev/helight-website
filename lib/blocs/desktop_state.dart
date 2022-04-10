part of 'desktop_cubit.dart';

@immutable
class DesktopState {

  List<Widget> popups;

//<editor-fold desc="Data Methods">

  DesktopState({
    required this.popups,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DesktopState &&
          runtimeType == other.runtimeType &&
          popups == other.popups);

  @override
  int get hashCode => popups.hashCode;

  @override
  String toString() {
    return 'DesktopState{' + ' popups: $popups,' + '}';
  }

  DesktopState copyWith({
    List<Widget>? popups,
  }) {
    return DesktopState(
      popups: popups ?? this.popups,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'popups': this.popups,
    };
  }

  factory DesktopState.fromMap(Map<String, dynamic> map) {
    return DesktopState(
      popups: map['popups'] as List<Widget>,
    );
  }

//</editor-fold>
}
