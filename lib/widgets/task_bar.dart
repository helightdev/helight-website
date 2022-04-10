import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helightv3/blocs/desktop_cubit.dart';
import 'package:helightv3/views/dsgvo.dart';
import 'package:helightv3/widgets/quick_menu.dart';
import 'package:helightv3/widgets/time_widget.dart';

import '../blocs/task_cubit.dart';
import '../blocs/window_cubit.dart';
import 'tasklist_item.dart';

class TaskBar extends StatefulWidget {
  TaskBar({required this.controller, Key? key}) : super(key: key);

  PageController controller;

  late TaskBarState currentState;

  @override
  TaskBarState createState() {
    currentState = TaskBarState();
    return currentState;
  }
}

class TaskBarState extends State<TaskBar> {
  @override
  void initState() {
    widget.controller.addListener(onPageSwitch);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(onPageSwitch);
    super.dispose();
  }

  void onPageSwitch() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer.frostedGlass(
        height: 64,
        width: double.infinity,
        blur: 30,
        color: Colors.black.withOpacity(.444) /* :) */,
        borderColor: Colors.transparent,
        child: Row(children: [
          SizedBox(
            width: 32,
          ),
          GestureDetector(
              child: Icon(Icons.apps, color: Colors.white, size: 32,),
            onTap: () {
                if (desktop.isPopup<QuickMenu>()) {
                  desktop.removePopupsOfType<QuickMenu>();
                } else {
                  desktop.addPopup(QuickMenu());
                }
            },
          ),
          SizedBox(
            width: 32,
          ),
          Expanded(
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                return ListView(
                  children: state.tasks.map((e) => TasklistItem(
                    id: e.id, image: e.image, tooltip: e.tooltip,
                    onSelect: () {
                      var window = windows.resolve(e.id);
                      windows.pushToTop(window);
                      windows.show(window);
                    },
                    onUnselect: () {
                      var window = windows.resolve(e.id);
                      windows.hide(window);
                    },
                  )).toList(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                );
              }, bloc: tasks,
            ),
          ),
          TimeWidget()
        ]));
  }
}