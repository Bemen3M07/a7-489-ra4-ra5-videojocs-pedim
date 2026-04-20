import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';

import '../ember_quest.dart';
import '../objects/ground_block.dart';
import '../objects/platform_block.dart';
import '../objects/star.dart';
import 'water_enemy.dart';

/// Classe que representa el personatge principal.
/// Gestiona el moviment, el salt i les col·lisions del jugador.
class EmberPlayer extends SpriteAnimationComponent
    with KeyboardHandler, CollisionCallbacks, HasGameReference<EmberQuestGame> {
  /// Guarda la velocitat actual del jugador en cada eix.
  final Vector2 velocity = Vector2.zero();

  /// Marca la velocitat horitzontal del jugador.
  final double moveSpeed = 200;

  /// Valor de gravetat que fa caure el personatge.
  final double gravity = 15;

  /// Força inicial que s'aplica quan salta.
  final double jumpSpeed = 600;

  /// Limita la velocitat màxima de caiguda.
  final double terminalVelocity = 150;

  /// Vector de suport per detectar col·lisions des de dalt.
  final Vector2 fromAbove = Vector2(0, -1);

  /// Indica si el jugador és invulnerable després d'un cop.
  bool hitByEnemy = false;

  /// Indica si s'ha premut el botó de salt.
  bool hasJumped = false;

  /// Controla si el jugador està recolzat a terra.
  bool isOnGround = false;

  /// Guarda la direcció horitzontal: esquerra, quiet o dreta.
  int horizontalDirection = 0;

  /// Crea el jugador amb una posició inicial i mida fixa.
  EmberPlayer({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  @override

  /// Carrega l'animació del personatge i la seva hitbox.
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('gorilla.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );

    // Aquesta hitbox permet detectar contacte amb objectes del joc.
    add(CircleHitbox());
  }

  @override

  /// Llegeix el teclat per moure, saltar o pausar la partida.
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Es reinicia abans de tornar a calcular la direcció.
    horizontalDirection = 0;

    // Si es prem esquerra, el jugador es mourà cap a l'esquerra.
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;

    // Si es prem dreta, el jugador es mourà cap a la dreta.
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;

    // La barra espaiadora activa l'acció de salt.
    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    // La tecla P atura el joc i obre el menú de pausa.
    if (keysPressed.contains(LogicalKeyboardKey.keyP)) {
      game.pauseEngine();
      game.overlays.add('PauseMenu');
    }

    return true;
  }

  @override

  /// Actualitza el moviment, la gravetat i l'estat del jugador.
  void update(double dt) {
    // La velocitat lateral depèn de la tecla que s'està prement.
    velocity.x = horizontalDirection * moveSpeed;

    // Només pot saltar si està tocant el terra.
    if (hasJumped) {
      if (isOnGround) {
        velocity.y = -jumpSpeed;
        isOnGround = false;
      }

      // Això evita que el salt es repeteixi en cada frame.
      hasJumped = false;
    }

    // La gravetat fa augmentar la velocitat cap avall.
    velocity.y += gravity;

    // Es limita la velocitat vertical per evitar valors exagerats.
    velocity.y = velocity.y.clamp(-jumpSpeed, terminalVelocity);

    // Per defecte, el món no fa scroll.
    game.objectSpeed = 0;

    // Això impedeix sortir per l'extrem esquerre de la pantalla.
    if (position.x - 36 <= 0 && horizontalDirection < 0) {
      velocity.x = 0;
    }

    // Quan arriba al centre, es mou l'escenari en comptes del jugador.
    if (position.x + 64 >= game.size.x / 2 && horizontalDirection > 0) {
      velocity.x = 0;
      game.objectSpeed = -moveSpeed;
    }

    // La posició canvia segons la velocitat i el temps del frame.
    position += velocity * dt;

    super.update(dt);

    // El sprite es gira per mirar cap a la direcció correcta.
    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    // Si cau fora de pantalla, la partida es dona per perduda.
    if (position.y > game.size.y + size.y) {
      game.health = 0;
    }

    // Quan no queda vida, s'elimina el jugador del món.
    if (game.health <= 0) {
      removeFromParent();
    }
  }

  @override

  /// Resol les col·lisions amb blocs, estrelles i enemics.
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // Si toca un bloc, es corregeix la posició i el suport a terra.
    if (other is GroundBlock || other is PlatformBlock) {
      if (intersectionPoints.length == 2) {
        // Es calcula el punt central del contacte.
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        // Aquest vector indica des d'on arriba la col·lisió.
        final collisionNormal = absoluteCenter - mid;

        // Es calcula quant cal separar el jugador del bloc.
        final separationDistance = (size.x / 2) - collisionNormal.length;

        // Es normalitza per quedar-se només amb la direcció.
        collisionNormal.normalize();

        // Si el contacte ve de sota, el jugador queda sobre el bloc.
        if (fromAbove.dot(collisionNormal) > 0.9) {
          isOnGround = true;
        }

        // Això evita que el jugador quedi travessant el bloc.
        position += collisionNormal.scaled(separationDistance);
      }
    }

    // Si toca una estrella, la recull i suma un punt.
    if (other is Star) {
      other.removeFromParent();
      game.starsCollected += 1;
    }

    // Si toca un enemic, perd vida i activa la invulnerabilitat temporal.
    if (other is WaterEnemy && !hitByEnemy) {
      game.health = (game.health - 1).clamp(0, 3);
      hit();
    }

    super.onCollision(intersectionPoints, other);
  }

  /// Aplica l'efecte visual de dany i la invulnerabilitat temporal.
  void hit() {
    if (!hitByEnemy) {
      hitByEnemy = true;
    }

    add(
      OpacityEffect.fadeOut(
        EffectController(
          alternate: true,
          duration: 0.1,
          repeatCount: 6,
        ),
      )..onComplete = () {
          // En acabar el parpelleig, el jugador pot tornar a rebre dany.
          hitByEnemy = false;
        },
    );
  }
}
