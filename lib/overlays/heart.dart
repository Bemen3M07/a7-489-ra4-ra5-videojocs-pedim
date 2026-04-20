import 'package:flame/components.dart';

import '../ember_quest.dart';

/// Estats visuals possibles de cada cor del HUD.
enum HeartState {
  available,
  unavailable,
}

/// Component que mostra un cor ple o buit segons la vida actual.
class HeartHealthComponent extends SpriteGroupComponent<HeartState>
    with HasGameReference<EmberQuestGame> {
  /// Número de cor que representa dins la barra de vida.
  final int heartNumber;

  /// Crea un component de vida en una posició concreta del HUD.
  HeartHealthComponent({
    required this.heartNumber,
    required super.position,
    required super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
  });

  @override

  /// Carrega els sprites dels dos estats i activa el cor disponible.
  Future<void> onLoad() async {
    await super.onLoad();
    final availableSprite = await game.loadSprite(
      'heart.png',
      srcSize: Vector2.all(32),
    );

    final unavailableSprite = await game.loadSprite(
      'heart_half.png',
      srcSize: Vector2.all(32),
    );

    sprites = {
      HeartState.available: availableSprite,
      HeartState.unavailable: unavailableSprite,
    };

    current = HeartState.available;
  }

  @override

  /// Actualitza el cor segons la vida actual del jugador.
  void update(double dt) {
    if (game.health < heartNumber) {
      current = HeartState.unavailable;
    } else {
      current = HeartState.available;
    }
    super.update(dt);
  }
}
