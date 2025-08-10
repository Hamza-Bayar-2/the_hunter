import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/rendering.dart';
import 'package:flame_audio/bgm.dart';
import 'package:flame_audio/flame_audio.dart' as fa;
import 'package:flutter/foundation.dart';
import 'package:mini_game_via_flame/blocs/mini_game/mini_game_bloc.dart';
import 'package:mini_game_via_flame/constants/audio_constants.dart';
import 'package:mini_game_via_flame/constants/image_constants.dart';
import 'package:mini_game_via_flame/flame_layer/mini_game.dart';
import 'package:mini_game_via_flame/player/state/player_attack_state.dart';
import 'package:mini_game_via_flame/player/state/player_death_state.dart';
import 'package:mini_game_via_flame/player/state/player_get_hit_state.dart';
import 'package:mini_game_via_flame/player/state/player_get_life_state.dart';
import 'package:mini_game_via_flame/player/state/player_idle_state.dart';
import 'package:mini_game_via_flame/player/state/player_running_state.dart';
import 'package:mini_game_via_flame/player/state/player_state.dart';
import 'package:mini_game_via_flame/sprites/flying_eye.dart';
import 'package:mini_game_via_flame/sprites/goblin.dart';
import 'package:mini_game_via_flame/sprites/heart.dart';
import 'package:mini_game_via_flame/sprites/mushroom.dart';
import 'package:mini_game_via_flame/sprites/skeleton.dart';

enum PlayerAnimation {
  attack,
  death,
  getHit,
  idle,
  run,
}

