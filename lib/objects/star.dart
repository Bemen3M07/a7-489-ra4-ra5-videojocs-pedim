import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../ember_quest.dart';

/// Objecte col·leccionable que suma puntuació al jugador.
/// També té una petita animació per destacar a la pantalla.
class Star extends SpriteComponent with HasGameReference<EmberQuestGame> {
  /// Posició de l'objecte dins la graella del nivell.
  final Vector2 gridPosition;

  /// Desplaçament horitzontal aplicat al segment.
  double xOffset;

  /// Velocitat usada per moure l'objecte amb el món.
  final Vector2 velocity = Vector2.zero();

  /// Crea el col·leccionable amb la seva posició i offset.
  Star({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  @override

  /// Carrega l'sprite, la hitbox i l'animació de mida.
  Future<void> onLoad() async {
    final starImage = game.images.fromCache('banana.png');
    sprite = Sprite(starImage);
    position = Vector2(
      (gridPosition.x * size.x) + xOffset + (size.x / 2),
      game.size.y - (gridPosition.y * size.y) - (size.y / 2),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));

    // Aquesta animació fa que l'objecte sembli més viu.
    add(
      SizeEffect.by(
        Vector2(-24, -24),
        EffectController(
          duration: .75,
          reverseDuration: .5,
          infinite: true,
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  @override

  /// Mou l'objecte amb l'escenari i l'elimina si desapareix.
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;
    if (position.x < -size.x || game.health <= 0) {
      removeFromParent();
    }
    super.update(dt);
  }
}
