import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shooting_game/components/enemy_bullet.dart';
import 'package:flutter_shooting_game/components/player.dart';
import 'package:flutter_shooting_game/components/player_bullet.dart';
import 'package:flutter_shooting_game/models/enemy_spec.dart';
import 'package:flutter_shooting_game/shooting_game.dart';

typedef OnEnemyRemoved = void Function(Enemy enemy);

enum EnemyState {
  alive,
  kamikaze,
  dead,
}

class Enemy extends SpriteAnimationGroupComponent<EnemyState>
    with HasGameRef<ShootingGame>, CollisionCallbacks {
  Enemy({
    required this.spec,
    required this.playerTransformGetter,
    this.onRemoved,
    super.position,
  }) : super(
          current: EnemyState.alive,
          anchor: Anchor.center,
          size: Vector2(spec.size.width, spec.size.height),
        );

  final EnemySpec spec;
  final ValueGetter<Transform2D> playerTransformGetter;
  final OnEnemyRemoved? onRemoved;

  late final SpriteAnimation enemySprite;
  late final SpriteAnimation enemyDeadSprite;

  Vector2 _moveDirection = Vector2(-1, 0);
  bool _isAppearing = true;

  late final _random = Random();
  late final _moveDirectionUpdateTimer = Timer(
    2.5,
    onTick: () {
      _moveDirection = _getRandomDirection();
    },
    repeat: true,
  );
  late final _fireBulletTimer = Timer(
    spec.fireDelay,
    onTick: fireBullet,
    repeat: true,
  );
  late final _kamikazeTimer = Timer(
    20,
    onTick: () {
      if (spec.isBoss) return;
      startKamikaze();
    },
    repeat: false,
  );

  @override
  Future<void> onLoad() async {
    final enemyImage = await Flame.images.load(spec.imageSrc);
    final enemySheet = SpriteSheet.fromColumnsAndRows(
      image: enemyImage,
      columns: 3,
      rows: 4,
    );
    enemySprite = SpriteAnimation.spriteList(
      [
        enemySheet.getSprite(1, 0),
        enemySheet.getSprite(1, 1),
        enemySheet.getSprite(1, 2),
      ],
      stepTime: 1,
      loop: true,
    );
    enemyDeadSprite = enemySprite;
    add(
      CircleHitbox.relative(
        0.8,
        parentSize: size,
        position: size / 2,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void onMount() {
    animations = {
      EnemyState.alive: enemySprite,
      EnemyState.kamikaze: enemySprite,
      EnemyState.dead: enemyDeadSprite,
    };
    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.save();
    _drawHealthBar(canvas);
    canvas.restore();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (spec.isDead) {
      dead();
    } else {
      if (_isAppearing) {
        position += _moveDirection * 300 * dt;
        if (position.x < gameRef.size.x - (spec.size.width * 2)) {
          _moveDirection = _getRandomDirection();
          _isAppearing = false;
        }
        return;
      }

      if (current == EnemyState.kamikaze) {
        position += _moveDirection * 600 * dt;
      } else {
        _moveDirectionUpdateTimer.update(dt);
        _fireBulletTimer.update(dt);
        _kamikazeTimer.update(dt);

        position += _moveDirection * spec.speed * dt;
        if (position.x < ((gameRef.size.x / 2) + (size.x / 2)) ||
            position.x > (gameRef.size.x - (size.x / 2))) {
          _moveDirection.x *= -1;
          _moveDirectionUpdateTimer.reset();
        }
        if (position.y < (size.y / 2) ||
            position.y > (gameRef.size.y - (size.y / 2))) {
          _moveDirection.y *= -1;
          _moveDirectionUpdateTimer.reset();
        }
      }

      if (position.x < 0) {
        removeFromParent();
        onRemoved?.call(this);
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is PlayerBullet) {
      spec.loseHealth(other.spec.damage);
    } else if (other is Player) {
      if (current == EnemyState.kamikaze) {
        spec.kill();
      }
    }
  }

  @override
  void onRemove() {
    _moveDirectionUpdateTimer.stop();
    _fireBulletTimer.stop();
    _kamikazeTimer.stop();
    super.onRemove();
  }

  void _drawHealthBar(Canvas canvas) {
    const double marginBottom = 4;
    final healthBarSize = Size(spec.size.width, 6);

    // 체력
    final healthRect = Rect.fromLTWH(
      0,
      -(healthBarSize.height + marginBottom),
      (healthBarSize.width / spec.maxHealth) * spec.health,
      healthBarSize.height,
    );
    final healthPaint = Paint()..color = Colors.green;
    canvas.drawRect(healthRect, healthPaint);

    // 라인
    final linePath = Path()
      ..moveTo(0, -marginBottom)
      ..lineTo(0, -(healthBarSize.height + marginBottom))
      ..lineTo(healthBarSize.width, -(healthBarSize.height + marginBottom))
      ..lineTo(healthBarSize.width, -marginBottom)
      ..close();
    final linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(linePath, linePaint);
  }

  Vector2 _getRandomVector() {
    return (Vector2.random(_random) - Vector2.random(_random)) * 500;
  }

  Vector2 _getRandomDirection() {
    return Vector2(
      _random.nextBool() ? 1.0 : -1.0,
      _random.nextBool() ? 1.0 : -1.0,
    );
  }

  Vector2 _getDirectionToPlayer() {
    final fromCenter = position.toRect().center;
    final toCenter = playerTransformGetter().position.toRect().center;
    final direction = (toCenter - fromCenter).direction;

    return Offset.fromDirection(direction).toVector2();
  }

  void fireBullet() {
    final bullet = EnemyBullet(
      spec: spec.bulletSpec,
      direction: _getDirectionToPlayer(),
      position: position.clone(),
      anchor: Anchor.center,
    );

    gameRef.add(bullet);
  }

  void startKamikaze() {
    _moveDirectionUpdateTimer.stop();
    _fireBulletTimer.stop();
    _moveDirection = _getDirectionToPlayer();
    current = EnemyState.kamikaze;
  }

  void dead() {
    if (current == EnemyState.dead) return;
    current = EnemyState.dead;

    removeFromParent();
    onRemoved?.call(this);

    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 20,
        lifespan: 0.25,
        generator: (i) => AcceleratedParticle(
          acceleration: _getRandomVector(),
          speed: _getRandomVector(),
          position: position.clone(),
          child: CircleParticle(
            radius: 2,
            paint: Paint()..color = Colors.white,
          ),
        ),
      ),
    );
    gameRef.add(particleComponent);
  }
}
