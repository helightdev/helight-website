import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helightv3/blocs/desktop_cubit.dart';
import 'package:helightv3/mobile/mobile_view.dart';
import 'package:helightv3/models/localization.dart';
import 'package:helightv3/views/desktop_view.dart';
import 'package:helightv3/views/loading_view.dart';
import 'package:helightv3/widgets/consent_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension AnthraciteColorExtension on Color {
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}'
      '${alpha.toRadixString(16).padLeft(2, '0')}';

  Color combine(Color b) {
    return Color.alphaBlend(b, this);
  }

  MaterialColor singleColorSwatch() {
    return MaterialColor(this.value, {
      900: this.combine(Colors.white30),
      800: this.combine(Colors.white24),
      700: this.combine(Colors.white12),
      600: this.combine(Colors.white10),
      500: this,
      400: this.combine(Colors.black12),
      300: this.combine(Colors.black26),
      200: this.combine(Colors.black38),
      100: this.combine(Colors.black45),
      50: this.combine(Colors.black87)
    });
  }
}

extension AnthraciteStringExtension on String {
  Color toColor({bool fullOpacity = false}) {
    var c = _toColor();
    if (fullOpacity) return c.withOpacity(1.0);
    return c;
  }

  Color _toColor() {
    try {
      var color = _removeLeadingHash(this);

      if (color.length == 6) {
        return _sixCharHexToColor(color);
      }

      if (color.length == 3) {
        return _threeCharHexToColor(color);
      }

      if (color.length == 8) {
        return _eightCharHexToColor(color);
      }

      if (color.length == 4) {
        return _fourCharHexToColor(color);
      }
    } catch (error) {
      // will throw anyway
    }

    return Color.fromARGB(255, 0, 0, 0);
  }

  static String _removeLeadingHash(String color) {
    if (color.startsWith('#')) {
      return color.substring(1);
    }
    return color;
  }

  static Color _sixCharHexToColor(String color) {
    var r = color.substring(0, 2).toInt(radix: 16);
    var g = color.substring(2, 4).toInt(radix: 16);
    var b = color.substring(4, 6).toInt(radix: 16);
    return Color.fromARGB(255, r!, g!, b!);
  }

  static Color _threeCharHexToColor(String color) {
    var r = color.substring(0, 1).repeat(2).toInt(radix: 16);
    var g = color.substring(1, 2).repeat(2).toInt(radix: 16);
    var b = color.substring(2, 3).repeat(2).toInt(radix: 16);
    return Color.fromARGB(255, r!, g!, b!);
  }

  static Color _eightCharHexToColor(String color) {
    final r = color.substring(0, 2).toInt(radix: 16);
    final g = color.substring(2, 4).toInt(radix: 16);
    final b = color.substring(4, 6).toInt(radix: 16);
    final a = color.substring(6, 8).toInt(radix: 16);
    return Color.fromARGB(a!, r!, g!, b!);
  }

  static Color _fourCharHexToColor(String color) {
    final r = color.substring(0, 1).repeat(2).toInt(radix: 16);
    final g = color.substring(1, 2).repeat(2).toInt(radix: 16);
    final b = color.substring(2, 3).repeat(2).toInt(radix: 16);
    final a = color.substring(3, 4).repeat(2).toInt(radix: 16);
    return Color.fromARGB(a!, r!, g!, b!);
  }

  int? toInt({int radix = 10}) {
    try {
      return int.parse(this, radix: radix);
    } catch (error) {
      return null;
    }
  }

  int? get intValue => toInt();

  double? toDouble() {
    try {
      return double.parse(this);
    } catch (error) {
      return null;
    }
  }

  double? get doubleValue => toDouble();

  List<String> toList() {
    return split('');
  }

  List<String> lineSeparated(
      {bool detectWindows = false, bool forceWindows = false}) {
    bool isWindows = (detectWindows && contains("\r\n")) || forceWindows;
    return split(isWindows ? '\r\n' : "\n");
  }

  String get reverse {
    if (isEmpty) {
      return '';
    }
    return toList().reversed.reduce((value, element) => value += element);
  }

  String repeat(int n, {String separator = ''}) {
    var repeatedString = '';

    for (var i = 0; i < n; i++) {
      if (i > 0) {
        repeatedString += separator;
      }
      repeatedString += this;
    }

    return repeatedString;
  }

  String encodeBase64() {
    return base64Encode(utf8.encode(this));
  }

  String decodeBase64() {
    return base64UrlEncode(utf8.encode(this));
  }
}

void runAnalyticsOperation(Function(FirebaseAnalytics) fun) {
  fun(FirebaseAnalytics.instance);
}

Future<Localization> getTranslation(String lang) async {
  var data = await FirebaseFirestore.instance.doc("translations/$lang").get();
  return Localization.fromMap(data.data()!);
}

late Localization localization;

extension LocalizationExt on String {
  String get localized => localization.resolve(this);
}

void main() async {
  runApp(HelightDevApp());
}

bool isLoaded = false;

class HelightDevApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Helight",
      theme: ThemeData(
          primarySwatch: "#E56871".toColor().singleColorSwatch(),
          brightness: Brightness.dark),
      getPages: [
        GetPage(name: "/loading", page: () => LoadingView()),
        GetPage(name: "/desktop", page: () => MainView(), middlewares: [LoadingRouteGuard()])
      ],
      initialRoute: "/loading",
    );
  }
}

class MainView extends StatelessWidget {
  MainView({Key? key}) : super(key: key);

  var controller = PageController();

  @override
  Widget build(BuildContext context) {
    // Preload fonts
    GoogleFonts.ubuntuMono();
    GoogleFonts.openSans();

    var mq = MediaQuery.of(context);

    if (mq.size.height > mq.size.width) {
      return MobileView();
    }

    return Scaffold(
      backgroundColor: "#18191C".toColor(),
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: [DesktopView()],
      ),
    );
  }
}

var s = """
{
  "message": "Wow you really decoded this, I'm impressed. Here take a cookie!",
  "cookie": "🍪"
}
""";

class LoadingRouteGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!isLoaded) {
      print("Rerouting to loading");
      return RouteSettings(name: "/loading");
    }
    return null;
  }
}


class MobileRouteGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (Platform.isAndroid || Platform.isIOS) {
      return RouteSettings(name: "/mobile");
    }
    return null;
  }
}
