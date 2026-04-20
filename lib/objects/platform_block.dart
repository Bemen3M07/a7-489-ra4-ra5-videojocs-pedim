import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../ember_quest.dart';

/// Plataforma on el jugador pot pujar durant el nivell.
/// Es mou amb l'escenari igual que la resta de blocs.
class PlatformBlock extends SpriteComponent
    with HasGameReference<EmberQuestGame> {
  /// Posició lògica de la plataforma dins la graella.
  final Vector2 gridPosition;

  /// Desplaçament horitzontal aplicat al segment.
  double xOffset;

  /// Velocitat usada per seguir el scroll del món.
  final Vector2 velocity = Vector2.zero();

  /// Crea una plataforma amb la seva posició i offset.
  PlatformBlock({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override

  /// Carrega la imatge, calcula la posició i afegeix la hitbox.
  Future<void> onLoad() async {
    final platformImage = game.images.fromCache('block.png');
    sprite = Sprite(platformImage);
    position = Vector2(
      (gridPosition.x * size.x) + xOffset,
      game.size.y - (gridPosition.y * size.y),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override

  /// Mou la plataforma i l'elimina quan surt de pantalla.
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;
    if (position.x < -size.x || game.health <= 0) {
      removeFromParent();
    }
    super.update(dt);
  }
}
