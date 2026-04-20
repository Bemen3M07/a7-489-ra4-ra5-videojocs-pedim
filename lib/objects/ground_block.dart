import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../ember_quest.dart';
import '../managers/segment_manager.dart';

/// Bloc de terra que forma la base del nivell.
/// També controla quan s'han de carregar nous segments.
class GroundBlock extends SpriteComponent
    with HasGameReference<EmberQuestGame> {
  /// Posició del bloc dins la graella del segment.
  final Vector2 gridPosition;

  /// Desplaçament horitzontal aplicat al crear el segment.
  double xOffset;

  /// Clau única per identificar aquest bloc final de segment.
  final UniqueKey _blockKey = UniqueKey();

  /// Velocitat usada per moure el bloc amb l'escenari.
  final Vector2 velocity = Vector2.zero();

  /// Crea un bloc de terra amb posició lògica i desplaçament.
  GroundBlock({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override

  /// Carrega l'sprite, la posició i la hitbox del bloc.
  Future<void> onLoad() async {
    final groundImage = game.images.fromCache('ground.png');
    sprite = Sprite(groundImage);
    position = Vector2(
      gridPosition.x * size.x + xOffset,
      game.size.y - gridPosition.y * size.y,
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));

    // Si és l'últim bloc del segment, es desa com a referència final.
    if (gridPosition.x == 9 && position.x > game.lastBlockXPosition) {
      game.lastBlockKey = _blockKey;
      game.lastBlockXPosition = position.x + size.x;
    }
  }

  @override

  /// Mou el bloc amb el món i carrega nous segments quan cal.
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;

    // Si surt per pantalla, s'elimina i pot generar un nou segment.
    if (position.x < -size.x || game.health <= 0) {
      removeFromParent();
      if (gridPosition.x == 0) {
        game.loadGameSegments(
          Random().nextInt(segments.length),
          game.lastBlockXPosition,
        );
      }
    }

    // El darrer bloc actiu actualitza el final visible del recorregut.
    if (gridPosition.x == 9) {
      if (game.lastBlockKey == _blockKey) {
        game.lastBlockXPosition = position.x + size.x - 10;
      }
    }

    super.update(dt);
  }
}
