import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'actors/ember.dart';
import 'actors/water_enemy.dart';
import 'managers/segment_manager.dart';
import 'objects/ground_block.dart';
import 'objects/platform_block.dart';
import 'objects/star.dart';
import 'overlays/hud.dart';

class EmberQuestGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  late EmberPlayer _ember;
  double objectSpeed = 0.0;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;
  int starsCollected = 0;
  int health = 3;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'block.png',
      'gorilla.png', // Cambiado de ember.png
      'ground.png',
      'heart_half.png',
      'heart.png',
      'banana.png', // Cambiado de star.png
      'water_enemy.png',
    ]);

    camera.viewfinder.anchor = Anchor.topLeft;
    initializeGame(true);
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 0, 100, 0); // Cambiado a verde
  }

  void initializeGame(bool loadHud) {
    final segmentsToLoad = (size.x / 640).ceil();
    final maximumIndex = segments.length - 1;
    final segmentCount = segmentsToLoad > maximumIndex ? maximumIndex : segmentsToLoad;

    for (var i = 0; i <= segmentCount; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }

    _ember = EmberPlayer(
      position: Vector2(128, canvasSize.y - 128),
    );
    world.add(_ember);
    if (loadHud) {
      add(
        Hud(
          position: Vector2.zero(),
          size: Vector2(size.x, 100),
        ),
      );
    }
  }

  void reset() {
    // Reset game state
    starsCollected = 0;
    health = 3;
    objectSpeed = 0.0;
    lastBlockXPosition = 0.0;
    lastBlockKey = UniqueKey();

    // Clear all components from the world except HUD
    world.children.where((component) => component is! Hud).toList().forEach((component) => component.removeFromParent());

    // Reinitialize the game without reloading HUD
    initializeGame(false);
  }

  @override
  void update(double dt) {
    if (health <= 0 && !overlays.isActive('GameOver')) {
      overlays.add('GameOver');
    }
    super.update(dt);
  }

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      switch (block.blockType) {
        case GroundBlock:
          world.add(GroundBlock(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case PlatformBlock:
          world.add(PlatformBlock(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case Star:
          world.add(Star(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case WaterEnemy:
          world.add(WaterEnemy(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
      }
    }
  }
}
