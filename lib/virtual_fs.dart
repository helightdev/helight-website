import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:helightv3/command_manager.dart';

var virtualFS = VirtualFS();

class VirtualFS {
  List<FSNode> nodes = List.empty(growable: true);

  final deferredStorage =
      FirebaseStorage.instanceFor(bucket: "gs://helightdev-fe5b4.appspot.com");

  VirtualFS() {
    nodes.add(FSNode.directory("/"));
    nodes.add(FSNode.directory("/homework/"));
    nodes.add(FSNode.directory("/js/"));
    nodes.add(FSNode.directory("/images/"));
    nodes.add(FSNode.file("/hello.txt", "Hello World!"));
    nodes.add(
        FSNode.deferred("/technologies.yml", "deferred-fs/technologies.yml"));
    nodes.add(FSNode.deferred("/gaming.json", "deferred-fs/gaming.json"));
    nodes.add(FSNode.deferred("/movies.xml", "deferred-fs/movies.xml"));
    // From Hex => From Morse Code => From Base32 => Json Payload. Just putting this here before I forget it myself, I guess this shouldn't be too hard :)
    nodes.add(FSNode.file("/challenge.hex",
        """2e 2d 2d 2e 20 2d 2d 20 2e 2e 2d 2e 20 2d 2e 2d 2e 20 2e 2d 20 2e 2e 20 2d 2e 2e 2e 20 2d 2e 2d 2e 20 2d 2e 20 2e 2e 2e 2d 20 2e 2e 2e 20 2d 2e 2e 2d 20 2d 2d 2e 20 2e 2e 2e 2e 2d 20 2e 2e 2e 2d 2d 20 2d 2e 2e 2e 20 2d 2d 20 2e 2e 2e 2e 2e 20 2e 2e 2e 20 2e 2e 2e 20 2e 20 2d 2d 2d 20 2e 2d 2e 20 2e 2d 20 2e 20 2e 2d 2d 2d 20 2e 2d 2e 2e 20 2e 2d 2d 20 2d 2e 2e 2e 2e 20 2e 2e 2e 2e 2e 20 2d 2d 2e 2e 20 2e 2d 20 2e 2d 2d 2e 20 2e 2e 2d 2e 20 2d 2e 2e 2d 20 2d 2e 2e 2d 20 2d 2e 2d 20 2e 2e 20 2d 2e 2e 20 2e 2e 2e 20 2d 2d 20 2e 2e 2e 2d 20 2d 2d 2e 2d 20 2e 2d 2d 20 2d 2e 2d 2d 20 2e 2e 2e 2d 2d 20 2d 2e 2e 20 2d 2d 2e 2e 20 2e 20 2d 2e 2e 2e 20 2e 2e 2e 20 2d 2d 2e 20 2d 2e 2d 20 2d 2e 2d 2d 20 2e 2e 2e 2d 2d 20 2e 2d 2d 2e 20 2d 2d 20 2e 2d 2e 20 2e 2e 2e 20 2e 2d 2d 20 2e 2e 20 2e 2e 20 2d 2e 2e 20 2e 2e 2d 20 2d 2e 20 2d 2e 2e 2e 20 2e 2e 2d 20 2d 2e 2e 2d 20 2d 2d 2e 20 2e 2d 2e 2e 20 2d 2e 2e 2e 20 2e 2d 20 2e 2d 2d 2d 20 2e 20 2d 20 2e 2d 2d 20 2e 2e 2d 2d 2d 20 2e 2e 20 2d 2e 2e 20 2e 2d 2d 2d 20 2d 2e 20 2e 2e 2e 2d 20 2d 2e 2d 2d 20 2e 2e 2e 2e 20 2e 20 2d 2d 2e 2e 20 2e 2d 2e 2e 20 2d 20 2d 2d 2d 20 2d 2e 20 2e 2e 2e 20 2e 2d 2d 20 2e 2e 20 2e 2d 2e 2e 20 2e 2d 2e 20 2e 2d 20 2e 2d 2d 2d 20 2d 2e 2e 2e 20 2e 2e 2e 20 2d 2e 2e 2d 20 2e 20 2d 2d 2e 2e 20 2e 2d 2d 2d 20 2e 2d 20 2d 2d 2d 20 2e 2d 2e 20 2d 2d 2e 2d 20 2e 2d 2d 20 2e 2d 2d 20 2d 2d 2e 2e 20 2e 2d 2d 2d 20 2e 2d 20 2d 2d 20 2e 20 2d 2d 2e 2d 20 2d 2d 2e 20 2d 2d 2e 20 2e 2e 2e 2d 2d 20 2e 2e 2e 2d 2d 20 2e 2d 2d 2e 20 2d 2e 20 2d 2e 20 2e 2e 2d 20 2e 2d 2d 20 2d 2e 2d 20 2e 2e 20 2e 2d 2d 2d 20 2d 2e 2d 2e 20 2e 2e 2d 2e 20 2d 2d 2e 2d 20 2e 2e 2d 2e 20 2d 2e 2d 2e 20 2e 2d 20 2e 2e 20 2d 2e 2e 2e 20 2d 2e 2d 2e 20 2d 2d 20 2d 2e 20 2d 2e 2e 2d 20 2e 2d 2d 20 2d 2e 2e 2e 2e 20 2e 2e 2d 2d 2d 20 2e 2e 2e 2d 2d 20 2e 2d 2d 2d 20 2d 2d 20 2e 2e 2d 20 2e 2d 2e 20 2d 2e 2e 20 2e 2e 2d 20 2e 2e 20 2d 2e 2e 2e 20 2d 2e 2d 2e 20 2d 2e 2e 2e 2e 20 2d 2e 2d 2e 20 2e 2d 2d 2e 20 2d 2e 2d 2d 20 2e 2e 2e 2d 2d 20 2d 2e 2d 20 2e 2d 2e 20 2d 2e 2d 2e 20 2e 2e 2d 2e 20 2d 2d 2e 2d 20 2e 2e 2d 2e 20 2d 2e 2d 2e 20 2e 2d 20 2e 2e 20 2d 2e 2e 2e 20 2d 2e 2d 2e 20 2d 2d 2d 20 2d 2e 2e 2e 20 2d 2d 2e 2e 20 2e 2e 2e 20 2e 20 2d 2d 2d 20 2e 2d 2e 20 2e 2d 20 2e 20 2e 2d 2d 2d 20 2d 2d 2e 2d 20 2e 2d 2d 20 2d 2e 2d 2d 20 2e 2e 2e 2e 2d 20 2e 2e 2e 2d 2d 20 2e 2d 2d 2e 20 2e 20 2d 2e 2e 2e 20 2d 2e 2d 2d 20 2d 2d 2e 20 2d 2e 2d 2d 20 2d 2d 2e 2e 20 2e 2d 2e 2e 20 2d 2e 2e 2e 20 2d 2d 2d 20 2d 2e 20 2e 2e 2e 20 2e 2e 2e 20 2e 2d 20 2e 2e 2e 2e 2d 20 2e 2e 2e 2d 2d 20 2e 2e 2d 2e 20 2d 2e 20 2d 2d 2e 2e 20 2e 2e 2e 20 2d 2e 2d 2e 20 2e 2d 20 2e 2e 2e 2d 2d 20 2e 2d 2e 2e 20 2e 2e 2d 2e 20 2e 20 2d 2e 2e 2e 20 2d 2d 2e 2d 20 2e 2e 2e 20 2e 2d 20 2e 2e 2e 2d 2d 20 2e 2d 2e 2e 20 2e 2e 2d 2e 20 2d 2d 2d 20 2d 2e 20 2d 2d 2e 2e 20 2e 2d 2d 20 2d 2e 2d 2e 20 2d 2d 2e 2e 20 2e 2e 2e 2d 2d 20 2e 2e 2d 2e 20 2e 2e 2d 2e 20 2d 2d 2e 2d 20 2d 2d 2e 2d 20 2e 20 2e 2e 2e 20 2e 2e 20 2d 2e 2e 20 2e 2e 2e 20 2d 2d 20 2e 2e 2e 2d 20 2d 2d 2e 2d 20 2e 2d 2d 20 2d 2e 2d 2d 20 2e 2e 2e 2d 2d 20 2d 2e 2e 20 2d 2d 2e 2e 20 2e 20 2d 2e 2e 2e 20 2e 2e 2e 2d 2d 20 2e 2d 2d 20 2d 2e 2d 2e 20 2e 2e 2e 2d 2d 20 2d 20 2e 2e 2d 20 2e 20 2d 2e 2e 2e 20 2e 2e 2d 2d 2d 20 2d 2d 2e 20 2d 2e 2e 2e 2e 20 2e 2e 20 2d 2e 2e 20 2e 2d 2e 2e 20 2d 2e 20 2d 2d 2e 2e 20 2d 2e 2e 2d 20 2d 2e 2e 2d 20 2d 2d 2d 20 2e 2e 20 2d 2e 2e 20 2e 2d 2d 2d 20 2d 2d 20 2d 2e 2d 2d 20 2d 2d 2e 2d 20 2d 2d 2e 20 2d 2e 2d 2e 20 2e 2e 2e 2d 2d 20 2d 20 2d 2d 2e 2e 20 2d 2e 20 2e 2e 2e 2e 2e 20 2d 2e 2e 2d 20 2d 2d 2e 20 2d 2e 2d 20 2e 2e 20 2d 2e 2e 20 2d 2d 2e 20 2d 2e 20 2e 2e 2e 2e 2e 20 2e 2e 2d 2d 2d 20 2e 2d 2d 20 2e 2e 2e 2e 2d 20 2d 2d 2e 2e 20 2d 2e 2e 2e 20 2e 2d 20 2d 2d 2d 20 2e 2d 2e 20 2e 2e 2d 20 2d 2d 2e 20 2e 2e 2e 20 2e 2e 2e 2e 2d 20 2d 2d 2e 2e 20 2d 2e 2d 2e 20 2d 2e 2e 2e 20 2e 2d 2d 2d 20 2d 2e 2e 2e 2e 20 2d 2d 2e 2d 20 2d 2e 2e 2e 2d 20 2d 2e 2e 2e 2d 20 2d 2e 2e 2e 2d 20 2d 2e 2e 2e 2d"""));
    nodes.add(
        FSNode.file("/js/opinion.js", "console.log(\"I don't like js\");"));
    nodes.add(FSNode.deferred(
        "/homework/definitely.homework", "deferred-fs/definitely.homework"));
    nodes.add(FSNode.deferred("/images/logo.png", "deferred-fs/logo.png"));
  }

