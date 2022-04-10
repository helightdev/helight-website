import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helightv3/blocs/task_cubit.dart';
import 'package:helightv3/blocs/window_cubit.dart';
import 'package:uuid/uuid.dart';

class Window extends StatefulWidget {
  String title;
  Widget image;

  Widget child;
  double offsetX = 0;
  double offsetY = 0;
  double width;
  double height;
  Color dragColor = Colors.black87;

  bool isTasked;
  String id = Uuid().v4();

  List<VoidCallback> shutdownHooks = List.empty(growable: true);

  late WidgetWindowState currentState;

  @override
  State<Window> createState() {
    currentState = WidgetWindowState();
    return currentState;
  }

  Window({
    required this.child,
    required this.title,
    required this.image,
    required this.width,
    required this.height,
    this.isTasked = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Window &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => super.hashCode ^ id.hashCode;

  @override
  String toString({DiagnosticLevel? minLevel}) {
    return '$title [$id]';
  }
}

class WidgetWindowState extends State<Window> {
  var isDragging = false;
  var hasHeader = true;

  @override
  void initState() {
    super.initState();
    tasks.addTask(TaskInstance(
        id: widget.id, tooltip: widget.title, image: widget.image));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        child: Draggable(
          child: isDragging ? Container() : window(context),
          feedback: window(context, replaceDrag: true),
          data: this,
          onDragStarted: () {
            isDragging = true;
            setState(() {});
          },
          onDragEnd: (details) {
            isDragging = false;
            widget.offsetX = details.offset.dx;
            widget.offsetY = details.offset.dy;
            setState(() {});
            windows.pushToTop(widget);
          },
        ),
        left: widget.offsetX,
        top: widget.offsetY,
        width: widget.width,
        height: widget.height + 32);
  }

  Widget window(BuildContext context, {bool replaceDrag = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GlassContainer.clearGlass(
        width: widget.width,
        height: widget.height + 32,
        borderColor: Colors.transparent,
        blur: 10,
        color: Colors.black54,
        child: Column(
          children: [
            GlassContainer(
              width: widget.width,
              height: 30,
              color: Colors.black.withOpacity(0.5),
              borderColor: Colors.transparent,
              child: !hasHeader
                  ? Container()
                  : Stack(
                      children: [
                        Center(
                            child: Material(
                          child: Text(widget.title,
                              style: GoogleFonts.roboto(
                                  color: Colors.white60,
                                  fontWeight: FontWeight.w600)),
                          color: Colors.transparent,
                        )),
                        Positioned(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    child: Icon(Icons.close,
                                        size: 24, color: Colors.white),
                                    height: 24,
                                    width: 24,
                                  ),
                                  onTap: () {
                                    widget.shutdownHooks.forEach((element) {
                                      element();
                                    });
                                    windows.closeWindow(widget);
                                  },
                                )
                              ],
                            ),
                          ),
                          right: 0,
                          top: 0,
                          bottom: 0,
                        )
                      ],
                    ),
            ),
            Container(
              height: widget.height,
              width: widget.width,
              child: replaceDrag
                  ? Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Icon(
                                Icons.visibility_off,
                                size: 48,
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              "content disabled while dragging",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              "for performance reasons",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(.85)),
                            )
                          ],
                        ),
                      ),
                    )
                  : Draggable(
                      feedback: Container(),
                      data: IgnorableDropData(),
                      child: widget.child),
            ),
          ],
        ),
      ),
    );
  }
}

class IgnorableDropData {}
