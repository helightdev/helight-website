import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedGlass extends StatelessWidget {
  FrostedGlass({Key? key, required this.child}) : super(key: key);

  Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        child: BackdropFilter(
            child: Container(child: child, color: Colors.black12,),
          filter: ImageFilter.blur(
            sigmaY: 10,
            sigmaX: 10,
            tileMode: TileMode.mirror
          ),
        ),
      ),
    );
  }
}
