import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:the_adventure/components/background_tile.dart';
import 'package:the_adventure/components/checkpoint.dart';
import 'package:the_adventure/components/collision_block.dart';
import 'package:the_adventure/components/fruits.dart';
import 'package:the_adventure/components/player.dart';
import 'package:the_adventure/components/saw.dart';

class Level extends World with HasGameRef {
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];
  final Player player;
  final String levelName;
  Level({required this.levelName, required this.player});

  @override
  FutureOr<void> onLoad() async {
      priority = -1;
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
  

    add(level);

    _scrollingBackground();
    _spawiningObjects();
    _addCollisions();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer('background');
 if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue('backgroundColor');

          final backgroundTile = BackgroundTile(
              color: backgroundColor ?? 'Blue',
              position: Vector2(0,0));
          add(backgroundTile);
     
    }
  }

  void _spawiningObjects() {
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('spawn point');

    if (spawnPointLayer != null) {
      for (final spawnPoint in spawnPointLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.scale.x = 1;
            add(player);
            break;
          case 'Fruits':
            final fruit = Fruits(
              fruits: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(fruit);
            break;
            case 'Saw':
            final isVertical = spawnPoint.properties.getValue('isVertical');
                 final offsetNeg = spawnPoint.properties.getValue('offsetNeg');
                      final offsetPos = spawnPoint.properties.getValue('offsetPos');
            final saw = Saw(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              isVertical: isVertical,
              offsetNeg: offsetNeg,
              offsetPos: offsetPos
            );
            add(saw);
            break;
            case 'Checkpoint':
             final checkpoint = CheckPoint(
                            position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
             );
             add(checkpoint);
          
          default:
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>("collisions");

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height),
                isPlatform: true);
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }

    player.collisionBlocks = collisionBlocks;
  }
}
