import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../ember_quest.dart';

/// Classe que representa un enemic que es mou per l'escenari.
/// Té animació pròpia i segueix el desplaçament general del món.
class WaterEnemy extends SpriteAnimationComponent
    with HasGameReference<EmberQuestGame> {
  /// Posició lògica de l'enemic dins la graella del nivell.
  final Vector2 gridPosition;

  /// Desplaçament horitzontal que s'afegeix a la posició inicial.
  double xOffset;

  /// Velocitat usada per moure l'enemic amb el scroll del joc.
  final Vector2 velocity = Vector2.zero();

  /// Crea l'enemic amb la seva posició de graella i desplaçament.
  WaterEnemy({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override

  /// Carrega l'animació, la posició inicial i la hitbox de l'enemic.
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('water_enemy.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(16),
        stepTime: 0.70,
      ),
    );

    // Es converteix la graella en coordenades reals del joc.
    position = Vector2(
      (gridPosition.x * size.x) + xOffset,
      game.size.y - (gridPosition.y * size.y),
    );

    // La hitbox passiva detecta contactes però no empeny altres objectes.
    add(RectangleHitbox(collisionType: CollisionType.passive));

    // Aquest efecte fa que l'enemic vagi i torni contínuament.
    add(
      MoveEffect.by(
        Vector2(-2 * size.x, 0),
        EffectController(
          duration: 3,
          alternate: true,
          infinite: true,
        ),
      ),
    );
  }

  @override

  /// Mou l'enemic amb el món i l'elimina si ja no és visible.
  void update(double dt) {
    // El desplaçament depèn de la velocitat general del món.
    velocity.x = game.objectSpeed;

    // La posició es recalcula cada frame.
    position += velocity * dt;

    // Si surt de pantalla o la partida acaba, s'elimina.
    if (position.x < -size.x || game.health <= 0) {
      removeFromParent();
    }

    super.update(dt);
  }
}
