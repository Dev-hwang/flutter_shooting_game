import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_shooting_game/components/enemy.dart';
import 'package:flutter_shooting_game/models/player_bullet_spec.dart';

class PlayerBullet extends SpriteComponent with CollisionCallbacks {
  PlayerBullet({
    required this.spec,
    super.position,
    super.anchor,
  }) : super(size: Vector2(spec.imageSize.width, spec.imageSize.height));

  final PlayerBulletSpec spec;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(spec.imageSrc);
    add(
      RectangleHitbox(
        size: Vector2(spec.hitBoxSize.width, spec.hitBoxSize.height),
        position: size / 2,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void update(double dt) {
    position += Vector2(1, 0) * spec.speed * dt;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is ScreenHitbox) {
      removeFromParent();
    } else if (other is Enemy) {
      destroy();
    }
  }

  void destroy() {
    // TODO: Effect 추가 필요
    removeFromParent();
  }
}
