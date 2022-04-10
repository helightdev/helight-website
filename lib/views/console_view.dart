import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helightv3/command_manager.dart';

import 'package:helightv3/file_data_resolver.dart';
import 'package:helightv3/virtual_fs.dart';
import 'package:just_audio/just_audio.dart';

final sneakyAudioPlayer = AudioPlayer();

class CommandView extends StatefulWidget {
  CommandView({Key? key}) : super(key: key);

  var stdout = List<CommandOutput>.empty(growable: true);
  var isNew = true;

  @override
  CommandViewState createState() => CommandViewState();
}

class CommandViewState extends State<CommandView> {
  AudioPlayer get player => sneakyAudioPlayer;

  List<CommandOutput> get stdout => widget.stdout;

  var outScrollController = ScrollController();
  var commandLineController = TextEditingController();
  var commandLineFocusNode = FocusNode();
  late CommandSystem commandManager;
  var lockTextField = true;

  var isNewState = false;

  @override
  void initState() {
    isNewState = widget.isNew;
    widget.isNew = false;

    commandManager = CommandSystem(this, virtualFS);
    if (isNewState) stdout.add(CommandOutput("log", shellBanner));
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      commandLineFocusNode.requestFocus();
    });
    delayAsync();
  }

  void delayAsync() async {
    if (isNewState) {
      player.setAsset("assets/secretAudio.mp3");
      player.load();
    }
    setState(() {
      lockTextField = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
              child: Scrollbar(
            child: ListView(
              children: stdout
                  .map((e) => resolveFileContent(
                          e.cursor ?? commandManager.cursor,
                          commandManager,
                          e.format,
                          e.value,
                          doSomethingSneaky, (data, width, height) {
                        return Row(
                          children: [
                            Image.memory(
                              data,
                              fit: BoxFit.cover,
                              height: height,
                              width: width,
                            ),
                          ],
                        );
                      }, EdgeInsets.only(left: 16, top: 16),
                          EdgeInsets.only(left: 16, top: 16)))
                  .toList(growable: true)
                ..add(SizedBox(
                  height: 32,
                )),
              controller: outScrollController,
            ),
            controller: outScrollController,
            isAlwaysShown: true,
          )),
          Container(
            child: TextField(
              controller: commandLineController,
              style: theme.textTheme.bodyText1!.copyWith(color: Colors.white),
              onSubmitted: (s) {
                //stdout.add(s);
                stdout.add(
                    CommandOutput("cursor", s)..cursor = commandManager.cursor);
                setState(() {
                  commandLineController.value = TextEditingValue.empty;
                  blockUntilFinish(commandManager.handle(s));
                });
              },
              focusNode: commandLineFocusNode,
              enabled: !lockTextField,
              decoration: InputDecoration(
                  prefix: Text(" > ",
                      style: theme.textTheme.bodyText1!
                          .copyWith(color: Colors.white))),
            ),
            color: Colors.transparent,
          )
        ],
      ),
    );
  }

  void doSomethingSneaky() async => player.play();

  void blockUntilFinish(Stream<CommandOutput> future) async {
    setState(() {
      lockTextField = true;
      commandLineController.value = TextEditingValue(text: "...");
    });
    var completer = Completer();
    future.listen((event) {
      stdout.add(event);
      setState(() {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          outScrollController.animateTo(
              outScrollController.position.maxScrollExtent,
              duration: Duration(microseconds: 100),
              curve: Curves.easeOut);
        });
      });
    }, onDone: () {
      completer.complete();
    });
    await completer.future;
    setState(() {
      lockTextField = false;
      commandLineController.value = TextEditingValue(text: "");
      commandLineFocusNode.requestFocus();
    });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      outScrollController.animateTo(
          outScrollController.position.maxScrollExtent,
          duration: Duration(microseconds: 100),
          curve: Curves.easeOut);
    });
  }
}
