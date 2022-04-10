import 'dart:async';

import 'package:helightv3/views/console_view.dart';
import 'package:helightv3/virtual_fs.dart';

import 'commands/commands.dart';
import 'main.dart';

const shellBanner = """
    
#----------------------------------------------------------------------------------------------------------------------------------------#
:                                                                                                                                        :
: :::    ::: :::::::::: :::        :::::::::::  ::::::::  :::    ::: :::::::::::  ::::::::  :::    ::: :::::::::: :::        :::         :
: :+:    :+: :+:        :+:            :+:     :+:    :+: :+:    :+:     :+:     :+:    :+: :+:    :+: :+:        :+:        :+:         :
: +:+    +:+ +:+        +:+            +:+     +:+        +:+    +:+     +:+     +:+        +:+    +:+ +:+        +:+        +:+         :
: +#++:++#++ +#++:++#   +#+            +#+     :#:        +#++:++#++     +#+     +#++:++#++ +#++:++#++ +#++:++#   +#+        +#+         :
: +#+    +#+ +#+        +#+            +#+     +#+   +#+# +#+    +#+     +#+            +#+ +#+    +#+ +#+        +#+        +#+         :
: #+#    #+# #+#        #+#            #+#     #+#    #+# #+#    #+#     #+#     #+#    #+# #+#    #+# #+#        #+#        #+#         :  
: ###    ### ########## ########## ###########  ########  ###    ###     ###      ########  ###    ### ########## ########## ##########  :
:                                                                                                                                        :
#----------------------------------------------------------------------------------------------------------------------------------------#

    > help - List available commands
    > clean - Clears the console output
    > exit - Exit the current console instance
""";

class CommandSystem {
  CommandViewState commandViewState;
  VirtualFS fileSystem;
  String cursor = "/";

  var commands = List<Command>.empty(growable: true);

  CommandSystem(this.commandViewState, this.fileSystem) {
    commands.add(HelpCommand(this));
    commands.add(BannerCommand());

    commands.add(CleanCommand(this));
    commands.add(EchoCommand());
    commands.add(ExitCommand(this));

    commands.add(LsCommand(this));
    commands.add(CdCommand(this));
    commands.add(CatCommand(this));
    commands.add(ClipboardCommand(this));

    commands.add(MediumBlogCommand());
  }

  Stream<CommandOutput> handle(String input) async* {
    var splinted = input.split(" ");
    var cmd = splinted[0];
    var params = splinted.sublist(1);
    try {
      var command = commands.firstWhere((element) => element.aliases.contains(cmd));
      runAnalyticsOperation((analytics) {
        analytics.logEvent(
          name: "run_command",
          parameters: {
            "command": command.aliases[0]
          },
        );
      });

      yield* command.handle(cmd, params, input);
    } catch (ex) {
      yield CommandOutput("error", "Command '$cmd' is not found");
    }
  }
}

class CommandOutput {
  String format;
  dynamic value;
  String? cursor;

  CommandOutput(this.format, this.value);
}

abstract class Command {
  List<String> aliases;
  String usage;

  Command(this.aliases, this.usage);

  Stream<CommandOutput> handle(String command, List<String> params, String raw);
}
