import 'package:flame/components.dart';
import 'package:the_hunter/flame_layer/player/player_component.dart';
import 'package:the_hunter/flame_layer/player/state/player_state.dart';

class PlayerAttackState implements PlayerState {
  @override
  void handleInput({
    required Set<PlayerAction> actions,
    required PlayerComponent player,
  }) {
    player.setIdleState();
    player.setRunState();
  }

  @override
  void update({
    required double deltaTime,
    required PlayerComponent player,
  }) {}

  @override
  void onCollision({
    required Set<Vector2> intersectionPoints,
    required PositionComponent other,
    required PlayerComponent player,
  }) {
    player.onEnemyCollision(other);
    player.onHeartCollision(other);
  }
}
