import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:helightv3/blocs/desktop_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsentPopup extends StatelessWidget {
  const ConsentPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tref = this;
    return Positioned(bottom: 128, left: 64, right: 64,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFEFEFE),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Diese Webseite verwendet Cookies", style: TextStyle(color: Colors.black, fontSize: 18),),
              SizedBox(height: 16,),
              Text("""Ihre Zufriedenheit ist unser Ziel, deshalb verwenden wir Cookies. Mit diesen ermöglichen wir, dass unsere Webseite zuverlässig und sicher läuft, wir die Performance im Blick behalten und Sie besser ansprechen können.

Cookies werden benötigt, damit technisch alles funktioniert und Sie auch externe Inhalte lesen können. Des weiteren sammeln wir unter anderem Daten über aufgerufene Seiten, getätigte Käufe oder geklickte Buttons, um so unser Angebot an Sie zu Verbessern. Mehr über unsere verwendeten Dienste erfahren Sie unter den „Cookie-Einstellungen“.

Mit Klick auf „Zustimmen und weiter“ erklären Sie sich mit der Verwendung dieser Dienste einverstanden. Ihre Einwilligung können Sie jederzeit mit Wirkung auf die Zukunft widerrufen oder ändern.""", style: TextStyle(color: Colors.black87)),
              SizedBox(height: 32,),
              SizedBox(
                height: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 512,
                      child: ElevatedButton(onPressed: () async {
                        var preferences = await SharedPreferences.getInstance();
                        preferences.setBool("isAnalyticsConsentChecked", true);
                        preferences.setBool("isAnalyticsEnabled", true);
                        FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
                        desktop.removePopup(tref);
                      }, child: Text("Zustimmen und weiter"), style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue)
                      ),),
                    ),
                    SizedBox(width: 16,),
                    SizedBox(
                      width: 512,
                      child: OutlinedButton(onPressed: () async {
                        var preferences = await SharedPreferences.getInstance();
                        preferences.setBool("isAnalyticsConsentChecked", true);
                        preferences.setBool("isAnalyticsEnabled", false);
                        desktop.removePopup(tref);
                      }, child: Text("Ablehnen", style: TextStyle(color: Colors.black.withOpacity(.6)),)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
