import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:the_hunter/constants/audio_constants.dart';
import 'package:the_hunter/constants/image_constants.dart';
import 'package:the_hunter/flame_layer/mini_game.dart';
import 'package:the_hunter/flame_layer/player/player_component.dart';
import 'package:the_hunter/flame_layer/sprites/arrow.dart';

enum SkeletonState { run, death, attack, shield }

class Skeleton extends SpriteAnimationGroupComponent
    with HasGameReference<MiniGame>, CollisionCallbacks, HasVisibility {
  bool isSpawnRight;
  Vector2 enemySize;
  Skeleton({
    Vector2? position,
    required this.enemySize,
    Anchor anchor = Anchor.center,
    required this.isSpawnRight,
  }) : super(position: position, size: enemySize, anchor: anchor);

  double skeletonSpeed = 120;
  bool isSkeletonFacingRight = true;
  bool isDying = false;
  bool isShielding = false;
  final Timer skeletonDeathTimer = Timer(0.39);
  final Timer bloodTimer = Timer(0.1);
  late final rectangleHitbox =
      RectangleHitbox.relative(parentSize: enemySize, Vector2(0.15, 0.33))
        ..debugMode = false;
  List<Arrow> shieldingArrows = [];

  @override
  FutureOr<void> onLoad() {
    _loadAnimation();
    add(rectangleHitbox);
    deactivate();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (game.miniGameBloc.state.isArcherDead ||
        game.miniGameBloc.state.isTheGameReset ||
        (game.miniGameBloc.state.gameStage == 1 &&
            game.miniGameBloc.state.monsterKillNumber == 0)) {
      deactivate();
    }

    if (isVisible) {
      if (isDying) {
        _bloodParticles(dt);
        _skeletonDeath(dt);
      } else {
        if (isShielding) {
          _skeletonShield();
        } else {
          _skeletonMovement(dt);
          _isSkeletonShielding();
        }
      }
    } else {
      bloodTimer.reset();
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Arrow && !isDying) {
      if (isShielding) {
        FlameAudio.play(AudioConstants.shield);
      } else {
        isDying = true;
        FlameAudio.play(AudioConstants.skeletonDeath);
      }
    } else if (other is PlayerComponent) {
      deactivate();
    }
    super.onCollision(intersectionPoints, other);
  }

  void _loadAnimation() {
    double time = 0.1;
    final runAnimation = _spriteAnimation(
        skeletonState: "Walk", frameAmount: 4, stepTime: time * 1.5);
    final deathAnimation = _spriteAnimation(
        skeletonState: "Death", frameAmount: 4, stepTime: time);
    final attackAnimation = _spriteAnimation(
        skeletonState: "Attack", frameAmount: 8, stepTime: time);
    final shieldAnimation = _spriteAnimation(
        skeletonState: "Shield", frameAmount: 4, stepTime: 0.2);

    animations = {
      SkeletonState.run: runAnimation,
      SkeletonState.death: deathAnimation,
      SkeletonState.attack: attackAnimation,
      SkeletonState.shield: shieldAnimation,
    };
  }

  SpriteAnimation _spriteAnimation(
      {required String skeletonState,
      required int frameAmount,
      required double stepTime}) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(_getSkeletonImagePath(skeletonState)),
      SpriteAnimationData.sequenced(
        amount: frameAmount,
        stepTime: stepTime,
        textureSize: Vector2.all(150),
      ),
    );
  }

  String _getSkeletonImagePath(String skeletonState) {
    switch (skeletonState) {
      case "Walk":
        return ImageConstants.skeletonWalk;
      case "Death":
        return ImageConstants.skeletonDeath;
      case "Attack":
        return ImageConstants.skeletonAttack;
      case "Shield":
        return ImageConstants.skeletonShield;
      default:
        return ImageConstants.skeletonWalk;
    }
  }

  void _skeletonMovement(double dt) {
    Vector2 velocity = Vector2.zero();
    double directionX = 0.0;

    if (isSpawnRight) {
      directionX -= skeletonSpeed;
      if (isSkeletonFacingRight) {
        flipHorizontallyAroundCenter();
        isSkeletonFacingRight = false;
      }
      current = SkeletonState.run;

      if (position.x < 0) {
        deactivate();
        position = Vector2(game.background.size.x, 0);
      }
    } else {
      directionX += skeletonSpeed;
      if (!isSkeletonFacingRight) {
        flipHorizontallyAroundCenter();
        isSkeletonFacingRight = true;
      }
      current = SkeletonState.run;

      if (position.x > game.background.size.x) {
        deactivate();
        position = Vector2(0, 0);
      }
    }

    velocity = Vector2(directionX, 0);
    position.add(velocity * dt);
  }

  void _bloodParticles(double dt) {
    if (bloodTimer.finished) {
      bloodTimer.pause();
    } else {
      bloodTimer.resume();
      bloodTimer.update(dt);
      add(game.bloodParticlesForMonsters(enemySize * 0.45));
    }
  }

  void _skeletonDeath(double dt) {
    rectangleHitbox.collisionType = CollisionType.inactive;
    skeletonDeathTimer.resume();
    skeletonDeathTimer.update(dt);
    current = SkeletonState.death;
    if (skeletonDeathTimer.finished) {
      deactivate();
      isDying = false;
      skeletonDeathTimer.stop();
    }
  }

  void _isSkeletonShielding() {
    for (Arrow activeArrow in game.arrowPool.getArrowPool) {
      if (activeArrow.isVisible &&
          activeArrow.isArrowFacingRight &&
          !isSkeletonFacingRight &&
          position.x - activeArrow.position.x > 340) {
        shieldingArrows.add(activeArrow);
      } else if (activeArrow.isVisible &&
          !activeArrow.isArrowFacingRight &&
          isSkeletonFacingRight &&
          activeArrow.position.x - position.x > 340) {
        shieldingArrows.add(activeArrow);
      }

      isShielding = shieldingArrows.isNotEmpty;
    }
  }

  void _skeletonShield() {
    current = SkeletonState.shield;
    shieldingArrows.removeWhere((arrow) => !arrow.isVisible);
    if (shieldingArrows.isEmpty) {
      isShielding = false;
    }
  }

  void activate() {
    isVisible = true;
    rectangleHitbox.collisionType = CollisionType.active;
  }

  void deactivate() {
    isVisible = false;
    rectangleHitbox.collisionType = CollisionType.inactive;
  }
}
