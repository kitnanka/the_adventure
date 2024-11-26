import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:the_adventure/the_adventure.dart';

class Saw extends SpriteAnimationComponent with HasGameRef<TheAdventure> {
  final bool isVertical;
  final double offsetNeg;
  final double offsetPos;

  Saw({
    position,
    size,
    this.isVertical = false,
    this.offsetNeg = 0,
    this.offsetPos = 0,
  }) : super(position: position, size: size);

  final double sawSpeed = 0.03;
  static const mooveSpeed = 50;
  static const tileSize = 16;
  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;

  @override
  Future<void> onLoad() async {
    priority = -1;
    add(CircleHitbox());
    debugMode = true;

    if (isVertical) {
      rangeNeg = position.y - offsetNeg * tileSize;
      rangePos = position.y + offsetPos * tileSize;
    } else {
      rangeNeg = position.x - offsetNeg * tileSize;
      rangePos = position.x + offsetPos * tileSize;
    }
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Traps/Saw/On (38x38).png'),
        SpriteAnimationData.sequenced(
            amount: 8, stepTime: sawSpeed, textureSize: Vector2.all(38)));
    await super.onLoad();
  }

  @override
  void update(double dt) {
    if (isVertical) {
      _moveVertivally(dt);
    } else {
      _moveHorizontally(dt);
    }
    super.update(dt);
  }

  void _moveVertivally(double dt) {
    if (position.y >= rangePos) {
      moveDirection = -1;
    } else if (position.y <= rangeNeg) {
      moveDirection = 1;
    }
    position.y += moveDirection * mooveSpeed * dt;
  }

  void _moveHorizontally(double dt) {
    if (position.x >= rangePos) {
      moveDirection = -1;
    } else if (position.x <= rangeNeg) {
      moveDirection = 1;
    }
    position.x += moveDirection * mooveSpeed * dt;
  }
}
