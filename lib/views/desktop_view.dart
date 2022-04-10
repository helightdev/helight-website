import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helightv3/blocs/desktop_cubit.dart';
import 'package:helightv3/blocs/window_cubit.dart';
import 'package:helightv3/main.dart';
import 'package:helightv3/views/bio_view.dart';
import 'package:helightv3/views/console_view.dart';
import 'package:helightv3/views/explorer_view.dart';
import 'package:helightv3/views/projects_view.dart';
import 'package:helightv3/widgets/app_icon.dart';
import 'package:helightv3/widgets/quick_menu.dart';
import 'package:helightv3/widgets/window.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/task_bar.dart';

class DesktopView extends StatefulWidget {
  
  DesktopView({Key? key}) : super(key: key);

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  var controller = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      windows.openDefaults(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesktopCubit, DesktopState>(
  builder: (context, state) {
    return Stack(
      children: [
        Positioned.fill(
            child: Container(
          color: "#fafafa".toColor(),
        )),
        Positioned.fill(
            child: GestureDetector(
              onTap: () => desktop.clickOutside(),
              child: Image.asset(
          "assets/background.jpg",
          fit: BoxFit.cover,
        ),
            )),
        Positioned.fill(
            child: GestureDetector(
              onTap: () => desktop.clickOutside(),
              child: GridView(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 96,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16),
                children: [
                  AppIcon.bigApplicationWidget(
                      title: "explorer_title".localized,
                      icon: AppIcon.buildIcon(Icons.folder, Colors.orangeAccent),
                      windowIcon: AppIcon.buildIcon(
                          Icons.folder, Colors.orangeAccent, Colors.transparent),
                      widget: () => ExplorerView()),
                  AppIcon.bigApplicationWidget(
                      title: "terminal_title".localized,
                      icon: AppIcon.buildIcon(Icons.keyboard, Colors.blueAccent),
                      windowIcon: AppIcon.buildIcon(
                          Icons.keyboard, Colors.blueAccent, Colors.transparent),
                      widget: () => CommandView()),
                  AppIcon.bigApplicationWidget(
                      title: "projects_title".localized,
                      icon: AppIcon.buildIcon(
                          Icons.view_agenda, Colors.greenAccent),
                      windowIcon: AppIcon.buildIcon(Icons.view_agenda,
                          Colors.greenAccent, Colors.transparent),
                      widget: () => ProjectsView()),
                  AppIcon.sizedApplicationWidget(
                      title: "bio_title".localized,
                      icon: AppIcon.buildIcon(Icons.summarize, Colors.redAccent),
                      width: 550,
                      height: 750,
                      windowIcon: AppIcon.buildIcon(
                          Icons.summarize, Colors.redAccent, Colors.transparent),
                      widget: () => BioView()),
                  AppIcon(
                      title: "Junge Liberale",
                      image: Image.asset("assets/icons/julis.png"),
                      action: () => launch("https://www.julis.de/startseite/"))
                ],
              ),
            ),
            bottom: 64 + 16,
            left: 16,
            top: 16,
            right: 16),
        Positioned.fill(
            child: GestureDetector(
              onTap: () => desktop.clickOutside(),
              child: DragTarget(
          builder: (ctx, candidates, rejected) {
              return BlocBuilder<WindowCubit, WindowState>(
                builder: (context, state) {
                  return Stack(
                    children: state.visible,
                  );
                },
                bloc: windows,
              );
          },
          onWillAccept: (obj) {
              if (obj is IgnorableDropData) return false;
              return true;
          },
          onAccept: (obj) {},
        ),
            )),
        Positioned(
          child: TaskBar(
            controller: controller,
          ),
          bottom: 0, left: 0, right: 0, height: 64,
        )
      ]..addAll(state.popups),
    );
  }, bloc: desktop,
);
  }
}
