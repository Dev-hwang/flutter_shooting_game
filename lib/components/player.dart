import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_shooting_game/components/enemy.dart';
import 'package:flutter_shooting_game/components/enemy_bullet.dart';
import 'package:flutter_shooting_game/components/player_bullet.dart';
import 'package:flutter_shooting_game/models/player_spec.dart';
import 'package:flutter_shooting_game/shooting_game.dart';

enum PlayerState {
  alive,
  dead,
}

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<ShootingGame>, CollisionCallbacks {
  Player({
    required this.joystick,
    required this.spec,
    super.position,
  }) : super(
          current: PlayerState.alive,
          anchor: Anchor.center,
          size: Vector2(spec.size.width, spec.size.height),
        );

  final JoystickComponent joystick;
  final PlayerSpec spec;

  late final SpriteAnimation playerSprite;
  late final SpriteAnimation playerDeadSprite;

  Timer? _attackTimer;

  @override
  Future<void> onLoad() async {
    final playerImage = await Flame.images.load(spec.imageSrc);
    final playerSheet = SpriteSheet.fromColumnsAndRows(
      image: playerImage,
      columns: 3,
      rows: 4,
    );
    playerSprite = SpriteAnimation.spriteList(
      [
        playerSheet.getSprite(1, 0),
        playerSheet.getSprite(1, 1),
        playerSheet.getSprite(1, 2),
      ],
      stepTime: 1,
      loop: true,
    );
    playerDeadSprite = playerSprite;
    add(
      CircleHitbox.relative(
        0.4,
        parentSize: size,
        position: size / 2,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void onMount() {
    animations = {
      PlayerState.alive: playerSprite,
      PlayerState.dead: playerDeadSprite,
    };
    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (spec.isDead) {
      dead();
    } else {
      _attackTimer?.update(dt);

      if (!joystick.delta.isZero()) {
        position.add(joystick.relativeDelta * spec.maxSpeed * dt);
      }

      position.clamp(size / 2, gameRef.size - size / 2);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is EnemyBullet) {
      spec.loseHealth(other.spec.damage);
    } else if (other is Enemy) {
      if (other.current == EnemyState.kamikaze) {
        spec.loseHealth(other.spec.health ~/ 4);
      } else {
        spec.loseHealth(1);
      }
    }
  }

  @override
  void onRemove() {
    stopAttack();
    super.onRemove();
  }

  void startAttack() {
    if (_attackTimer != null) return;
    _attackTimer = Timer(
      0.1,
      onTick: fireBullet,
      repeat: true,
    );
  }

  void stopAttack() {
    if (_attackTimer == null) return;
    _attackTimer?.stop();
    _attackTimer = null;
  }

  void fireBullet() {
    final bullet = PlayerBullet(
      spec: spec.bulletSpec,
      position: position.clone() + Vector2(size.x / 2, 0),
      anchor: Anchor.center,
    );

    gameRef.add(bullet);
  }

  void dead() {
    if (current == PlayerState.dead) return;
    current = PlayerState.dead;

    // TODO: 전투 결과 페이지 추가 필요
    // gameRef.router.pushNamed('game_result');
  }
}
