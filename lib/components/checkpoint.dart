import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:the_adventure/components/player.dart';
import 'package:the_adventure/the_adventure.dart';

class CheckPoint extends SpriteAnimationComponent
    with HasGameRef<TheAdventure>, CollisionCallbacks {
  CheckPoint({position, size}) : super(size: size, position: position);

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(
      position: Vector2(18, 56),
      size: Vector2(12, 8),
      collisionType: CollisionType.passive,
    ));

    animation = SpriteAnimation.fromFrameData(
        game.images
            .fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 1, textureSize: Vector2.all(64)));
    return super.onLoad();
  }

  @override
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) _reachedCheckPoint();
    super.onCollisionStart(intersectionPoints, other);
  }

  void _reachedCheckPoint() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'),
      SpriteAnimationData.sequenced(
          amount: 26,
          stepTime: 0.05,
          textureSize: Vector2.all(64),
          loop: false),
    );

    await animationTicker?.completed;

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 10,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
      ),
    );
  }
}
