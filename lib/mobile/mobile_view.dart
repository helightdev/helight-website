import 'package:flutter/material.dart';
import 'package:helightv3/main.dart';

class MobileView extends StatelessWidget {
  MobileView();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.black,),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 64,),
                Spacer(),
                Image.asset("assets/logoBanner.png"),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text("Diese Webseite funktioniert aktuell nur mit Desktopgeräten.",
                        style: theme.textTheme.headline5!.copyWith(color: Colors.white), textAlign: TextAlign.center,),
                    ],
                  ),
                ),
                Spacer(),
                SizedBox(height: 32,)
              ],
            )
          ),
        ],
      ),
    );
  }
}
