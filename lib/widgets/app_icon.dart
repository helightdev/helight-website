import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helightv3/blocs/window_cubit.dart';
import 'package:helightv3/widgets/window.dart';

class AppIcon extends StatelessWidget {

  String title;
  Widget image;
  Function action;

  AppIcon({required this.title, required this.image, required this.action});

  @override
  Widget build(BuildContext context) {
    var tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => action(),
      child: Tooltip(
        message: title,
        waitDuration: Duration(milliseconds: 250),
        child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child:  Stack(
              children: [
                Positioned.fill(child: ClipRRect(child: image, clipBehavior: Clip.antiAliasWithSaveLayer, borderRadius: BorderRadius.circular(8),),
                    top: 24, bottom: 24, left: 24, right: 24),
                Positioned(child: Text(title, textAlign: TextAlign.center, style: GoogleFonts.openSans(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.visible), bottom: 0, left: 0, right: 0,)
              ],
            )
        ),
      ),
    );
  }

  static AppIcon bigApplication({required String title, required String image, required Widget Function() widget}) {
    return AppIcon(title: title, image: Image.asset("assets/icons/" + image), action: () => windows.pushToTop(
        Window(child: widget(), width: windows.maxW, height: windows.maxH, title: title, image: Image.asset("assets/icons/" + image))
          ..offsetX = windows.maxOX
          ..offsetY = windows.maxOY
    ));
  }

  static AppIcon bigApplicationWidget({required String title, required Widget icon, Widget? windowIcon, required Widget Function() widget}) {
    return AppIcon(title: title, image: icon, action: () => windows.pushToTop(
        Window(child: widget(), width: windows.maxW, height: windows.maxH, title: title, image: windowIcon ?? icon)
          ..offsetX = windows.maxOX
          ..offsetY = windows.maxOY
    ));
  }

  static AppIcon sizedApplicationWidget({required String title, required Widget icon, required double width, required double height,Widget? windowIcon, required Widget Function() widget}) {
    return AppIcon(title: title, image: icon, action: () => windows.pushToTop(
        Window(child: widget(), width: width, height: height, title: title, image: windowIcon ?? icon)
          ..offsetX = (windows.maxW - width) / 2
          ..offsetY = (windows.maxH - height) / 4
    ));
  }

  static AppIcon sizedApplication({required String title, required String image, required double width, required double height, required Widget Function() widget}) {
    return AppIcon(title: title, image: Image.asset("assets/icons/" + image), action: () => windows.pushToTop(
        Window(child: widget(), width: width, height: height, title: title, image: Image.asset("assets/icons/" + image),)
          ..offsetX = (windows.maxW - width) / 2
          ..offsetY = (windows.maxH - height) / 4
    ));
  }

  static Widget buildIcon(IconData data, [Color? color,  Color? background]) {
    return Container(
      color: background ?? Color(0xFF18191c),
      child: Icon(data, size: 24, color: color ?? Colors.white,),
    );
  }
}
