import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helightv3/widgets/console_loading_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/desktop_cubit.dart';
import '../main.dart';
import '../widgets/consent_popup.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAfiWVv5bX4ar1foV6fCJ6gt2lR6cE4MFg",
            appId: "1:820559131212:web:b35046ccf7f14c63ebbae9",
            messagingSenderId: "820559131212",
            projectId: "helightdev-fe5b4"));
    await FirebaseRemoteConfig.instance.fetchAndActivate();
    var preferences = await SharedPreferences.getInstance();
    var isConsentChecked = preferences.getBool("isAnalyticsConsentChecked") ?? false;
    if (!isConsentChecked) {
      desktop.addPopup(ConsentPopup());
    }
    var isAnalyticsEnabled = preferences.getBool("isAnalyticsEnabled") ?? false;
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(isAnalyticsEnabled);
    localization = await getTranslation("de");

    GoogleFonts.ubuntuMono();
    GoogleFonts.openSans();

    await preloadImage("assets/background.jpg");
    await preloadImage("assets/icons/julis.png");

    await Future.delayed(Duration(seconds: 3));
    isLoaded = true;
    Get.toNamed("/desktop");
  }

  Future preloadImage(String path) async {
    Completer completer = Completer();
    AssetImage(path).resolve(ImageConfiguration.empty).addListener(ImageStreamListener((image, b) {
      completer.complete();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF18191c),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Booting up", style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(.88)),),
            SizedBox(height: 4,),
            Text("Helight OS", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),),
            SizedBox(height: 32,),
            SizedBox(child: ConsoleLoadingAnimation(color: "#E56871".toColor(),), width: 40, height: 40,)
          ],
        ),
      ),
    );
  }
}
