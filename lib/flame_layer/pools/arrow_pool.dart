import 'package:flame/components.dart';
import 'package:the_hunter/constants/image_constants.dart';
import 'package:the_hunter/flame_layer/mini_game.dart';
import 'package:the_hunter/flame_layer/sprites/arrow.dart';

class ArrowPool extends Component with HasGameReference<MiniGame> {
  final List<Arrow> _pool = [];

  Arrow acquire() {
    for (var arrow in _pool) {
      // if there is an unused arrow it will be returned
      if (!arrow.isVisible) {
        return arrow;
      }
    }
    // but in case no arrow is available a new arrow will be created
    // then it will be added to the pool and returned
    final newArrow = _arrowCreater();
    _pool.add(newArrow);
    return newArrow;
  }

  get getArrowPool => _pool;

  Arrow _arrowCreater() {
    return Arrow(
      playerComponent: game.playerComponent,
      position: game.playerComponent.position +
          Vector2(0, -game.background.size.y * 0.03),
      // 0.12 and 0.025 are the ratio of the arrow
      size: Vector2(game.background.size.x * game.arrowScale * 0.12,
          game.background.size.y * game.arrowScale * 0.025),
      animation: _arrowAnimation(),
      anchor: Anchor.center,
    );
  }

  SpriteAnimation _arrowAnimation() {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(ImageConstants.archerArrowMove),
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.07,
        textureSize: Vector2(24, 5),
      ),
    );
  }
}