class PlayerComponent extends SpriteAnimationGroupComponent
    with HasGameRef<MiniGame>, CollisionCallbacks {
  PlayerComponent({
    required double playerSpeed,
    required Vector2 size,
    required Vector2 position,
  })  : _playerSpeed = playerSpeed,
        _playerHypotenuseSpeed = sqrt(playerSpeed * playerSpeed / 2),
        _runSoundEffect = fa.FlameAudio.bgmFactory(
          audioCache: fa.FlameAudio.audioCache,
        ),
        _cameraShake = MoveEffect.by(
          Vector2(0, 15),
          InfiniteEffectController(ZigzagEffectController(period: 0.15)),
        ),
        _actions = <PlayerAction>{},
        _state = PlayerIdleState(),
        _velocity = Vector2.zero(),
        super(
          position: position,
          size: size,
          anchor: Anchor.center,
          current: PlayerAnimation.idle,
        );

  final double _playerSpeed;
  // When the player runs diagonally, this value will be used
  final double _playerHypotenuseSpeed;
  final Bgm _runSoundEffect;
  final MoveEffect _cameraShake;
  final Set<PlayerAction> _actions;
  PlayerState _state;
  Vector2 _velocity;

  PlayerState get state => _state;
  bool get _shouldMoveLeft => _actions.contains(PlayerAction.moveLeft);
  bool get _shouldMoveRight => _actions.contains(PlayerAction.moveRight);
  bool get _shouldMoveUp => _actions.contains(PlayerAction.moveUp);
  bool get _shouldMoveDown => _actions.contains(PlayerAction.moveDown);
  bool get _shouldAttack => _actions.contains(PlayerAction.attack);
  bool get _shouldRunHorizontally => _shouldMoveLeft != _shouldMoveRight;
  bool get _shouldRunVertically => _shouldMoveUp != _shouldMoveDown;
  bool get _hasOppositeHorizontalInputs => _shouldMoveLeft && _shouldMoveRight;
  bool get _hasOppositeVerticalInputs => _shouldMoveUp && _shouldMoveDown;
  bool get _shouldIdle =>
      !_shouldRunHorizontally && !_shouldRunVertically ||
      _hasOppositeHorizontalInputs ||
      _hasOppositeVerticalInputs;
  bool get _shouldRun => !_shouldIdle;
  bool get _isRunningDiagonally =>
      (_shouldMoveLeft || _shouldMoveRight) &&
      (_shouldMoveUp || _shouldMoveDown);
  bool get shouldPlayerDie => gameRef.miniGameBloc.state.isArcherDead;
  bool get _isPlayerLowHealth => gameRef.miniGameBloc.state.archerHealth <= 20;

  @override
  Future<void> onLoad() async {
    await add(
      RectangleHitbox.relative(
        Vector2(0.25, 0.30),
        parentSize: size,
        anchor: Anchor.center,
      ),
    );
    _loadAnimation();
    gameRef.cameraComponent.viewfinder.add(_cameraShake);
    _cameraShake.pause();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _state.update(
      deltaTime: dt,
      player: this,
    );
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    _state.onCollision(
      intersectionPoints: intersectionPoints,
      other: other,
      player: this,
    );
    super.onCollision(intersectionPoints, other);
  }

  void onInput(Set<PlayerAction> actions) {
    _actions.clear();
    _actions.addAll(actions);
    _state.handleInput(
      player: this,
      actions: actions,
    );
  }

  // this helps us to manage all the animation that belongs to the archer
  void _loadAnimation() {
    double time = 0.07;

    final attackAnimation = _spriteAnimation(
      archerState: "Attack",
      frameAmount: 6,
      stepTime: 0.085,
      loop: true,
    );
    final deathAnimation = _spriteAnimation(
      archerState: "Death",
      frameAmount: 10,
      stepTime: time,
      loop: false,
    );
    final getHitAnimation = _spriteAnimation(
      archerState: "Get Hit",
      frameAmount: 3,
      stepTime: time,
      loop: false,
    );
    final idleAnimation = _spriteAnimation(
      archerState: "Idle",
      frameAmount: 10,
      stepTime: time,
      loop: true,
    );
    final runAnimation = _spriteAnimation(
      archerState: "Run",
      frameAmount: 8,
      stepTime: time,
      loop: true,
    );

    animations = {
      PlayerAnimation.attack: attackAnimation,
      PlayerAnimation.death: deathAnimation,
      PlayerAnimation.getHit: getHitAnimation,
      PlayerAnimation.idle: idleAnimation,
      PlayerAnimation.run: runAnimation,
    };
  }

  // this method is used to prevent repeating the same code
  // An animation is created by giving the name of the file and the number of the frames in the sheet
  SpriteAnimation _spriteAnimation({
    required String archerState,
    required int frameAmount,
    required double stepTime,
    required bool loop,
  }) {
    return SpriteAnimation.fromFrameData(
      gameRef.images.fromCache(_getArcherImagePath(archerState)),
      SpriteAnimationData.sequenced(
        amount: frameAmount,
        stepTime: stepTime,
        textureSize: Vector2.all(100),
        loop: loop,
      ),
    );
  }

  String _getArcherImagePath(String archerState) {
    switch (archerState) {
      case "Idle":
        return ImageConstants.archerCharacterIdle;
      case "Run":
        return ImageConstants.archerCharacterRun;
      case "Attack":
        return ImageConstants.archerCharacterAttack;
      case "Death":
        return ImageConstants.archerCharacterDeath;
      case "Get Hit":
        return ImageConstants.archerCharacterGetHit;
      default:
        return ImageConstants.archerCharacterIdle;
    }
  }

  void setIdleState() {
    if ((!_shouldIdle || _shouldAttack)) {
      return;
    }
    current = PlayerAnimation.idle;
    _state = PlayerIdleState();
    _runSoundEffect.stop();
    debugPrint('state: ${_state.runtimeType}');
  }

  void forceIdleState() {
    current = PlayerAnimation.idle;
    _state = PlayerIdleState();
    _runSoundEffect.stop();
    debugPrint('state: ${_state.runtimeType} (forced)');
  }

  void setRunState() {
    if (!_shouldRun || _shouldAttack) {
      return;
    }
    current = PlayerAnimation.run;
    _state = PlayerRunningState();
    _runSoundEffect.play(AudioConstants.running);
    debugPrint("state: ${_state.runtimeType}");
  }

  void setAttackState() {
    if (!_shouldAttack) {
      return;
    }
    current = PlayerAnimation.attack;
    _state = PlayerAttackState();
    _runSoundEffect.stop();
    debugPrint("state: ${_state.runtimeType}");
  }

  void setGetHitState() {
    _changePlayerColor(
      const Color.fromARGB(93, 255, 0, 0),
    );

    fa.FlameAudio.play(AudioConstants.hurt);
    _cameraShake.resume();
    gameRef.miniGameBloc.add(DecreaseHealthEvent());
    current = PlayerAnimation.getHit;
    _state = PlayerGetHitState();
    debugPrint("state: ${_state.runtimeType}");
    animationTicker?.onComplete = () {
      forceIdleState();
      // if the player in low health do not remove the red color effect
      if (!_isPlayerLowHealth) {
        _removePlayerColor();
      }
      setDeathState();
    };
  }

  void setGetLifeState() {
    _changePlayerColor(
      const Color.fromARGB(143, 92, 255, 92),
    );

    gameRef.miniGameBloc.add(IncreaseHealthEvent());
    // TODO change get hit with other animation
    current = PlayerAnimation.getHit;
    _state = PlayerGetLifeState();
    debugPrint("state: ${_state.runtimeType}");
    animationTicker?.onComplete = () {
      forceIdleState();
      if (_isPlayerLowHealth) {
        _changePlayerColor(
          const Color.fromARGB(93, 255, 0, 0),
        );
      } else {
        _removePlayerColor();
      }
    };
  }

  void setDeathState() {
    if (!shouldPlayerDie) {
      return;
    }
    _changePlayerColor(
      const Color.fromARGB(93, 255, 0, 0),
    );

    fa.FlameAudio.play(AudioConstants.death);
    fa.FlameAudio.play(AudioConstants.lose, volume: 0.5);
    current = PlayerAnimation.death;
    _state = PlayerDeathState();
    animationTicker?.onComplete = () {
      gameRef.miniGameBloc.add(GoToWinOrLosePage());
    };
    _runSoundEffect.stop();
    debugPrint("state: ${_state.runtimeType}");
  }

  void playerMovement(double dt) {
    double horizontalSpeed = 0.0, verticalSpeed = 0.0;

    if (_isRunningDiagonally) {
      horizontalSpeed =
          _shouldMoveLeft ? -_playerHypotenuseSpeed : _playerHypotenuseSpeed;
      verticalSpeed =
          _shouldMoveUp ? -_playerHypotenuseSpeed : _playerHypotenuseSpeed;
    } else {
      if (_shouldRunHorizontally) {
        horizontalSpeed = _shouldMoveLeft ? -_playerSpeed : _playerSpeed;
      }
      if (_shouldRunVertically) {
        verticalSpeed = _shouldMoveUp ? -_playerSpeed : _playerSpeed;
      }
    }

    _velocity = Vector2(horizontalSpeed, verticalSpeed);
    position.add(_velocity * dt);

    // this keeps the player inside the screen
    position.clamp(
      Vector2(
        size.x - (size.x / 1.2),
        gameRef.background.size.y * 0.6 - size.y,
      ),
      Vector2(
            gameRef.background.size.x,
            gameRef.background.size.y,
          ) -
          (size / 6),
    );
  }

  void playerFacingDirection() {
    if (_shouldMoveLeft) {
      if (gameRef.miniGameBloc.state.isPlayerFacingRight) {
        flipHorizontallyAroundCenter();
        gameRef.miniGameBloc.add(FaceLeftEvent());
      }
    } else {
      if (!gameRef.miniGameBloc.state.isPlayerFacingRight) {
        flipHorizontallyAroundCenter();
        gameRef.miniGameBloc.add(FaceRightEvent());
      }
    }
  }

  void onEnemyCollision(PositionComponent other) {
    if (other is Goblin ||
        other is Mushroom ||
        other is Skeleton ||
        other is FlyingEye) {
      debugPrint("get hit: ${other.runtimeType}");
      setGetHitState();
    }
    _cameraShake.pause();
  }

  void onHeartCollision(PositionComponent other) {
    if (other is Heart) {
      setGetLifeState();
    }
    _cameraShake.pause();
  }

  void _changePlayerColor(Color color) {
    decorator.replaceLast(
      PaintDecorator.tint(
        color,
      ),
    );
  }

  void _removePlayerColor() {
    decorator.replaceLast(null);
  }
}
