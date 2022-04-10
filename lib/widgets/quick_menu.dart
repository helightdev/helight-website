import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helightv3/blocs/desktop_cubit.dart';
import 'package:helightv3/views/impressum.dart';
import 'package:helightv3/widgets/app_icon.dart';

import '../blocs/window_cubit.dart';
import '../views/dsgvo.dart';

class QuickMenu extends StatelessWidget {
  const QuickMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 64, left: 0,
      child: GlassContainer.frostedGlass(height: 600, width: 300, borderColor: Colors.transparent, color: Colors.black54, child: Column(
        children: [
          SizedBox(height: 32,),
          ListView(children: [
            Center(child: Text("Quick Menu", style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold),)),
            SizedBox(height: 32,),
            ListTile(
              title: Text("Impressum", style: TextStyle(fontSize: 14)),
              onTap: () {
                desktop.removePopupsOfType<QuickMenu>();
                windows.createdSized(SingleChildScrollView(
                  child: ImpressumView(),
                ), "Impressum", 900, 900, AppIcon.buildIcon(Icons.privacy_tip, null, Colors.transparent));
              },
            ),
            ListTile(
              title: Text("Datenschutz", style: TextStyle(fontSize: 14)),
              onTap: () {
                desktop.removePopupsOfType<QuickMenu>();
                windows.createdSized(SingleChildScrollView(
                  child: DsgvoView(),
                ), "Datenschutz", 900, 900, AppIcon.buildIcon(Icons.privacy_tip, null, Colors.transparent));
              },
            ),
            ListTile(
              title: Text("Lizenzen", style: TextStyle(fontSize: 14),),
              onTap: () {
                desktop.removePopupsOfType<QuickMenu>();
                showLicensePage(context: context);
              },
            )
          ], shrinkWrap: true,)
        ],
      ), borderRadius: BorderRadius.only( topRight: Radius.circular(32)),),
    );
  }
}
