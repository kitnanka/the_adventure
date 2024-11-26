import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/painting.dart';


import 'package:flame/game.dart';

class BackgroundTile extends ParallaxComponent {
  final String color;
  final double scrollSpeed = 0.4;

  BackgroundTile({this.color = 'Gray', Vector2? position})
      : super(position: position ?? Vector2.zero());

  @override
  FutureOr<void> onLoad() async {
    priority = -10;
    size = Vector2.all(64.6);
    parallax = await game.loadParallax(
      [ParallaxImageData('Background/$color.png')],
      baseVelocity: Vector2(0, -scrollSpeed),
      repeat: ImageRepeat.repeat,
      fill: LayerFill.none,
    );
    return super.onLoad();
  }
}
