import 'package:flame/components.dart';
import 'package:the_hunter/player/player_component.dart';

enum PlayerAction {
  moveUp,
  moveDown,
  moveLeft,
  moveRight,
  attack,
}

abstract class PlayerState {
  void update({
    required double deltaTime,
    required PlayerComponent player,
  }) {}

  void handleInput({
    required Set<PlayerAction> actions,
    required PlayerComponent player,
  }) {}

  void onCollision({
    required Set<Vector2> intersectionPoints,
    required PositionComponent other,
    required PlayerComponent player,
  }) {}
}
