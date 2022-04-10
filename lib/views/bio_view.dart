import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class BioView extends StatelessWidget {
  BioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                child: ClipRRect(
                  child: Image.asset("assets/logoTransparent.png",
                      width: 196, height: 196, fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(8),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  //boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 7, spreadRadius: 2, offset: Offset(1,3))]
                ),
              ),
              Expanded(
                  child: SizedBox(
                height: 196,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Christoph Feuerer",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                    Text(
                      FirebaseRemoteConfig.instance.getString("bio_subtitle"),
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(height: 16),
                    Text(
                      FirebaseRemoteConfig.instance.getString("bio_contact"),
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                      textAlign: TextAlign.end,
                    )
                  ],
                ),
              ))
            ],
          ),
          SizedBox(
            height: 32,
          ),
          Text(
            FirebaseRemoteConfig.instance.getString("bio_description"),
            style: TextStyle(fontSize: 15, color: Colors.white70),
          ),
          Spacer(
            flex: 2,
          ),
          SizedBox(
            height: 150,
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                card(
                    title: "Entwickler",
                    subtitle: "Java · Kotlin · C# · Dart",
                    asset: "business"),
                card(
                    title: "Liberaler",
                    subtitle: "Leidenschaft & Überzeugung",
                    asset: "political"),
                card(
                    title: "Gamer",
                    subtitle: "Beatsaber · osu! · Minecraft",
                    asset: "game",
                    indent: 1.2),
                card(
                    title: "ENTJ-A",
                    subtitle: "mehr oder weniger treffend",
                    asset: "brain")
              ],
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3.66 / 1,
              clipBehavior: Clip.none,
            ),
          )
        ],
      ),
    );
  }

  Widget card(
      {required String title,
      required String subtitle,
      required String asset,
      double indent = 1}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 7,
                spreadRadius: 2,
                offset: Offset(1, 3))
          ]),
      child: Stack(
        children: [
          Positioned(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF212529),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Color(0xFF212529)),
                  )
                ],
              ),
              top: 4,
              right: 12,
              bottom: 4),
          Positioned(
            child: Image.asset(
              "assets/steckbrief/$asset.png",
              fit: BoxFit.fitHeight,
            ),
            top: 17 * indent,
            left: 14,
            bottom: 17 * indent,
          )
        ],
      ),
    );
  }
}
