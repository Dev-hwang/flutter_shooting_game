import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_shooting_game/components/player.dart';
import 'package:flutter_shooting_game/models/enemy_bullet_spec.dart';

class EnemyBullet extends SpriteComponent with CollisionCallbacks {
  EnemyBullet({
    required this.spec,
    required this.direction,
    super.position,
    super.anchor,
  }) : super(size: Vector2(spec.imageSize.width, spec.imageSize.height));

  final EnemyBulletSpec spec;
  final Vector2 direction;

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
    position += direction * spec.speed * dt;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is ScreenHitbox) {
      removeFromParent();
    } else if (other is Player) {
      destroy();
    }
  }

  void destroy() {
    // TODO: Effect 추가 필요
    removeFromParent();
  }
}
