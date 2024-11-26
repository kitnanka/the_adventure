import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:the_adventure/components/jump_button.dart';
import 'package:the_adventure/components/levels.dart';
import 'package:the_adventure/components/player.dart';

class TheAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        TapCallbacks,
        HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xff211f30);
  late CameraComponent cam;
  Player player = Player(character: 'Mask Dude');
  late JoystickComponent joystick;
  bool showControls = true;
  bool playSounds = true;
  double soundVolume = 1.0;
  List<String> levelName = [
    'level-01',
    'level-01',
  ];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    _loadLevel();
    if (showControls) {
      addJoyStick();
      add(JumpButton());
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoyStick();
    }

    super.update(dt);
  }

  void addJoyStick() {
    joystick = JoystickComponent(
        priority: 10,
        knob: SpriteComponent(sprite: Sprite(images.fromCache('HUD/knob.png'))),
        background: SpriteComponent(
            sprite: Sprite(
          images.fromCache('HUD/joystick.png'),
        )),
        anchor: Anchor.bottomLeft,
        margin: const EdgeInsets.only(left: 32, bottom: 32));

    add(joystick);
  }

  void updateJoyStick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;

        break;

      default:
        player.horizontalMovement = 0;
    }
  }

  void loadNextLevel() {
    if (currentLevelIndex < levelName.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
currentLevelIndex = 0;
_loadLevel();
    }
  }

  void _loadLevel() {
    Future.delayed(
        const Duration(
          seconds: 1,
        ), () {
      Level world =
          Level(levelName: levelName[currentLevelIndex], player: player);

      cam = CameraComponent.withFixedResolution(
        height: 360,
        width: 620,
        world: world,
      );
      cam.viewfinder.anchor = Anchor.topLeft;

      addAll([cam, world]);
    });
  }
}
