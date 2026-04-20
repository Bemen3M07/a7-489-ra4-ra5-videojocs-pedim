import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../ember_quest.dart';
import 'heart.dart';

/// Interfície superior que mostra punts i vides del jugador.
class Hud extends PositionComponent with HasGameReference<EmberQuestGame> {
  /// Crea el HUD amb la seva posició i prioritat visual.
  Hud({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  });

  late TextComponent _scoreTextComponent;

  @override

  /// Carrega el text de puntuació, la icona i els cors de vida.
  Future<void> onLoad() async {
    await super.onLoad();

    _scoreTextComponent = TextComponent(
      text: '${game.starsCollected}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(10, 10, 10, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x - 60, 20),
    );
    add(_scoreTextComponent);

    // Aquesta icona acompanya el comptador de punts.
    final starSprite = await game.loadSprite('banana.png');
    add(
      SpriteComponent(
        sprite: starSprite,
        position: Vector2(game.size.x - 100, 20),
        size: Vector2.all(32),
        anchor: Anchor.center,
      ),
    );

    // Es creen tres cors per representar la vida màxima.
    for (var i = 1; i <= 3; i++) {
      final positionX = 40 * i;
      await add(
        HeartHealthComponent(
          heartNumber: i,
          position: Vector2(positionX.toDouble(), 20),
          size: Vector2.all(32),
        ),
      );
    }
  }

  @override

  /// Refresca el text perquè mostri les estrelles recollides.
  void update(double dt) {
    _scoreTextComponent.text = '${game.starsCollected}';
    super.update(dt);
  }
}
