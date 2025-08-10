import 'dart:async';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:mini_game_via_flame/blocs/mini_game/mini_game_bloc.dart';
import 'package:mini_game_via_flame/flame_layer/mini_game.dart';
import 'package:mini_game_via_flame/player/player_component.dart';
import 'package:mini_game_via_flame/sprites/flyingEye.dart';
import 'package:mini_game_via_flame/sprites/goblin.dart';
import 'package:mini_game_via_flame/sprites/mushroom.dart';
import 'package:mini_game_via_flame/sprites/skeleton.dart';

class Arrow extends SpriteAnimationComponent
    with HasGameRef<MiniGame>, CollisionCallbacks, HasVisibility {
  Arrow({
    required PlayerComponent playerComponent,
    SpriteAnimation? animation,
    Vector2? position,
    Vector2? size,
    Anchor? anchor,
  })  : _playerComponent = playerComponent,
        super(
          animation: animation,
          position: position,
          size: size,
          anchor: anchor,
        );

  final PlayerComponent _playerComponent;
  final double _arrowSpeed = 600;
  final Random _random = Random();
  late final RectangleHitbox hitbox;
  late bool _isArcherFacingRight;
  Vector2 velocity = Vector2.zero();
  bool isArrowFacingRight = true;

  @override
  FutureOr<void> onLoad() {
    // the reason why I used variable instead of using it directly inside the "if"
    // because when I do it like that the arrow will change direction
    // according to the archer even after leaving the bow
    _isArcherFacingRight = gameRef.miniGameBloc.state.isPlayerFacingRight;
    hitbox = RectangleHitbox();
    add(hitbox);
    isVisible = false;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isVisible) {
      _arrowMovement(dt);
      _arrowParticle();
      _onArrowOutOfBoundaries();
    } else {
      // this will change the direction of the arrow after the creation
      // without this line the created arrow will not change its direction even if the archer changes her direction
      _isArcherFacingRight = gameRef.miniGameBloc.state.isPlayerFacingRight;
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Goblin || other is Mushroom || other is FlyingEye) {
      hit();
      gameRef.miniGameBloc.add(KillMonster());
    } else if (other is Skeleton) {
      hit();
      if (!other.isShielding) {
        gameRef.miniGameBloc.add(KillMonster());
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  void _arrowMovement(double dt) {
    double directionX = 0.0;
    // this for set the arrow direction (right or left)
    if (_isArcherFacingRight) {
      directionX += _arrowSpeed;
      if (!isArrowFacingRight) {
        flipHorizontallyAroundCenter();
        isArrowFacingRight = true;
      }
    } else {
      directionX -= _arrowSpeed;
      if (isArrowFacingRight) {
        flipHorizontallyAroundCenter();
        isArrowFacingRight = false;
      }
    }

    velocity = Vector2(directionX, 0);
    position.add(velocity * dt);
  }

  void _onArrowOutOfBoundaries() {
    if (position.x < 0 || position.x > gameRef.background.size.x) {
      hit();
    }
  }

  void _arrowParticle() {
    add(
      ParticleSystemComponent(
        particle: Particle.generate(
          lifespan: 0.1,
          count: 2,
          generator: (i) => AcceleratedParticle(
            position: Vector2(0, position.y * 0.01),
            acceleration: _randomVector2ForArrow(),
            speed: _randomVector2ForArrow(),
            child: CircleParticle(
              radius: 1,
              paint: Paint()..color = Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Vector2 _randomVector2ForArrow() =>
      (-Vector2.random(_random) - Vector2(1, -0.5)) * 300;

  void fire() {
    isVisible = true;
    hitbox.collisionType = CollisionType.active;
    position = Vector2(
      _playerComponent.position.x,
      _playerComponent.position.y - (size.y * 3),
    );
  }

  void hit() {
    isVisible = false;
    hitbox.collisionType = CollisionType.inactive;
  }
}