  Future<int> getDeferredSize(FSNode node) async {
    var meta = await deferredStorage.ref().child(node.content).getMetadata();
    return meta.size!;
  }

  Future<String> getDownloadLink(FSNode node) async {
    var url = await deferredStorage.ref().child(node.content).getDownloadURL();
    return url;
  }

  String? localFile(String cursor, String path) {
    if (path.contains("../")) {
      var tempPath = cursor;
      for (var value in path.split("/")) {
        if (value == "..") {
          tempPath = tempPath
                  .split("/")
                  .sublist(0, tempPath.split("/").length - 2)
                  .join("/") +
              "/";
        } else {
          break;
        }
      }
      if (tempPath == "") tempPath = "/";
      var file = tempPath + path.replaceAll("../", "");
      if (!existsFile(file)) {
        return null;
      }
      return file;
    }

    var local = cursor + path;

    if (existsFile(local)) {
      return local;
    } else if (existsPath(path)) {
      return path;
    }

    return null;
  }

  CommandOutput cd(String cursor, String path, Function(String) updateCursor) {
    if (path.contains("../")) {
      var tempPath = cursor;
      for (var value in path.split("/")) {
        if (value == "..") {
          tempPath = tempPath
                  .split("/")
                  .sublist(0, tempPath.split("/").length - 2)
                  .join("/") +
              "/";
        } else {
          break;
        }
      }
      if (tempPath == "") tempPath = "/";
      var newCursor = tempPath + path.replaceAll("../", "");
      if (!existsPath(newCursor)) {
        return CommandOutput(
            "error", "The directory '$newCursor' doesn't exist");
      }
      cursor = newCursor;
      return CommandOutput("void", "");
    }

    var local = cursor + path;

    if (existsPath(local)) {
      updateCursor(local);
      return CommandOutput("void", "");
    }

    if (existsPath(path)) {
      updateCursor(path);
      return CommandOutput("void", "");
    } else {
      return CommandOutput("error", "The directory '$path' doesn't exist");
    }
  }

