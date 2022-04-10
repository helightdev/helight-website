
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:helightv3/widgets/frosted_glass.dart';
import 'package:helightv3/widgets/hove_elevation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class ProjectCard extends StatelessWidget {
  ProjectCard({required this.icon, required this.gradient, required this.title, required this.body, required this.tags, required this.url, Key? key}) : super(key: key);

  String icon;
  String title;
  String body;
  List<String> tags;
  LinearGradient gradient;
  String url;

  @override
  Widget build(BuildContext context) {
    var c = gradient.colors.map((e) => e.withOpacity(0.8)).toList();
    var g = LinearGradient(colors: c, stops: gradient.stops);
    var theme = Theme.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 480 + 40, height: 280,),
      child: GestureDetector(
        onTap: () {
          runAnalyticsOperation((analytics) {
            analytics.logViewItem(
              items: [AnalyticsEventItem(
                  itemCategory: "project",
                  itemName: title,
                  itemListId: "projects"
              )]
            );
          });
          launch(url);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: HoverElevation(
            builder: (context, elevation) => Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: elevation * 16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(height: 240),
                    child: Container(
                      height: 240, width: 480,
                      decoration: BoxDecoration(
                          boxShadow: elevation == 0 ? [] : [BoxShadow(blurRadius: elevation * 20,
                              color: Colors.white.withOpacity(elevation * .025))],
                          gradient: g,
                          borderRadius: BorderRadius.circular(16)
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(title, style: theme.textTheme.headline4!.copyWith(color: Colors.white),),
                                  ],
                                ),
                                SizedBox(height: 24,),
                                Text(body, style: theme.textTheme.bodyText1!.copyWith(color: Colors.white.withOpacity(.88))),
                                Expanded(child: Container()),
                                Text("TAGS", style: theme.textTheme.overline!.copyWith(color: Colors.white.withOpacity(.88))),
                                Row(children: tags.map((e) => Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: FrostedGlass(child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(e),
                                  )),
                                )).toList())
                              ],
                            ),
                            Positioned(left: 0, top: 0, child: Image.asset("assets/"+icon, fit: BoxFit.fitHeight,), width: 48, height: 48)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}