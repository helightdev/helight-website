import 'dart:convert';
import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helightv3/blocs/window_cubit.dart';
import 'package:helightv3/views/file_view.dart';
import 'package:helightv3/virtual_fs.dart';
import 'package:helightv3/widgets/app_icon.dart';
import 'package:helightv3/widgets/console_loading_animation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class ExplorerView extends StatefulWidget {
  String current = "/";

  ExplorerView({Key? key}) : super(key: key);

  @override
  State<ExplorerView> createState() => _ExplorerViewState();
}

class _ExplorerViewState extends State<ExplorerView> {
  bool get isRoot => widget.current == "/";

  @override
  Widget build(BuildContext context) {
    var pathSplice = widget.current.split("/");
    var before = pathSplice.take(pathSplice.length - 2).join("/") + "/";

    return Container(
      child: DataTable(
          columns: [
            DataColumn(label: Text("filename".localized)),
            DataColumn(label: Text("filesize".localized)),
            DataColumn(label: Text("")),
          ],
          rows: [
            if (!isRoot) _buildDirectory(FSNode(true, before, ""), ".."),
          ]..addAll(
              virtualFS.listNoDepth(widget.current).map(_buildNode).toList())),
    );
  }

  DataRow _buildNode(FSNode node) {
    if (node.isDirectory) return _buildDirectory(node);
    return _buildFile(node);
  }

  DataRow _buildDirectory(FSNode node, [String? nameOverride]) {
    return DataRow(cells: [
      DataCell(Text((nameOverride ?? node.name) + "/"), onTap: () {
        setState(() {
          widget.current = node.path;
        });
      }),
      DataCell(Text("${virtualFS.list(node.path).length} Item(s)")),
      DataCell(Text(""))
    ]);
  }

  DataRow _buildFile(FSNode node) {
    return DataRow(cells: [
      DataCell(Text(node.name), onTap: () {
        runAnalyticsOperation((analytics) {
          analytics.logViewItem(
            items: [AnalyticsEventItem(
              itemCategory: "file",
              itemId: node.name,
              itemListId: "explorer"
            )]
          );
        });
        windows.createdSized(FileView(node: node), node.name, 900, 600,
            AppIcon.buildIcon(Icons.description, null, Colors.transparent));
      }),
      DataCell(_fileSize(node)),
      () {
        if (node.isDeferred) {
          return DataCell(Text("download".localized), onTap: () async {
            runAnalyticsOperation((analytics) {
              analytics.logEvent(
                name: "Download File",
                parameters: {
                  "itemCategory": "file",
                  "itemId": node.name,
                  "itemListId": "explorer"
                },
              );
            });
            launch(await virtualFS.getDownloadLink(node));
          });
        } else {
          runAnalyticsOperation((analytics) {
            analytics.logEvent(
              name: "download_file",
              parameters: {
                "itemCategory": "file",
                "itemId": node.name,
                "itemListId": "explorer"
              },
            );
          });
          return DataCell(Text("copy".localized), onTap: () {
            Clipboard.setData(ClipboardData(text: node.content));
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("copied_clipboard".localized)));
          });
        }
      }()
    ]);
  }

  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();

    if (suffixes[i] == "B") {
      return "$bytes B";
    } else {
      return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
          ' ' +
          suffixes[i];
    }
  }

  Widget _fileSize(FSNode node) {
    if (node.isDeferred) {
      return FutureBuilder<int>(
          future: virtualFS.getDeferredSize(node),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Row(
                children: [
                  SizedBox(
                    child: ConsoleLoadingAnimation(),
                    width: 10,
                    height: 10,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text("loading_metadata".localized),
                ],
              );
            return Text("${formatBytes(snapshot.data!, 2)}");
          });
    } else {
      return Text("${formatBytes(utf8.encode(node.content).length, 2)}");
    }
  }
}
