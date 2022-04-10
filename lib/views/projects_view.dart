import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helightv3/widgets/project_card.dart';

import '../main.dart';

class ProjectsView extends StatelessWidget {
  ProjectsView({Key? key}) : super(key: key);

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: "#fafafa".toColor(),
      child: SingleChildScrollView(
        controller: scrollController,
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Wrap(
            spacing: 0, runSpacing: 0, alignment: WrapAlignment.center,
            children: [
            ProjectCard(icon: "icons/minecraft.png", gradient: LinearGradient(colors: [
                "#00480F".toColor().withOpacity(0.75),
                "#00480F".toColor().withOpacity(0.75)
              ], stops: [0.55, 1], begin: Alignment.topLeft, end: Alignment.bottomRight), title: "Minecraft Hopper", body:
"""
Core Library for most of my spigot related projects. Functions as an alternate plugin, 
loader and ecs system primarily targeted for minigames, even though compatible with
long lived environments by providing default support for serialization.     
""".replaceAll("\n", ""), tags: ["Kotlin", "Modding", "Minecraft"], url: "https://github.com/hoppermc/Hopper",),
            ProjectCard(icon: "icons/unity.png", gradient: LinearGradient(colors: [
              "#4841A5".toColor().withOpacity(0.5),
              "#4841A5".toColor().withOpacity(0.5)
            ], stops: [0.55, 1], begin: Alignment.topLeft, end: Alignment.bottomRight), title: "Unity Publicizer", body:
"""
This is a pretty lightweight publicizer for .Net assemblies utilizing dnlib, 
specifically made for modding of non il2cpp built unity games. 
Generated assemblies while not executable are use in IDEs for providing
code completion.
""".replaceAll("\n", ""), tags: ["C#","Unity", "Modding"], url: "https://github.com/helightdev/UnityPublicizer",),
            ProjectCard(icon: "icons/clickup.png", gradient: LinearGradient(colors: [
              "#ff637a".toColor().withOpacity(0.75),
              "#ff637a".toColor().withOpacity(0.75),
            ], stops: [0.30, 1], begin: Alignment.topLeft, end: Alignment.bottomRight), title: "KClickUp", body:
            """
An api wrapper for the ClickUp project management platform made in Kotlin,
using ok-http supporting both personal and oauth2 based authentication.
The library is currently still work in progress and code is still subject to change.      
""".replaceAll("\n", ""), tags: ["Kotlin", "ClickUp"], url: "https://github.com/helightdev/KClickUp",),
            ProjectCard(icon: "icons/scp.png", gradient: LinearGradient(colors: [
              "#0070CC".toColor(),
              "#0070CC".toColor()
            ], stops: [0.55, 1], begin: Alignment.topLeft, end: Alignment.bottomRight), title: "Synapse2", body:
            """
Synapse is a plugin loader for the game SCP: Secret Laboratory. 
It uses Harmony to patch the c# assembly to inject its own code and plugin overrides. 
It also offers a high level api for developers to work with.
""".replaceAll("\n", ""), tags: ["C#","Unity", "Modding"], url: "https://github.com/SynapseSL/Synapse",),

          ], clipBehavior: Clip.none,),
        ),
      ),
    );
  }
}

