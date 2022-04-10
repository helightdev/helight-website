import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';

import '../blocs/window_cubit.dart';
import '../command_manager.dart';
import '../main.dart';
import '../widgets/window.dart';

class BannerCommand extends Command {

  BannerCommand(): super(["banner"], "Prints the 'HelightShell' banner to standard output");

  @override
  Stream<CommandOutput> handle(String command, List<String> params, String raw) async* {
    yield CommandOutput("log", shellBanner);
  }

}

class ExitCommand extends Command {

  CommandSystem manager;
  ExitCommand(this.manager) : super(["exit", "quit"], "Exits the current console instance");

  @override
  Stream<CommandOutput> handle(String command, List<String> params, String raw) async* {
    manager.commandViewState.player.stop();
    manager.commandViewState.stdout.clear();

    var window = manager.commandViewState.context.findAncestorWidgetOfExactType<Window>()!;
    windows.closeWindow(window);
  }
}

class ClipboardCommand extends Command {

  CommandSystem manager;
  ClipboardCommand(this.manager) : super(["clipboard", "cb"], "Outputs a file to clipboard");

  @override
  Stream<CommandOutput> handle(String command, List<String> params, String raw) async* {
    var path = params.join(" ");
    var lf = manager.fileSystem.localFile(manager.cursor, path);
    if (lf == null) {
      yield CommandOutput("error", "File '$path' doesn't exist");
    } else {
      var future = manager.fileSystem.read(lf);
      var c = Completer();
      future.then((value) => c.complete());
      yield CommandOutput("deferred-fs", c);
      var qr = await future;
      if (qr.isSuccessful) {
        Clipboard.setData(ClipboardData(text: utf8.decode(qr.success!)));
        yield CommandOutput("void", "");
      } else {
        yield CommandOutput("error", qr.error!);
      }
    }
  }

}

class CatCommand extends Command {

  CommandSystem manager;
  CatCommand(this.manager) : super(["cat"], "Outputs a file to standard output");

  @override
  Stream<CommandOutput> handle(String command, List<String> params, String raw) async* {
    var path = params.join(" ");
    var lf = manager.fileSystem.localFile(manager.cursor, path);
    if (lf == null) {
      yield CommandOutput("error", "File '$path' doesn't exist");
    } else {
      var future = manager.fileSystem.read(lf);
      var c = Completer();
      future.then((value) => c.complete());
      yield CommandOutput("deferred-fs", c);
      var qr = await future;
      if (qr.isSuccessful) {
        var fileName = lf.split("/").last;
        var fileType = fileName.split(".").last;
        runAnalyticsOperation((analytics) {
          analytics.logViewItem(
              items: [AnalyticsEventItem(
                  itemCategory: "file",
                  itemId: fileName,
                  itemListId: "explorer"
              )]
          );
        });
        yield CommandOutput(fileType, qr.success!);
      } else {
        yield CommandOutput("error", qr.error!);
      }
    }
  }

}

class CdCommand extends Command {

  CommandSystem manager;
  CdCommand(this.manager) : super(["cd"], "Changes the current directory");

  @override
  Stream<CommandOutput> handle(String command, List<String> params, String raw) async* {
    var query = params.join(" ");
    if (!query.endsWith("/")) query += "/";
    yield manager.fileSystem.cd(manager.cursor, query, (nc) => manager.cursor = nc);
  }

}

class LsCommand extends Command {

  CommandSystem manager;

  LsCommand(this.manager) : super(["ls", "dir"], "Gives insight about the current folder structure");

  @override
  Stream<CommandOutput> handle(String command, List<String> params, String raw) async* {
    var cursor = manager.cursor;
    yield CommandOutput("log", manager.fileSystem.list(manager.cursor).map((e) => e.path.replaceFirst(cursor, "")).where((element) =>
    element.split("/").length == 1 || (element.split("/").length == 2 && element.endsWith("/"))
    ).join("\n"));
  }

}

class EchoCommand extends Command {

  EchoCommand() : super(["echo"], "Echos a string to standard output");

  @override
  Stream<CommandOutput> handle(String command, List<String> params, String raw) async* {
    yield CommandOutput("log", params.join(" "));
  }

}

class MediumBlogCommand extends Command {

  MediumBlogCommand() : super(["blog", "medium"], "Displays the link to my blog");

  @override
  Stream<CommandOutput> handle(String command, List<String> params, String raw) async* {
    yield CommandOutput("link", "https://helight.medium.com");
  }

}

class CleanCommand extends Command {

  CommandSystem manager;

  CleanCommand(this.manager) : super(["clear", "clean", "cl"], "Clears the console output");

  @override
  Stream<CommandOutput> handle(String command, List<String> params, String raw) async* {
    manager.commandViewState.stdout.clear();
    manager.commandViewState.player.stop();
    yield CommandOutput("void", "");
  }
}

class HelpCommand extends Command {

  CommandSystem manager;

  HelpCommand(this.manager) : super(["help","?"], 'Lists usage details for all available commands');

  @override
  Stream<CommandOutput> handle(String command, List<String> params, String ra) async* {
    yield CommandOutput("log", "Command Help:\n" + manager.commands.map((e) => "    ${e.aliases.join(", ")} -  ${e.usage}").toList().join("\n"));
  }
}