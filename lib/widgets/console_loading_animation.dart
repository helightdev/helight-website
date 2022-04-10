import 'package:flutter/material.dart';

class ConsoleLoadingAnimation extends StatefulWidget {

  Color? color;

  ConsoleLoadingAnimation({Key? key, this.color}) : super(key: key);

  @override
  _ConsoleLoadingAnimationState createState() =>
      _ConsoleLoadingAnimationState();
}

class _ConsoleLoadingAnimationState extends State<ConsoleLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int animationValue = 0;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _controller.addListener(() {
      setState(() {});
    });
    _controller.addStatusListener((status) {
      animationValue++;
    });
    _controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tile = animationValue % 4;
    return GridView.count(crossAxisCount: 2, children: [
      Container(color: tile == 0 ? Colors.transparent : widget.color ?? Colors.white),
      Container(color: tile == 1 ? Colors.transparent : widget.color ?? Colors.white),
      Container(color: tile == 3 ? Colors.transparent : widget.color ?? Colors.white),
      Container(color: tile == 2 ? Colors.transparent : widget.color ?? Colors.white),
    ], crossAxisSpacing: 2, mainAxisSpacing: 2,);
  }
}