  List<FSNode> list(String path) => nodes
      .where((element) => element.path.startsWith(path) && element.path != path)
      .toList();

  List<FSNode> listNoDepth(String path) => list(path).where((element) {
        var pathAfter = element.path.replaceFirst(path, "");
        var slashes = pathAfter.length - pathAfter.replaceFirst("/", "").length;
        if (element.isDirectory) {
          if (slashes > 1) return false;
          return true;
        } else {
          if (slashes > 0) return false;
          return true;
        }
      }).toList();

  bool existsPath(String path) =>
      nodes.any((element) => element.path == path && element.isDirectory);

  bool existsFile(String path) =>
      nodes.any((element) => element.path == path && !element.isDirectory);

  Future<FSQueryResult> read(String path) async {
    try {
      var node = nodes.firstWhere((element) => element.path == path);
      if (node.isDirectory) {
        return FSQueryResult.error("Can't read a directory");
      }
      if (node.isDeferred) {
        var data = await deferredStorage.ref().child(node.content).getData();
        return FSQueryResult.successful(data);
      } else {
        return FSQueryResult.successful(
            Uint8List.fromList(utf8.encode(node.content)));
      }
    } catch (e) {
      print(e);
      return FSQueryResult.error("File not found");
    }
  }
}

class FSQueryResult {
  Uint8List? success;
  String? error;

  bool get isSuccessful => success != null;

  FSQueryResult.successful(this.success);

  FSQueryResult.error(this.error);
}

class FSNode {
  bool isDirectory = false;
  bool isDeferred = false;
  String path;
  late String content;

  String get name {
    var spliced = path.split("/");
    if (spliced.last.length == 0) {
      return spliced[spliced.length - 2];
    } else
      return spliced.last;
  }

  String get fileType => name.split(".").last;

  FSNode(this.isDirectory, this.path, this.content);

  FSNode.file(this.path, this.content);

  FSNode.directory(this.path) {
    this.content = "";
    this.isDirectory = true;
  }

  FSNode.deferred(this.path, this.content) {
    this.isDirectory = false;
    this.isDeferred = true;
  }
}
