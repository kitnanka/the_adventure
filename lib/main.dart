import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:the_adventure/the_adventure.dart';

void main()async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  TheAdventure game = TheAdventure();
  runApp(GameWidget(game: kDebugMode ? TheAdventure() : game));
}

