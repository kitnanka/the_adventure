import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';


import 'package:the_adventure/components/player_hitbox.dart';
import 'package:the_adventure/the_adventure.dart';

class Fruits extends SpriteAnimationComponent
    with HasGameRef<TheAdventure>, CollisionCallbacks {
  final String fruits;
  Fruits({this.fruits = 'Apple', position, size})
      : super(position: position, size: size);

  final double stepTime = 0.05;
  bool collected = false;

  final hitBox = CustomHitbox(height: 12, width: 12, offSetX: 10, offsetY: 10);
  @override
  Future<void> onLoad() async {
    priority - 1;

    collidingWithPlayer();
    removeOnFinish = true;

    add(RectangleHitbox(
        position: Vector2(hitBox.offSetX, hitBox.offsetY),
        size: Vector2(hitBox.width, hitBox.height),
        collisionType: CollisionType.passive));
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/$fruits.png'),
        SpriteAnimationData.sequenced(
            amount: 17, stepTime: stepTime, textureSize: Vector2.all(32)));
    await super.onLoad();
  }

  void collidingWithPlayer() async {
 
      if(game.playSounds){
      // FlameAudio.play('collected_fruit.wav', volume:game.soundVolume );
      }
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/Collected.png'),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );
      await animationTicker?.completed;
      removeFromParent();
    
  }
}
