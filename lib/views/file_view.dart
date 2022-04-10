import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helightv3/file_data_resolver.dart';
import 'package:helightv3/main.dart';
import 'package:helightv3/views/console_view.dart';
import 'package:helightv3/virtual_fs.dart';
import 'package:helightv3/widgets/console_loading_animation.dart';
import 'package:helightv3/widgets/window.dart';

class FileView extends StatelessWidget {
  FSNode node;

  Uint8List? cachedContent;

  FileView({Key? key, required this.node}) : super(key: key);

  bool isInitialised = false;

  void init(BuildContext context) {
    var win = context.findAncestorWidgetOfExactType<Window>()!;
    win.shutdownHooks.add(() {
      sneakyAudioPlayer.stop();
    });
    isInitialised = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialised) init(context);
    return _buildContent();
  }

  Widget _buildContent() {
    if (cachedContent == null) {
      return FutureBuilder<FSQueryResult>(
          future: virtualFS.read(node.path),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("loading_file".localized),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      child: ConsoleLoadingAnimation(),
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              );
            cachedContent = snapshot.data!.success!;
            return _viewFileContent(snapshot.data!.success!, node);
          });
    } else {
      return _viewFileContent(cachedContent!, node);
    }
  }

  Widget _viewFileContent(Uint8List content, FSNode node) {
    return resolveFileContent(node.path, null, node.fileType, content, () {
      sneakyAudioPlayer.setAsset("assets/secretAudio.mp3");
      sneakyAudioPlayer.load();
      sneakyAudioPlayer.play();
    }, (data, width, height) {
      return Image.memory(
        data,
        fit: BoxFit.cover,
      );
    }, EdgeInsets.all(16), EdgeInsets.zero);
  }
}
