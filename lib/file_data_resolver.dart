import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helightv3/atom_one_dark_helight_variation.dart';
import 'package:helightv3/command_manager.dart';
import 'package:helightv3/virtual_fs.dart';
import 'package:helightv3/widgets/console_loading_animation.dart';
import 'package:url_launcher/url_launcher.dart';

typedef ImageBuilder = Widget Function(Uint8List image, double, double);

Widget resolveFileContent(
    String cursor,
    CommandSystem? system,
    String format,
    dynamic value,
    VoidCallback doSomethingSneaky,
    ImageBuilder imageBuilder,
    EdgeInsets padding,
    EdgeInsets fullScreenPadding) {
  switch (format) {
    case "error":
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 16),
        child: Text(value, style: TextStyle(color: Color(0xffe06c75))),
      );
    case "link":
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 16),
        child: GestureDetector(
          onTap: () {
            launch(value);
          },
          child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(value, style: TextStyle(color: Color(0xff61aeee)))),
        ),
      );
    case "deferred-fs":
      var future = value as Completer;
      if (!future.isCompleted) {
        return Padding(
          padding: padding,
          child: Row(
            children: [
              SizedBox(
                child: ConsoleLoadingAnimation(),
                width: 10,
                height: 10,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Loading deferred file",
                style: TextStyle(color: Color(0xffabb2bf)),
              ),
            ],
          ),
        );
      } else
        return Container();
    case "cursor":
      return Padding(
        padding: padding,
        child: Row(
          children: [
            Text("guest@helight.dev",
                style: TextStyle(color: Color(0xff61aeee))),
            Text(":", style: TextStyle(color: Color(0xffabb2bf))),
            Text(cursor, style: TextStyle(color: Color(0xff5c6370))),
            Text("\$ ", style: TextStyle(color: Color(0xffabb2bf))),
            Text(value, style: TextStyle(color: Color(0xffabb2bf))),
          ],
        ),
      );
    case "png":
      return Padding(
          padding: fullScreenPadding,
          child: _resolveImage(value, imageBuilder));
    case "jpg":
      return Padding(
          padding: fullScreenPadding,
          child: _resolveImage(value, imageBuilder));
    case "void":
      return Container();
    default:
      if (format == "homework") doSomethingSneaky();
      var viewbody = "";
      if (value is String) viewbody = value;
      if (value is Uint8List) {
        try {
          viewbody = utf8.decode(value);
        } catch (e) {
          viewbody = "Can't decode string: Invalid UTF-8 data";
        }
      }
      return Padding(
        padding: padding,
        child: HighlightView(
          viewbody,
          language: format,
          theme: atomOneDarkThemeHelightVariation,
          textStyle: GoogleFonts.ubuntuMono(),
        ),
      );
  }
}

Widget _resolveImage(Uint8List data, ImageBuilder builder) {
  return FutureBuilder<ui.Image>(
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return builder(data, snapshot.data!.width.toDouble(),
            snapshot.data!.height.toDouble());
      },
      future: _getUiImage(data));
}

Future<ui.Image> _getUiImage(Uint8List data) async {
  var completer = Completer<ui.Image>();
  ui.decodeImageFromList(data, (result) {
    completer.complete(result);
  });
  return await completer.future;
}
