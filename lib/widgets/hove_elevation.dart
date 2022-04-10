import 'package:flutter/material.dart';

typedef HoverWidgetBuilder = Widget Function(BuildContext context, double elevation);

class HoverElevation extends StatefulWidget {
  HoverElevation({Key? key, required this.builder}) : super(key: key);

  HoverWidgetBuilder builder;

  @override
  _HoverElevationState createState() => _HoverElevationState();
}

class _HoverElevationState extends State<HoverElevation> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _controller.addListener(() {
      setState(() {});
    });
    var curved = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    animation = curved.drive(Tween(begin: 0, end: 1));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: widget.builder(context, animation.value),
    );
  }
}
