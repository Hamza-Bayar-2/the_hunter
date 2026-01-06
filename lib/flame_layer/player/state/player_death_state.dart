import 'package:flame/components.dart';
import 'package:the_hunter/flame_layer/player/player_component.dart';
import 'package:the_hunter/flame_layer/player/state/player_state.dart';

class PlayerDeathState implements PlayerState {
  @override
  void handleInput({
    required Set<PlayerAction> actions,
    required PlayerComponent player,
  }) {
    // TODO: implement handleInput
  }

  @override
  void update({
    required double deltaTime,
    required PlayerComponent player,
  }) {
    if (!player.shouldPlayerDie) {
      player.decorator.replaceLast(null);
      player.forceIdleState();
    }
  }

  @override
  void onCollision({
    required Set<Vector2> intersectionPoints,
    required PositionComponent other,
    required PlayerComponent player,
  }) {}
}
