import 'package:flame/components.dart';
import 'package:mini_game_via_flame/player/player_component.dart';
import 'package:mini_game_via_flame/player/state/player_state.dart';

class PlayerGetLifeState implements PlayerState {
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
    // TODO: implement update
  }

  @override
  void onCollision({
    required Set<Vector2> intersectionPoints,
    required PositionComponent other,
    required PlayerComponent player,
  }) {
    player.onEnemyCollision(other);
  }
}
