import 'package:flutter/material.dart';
import 'package:helightv3/blocs/window_cubit.dart';
import 'package:helightv3/views/desktop_view.dart';
import 'package:helightv3/widgets/window.dart';

class TasklistItem extends StatefulWidget {
  TasklistItem({Key? key, required this.onSelect, required this.onUnselect, required this.image, required this.tooltip, this.data, required this.id}) : super(key: key);

  GestureTapCallback onSelect;
  GestureTapCallback onUnselect;
  Widget image;
  String tooltip;
  String id;
  dynamic data;

  late TasklistItemState currentState;

  bool get isSelected => windows.state.visible.any((element) => element.id == id);

  @override
  State<TasklistItem> createState() {
    currentState = TasklistItemState();
    return currentState;
  }
}

class TasklistItemState extends State<TasklistItem> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("# ${widget.tooltip} -> ${widget.data}");
        var newState = !widget.isSelected;
        if (newState) {
          widget.onSelect();
        } else {
          widget.onUnselect();
        }
        setState(() {});
      },
      child: Tooltip(
        message: widget.tooltip,
        waitDuration: Duration(milliseconds: 250),
        child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: HighlightedTask(child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: widget.image,
            ), selected: widget.isSelected)
        ),
      ),
    );
  }
}


class HighlightedTask extends StatelessWidget {
  HighlightedTask({required this.child, required this.selected, Key? key}) : super(key: key);

  Widget child;
  bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 64,
        width: 64,
        color: selected ? Colors.white.withOpacity(/* .15 */ 0) : Colors.transparent,
        child: Stack(children: [
          Positioned(child: child, left: 4, top: 12, right: 4, bottom: 12,),
          Positioned(child: Container(height: 2.5, decoration: BoxDecoration(
            color: selected ? Colors.white70 : Colors.transparent,
            borderRadius: BorderRadius.circular(90)
          ),), left: 24, right: 24, bottom: 6)
        ])
    );
  }
}