import 'dart:ui';

import 'enemy_bullet_spec.dart';

class EnemySpec {
  EnemySpec({
    required this.imageSrc,
    required this.size,
    required this.speed,
    required this.score,
    required this.maxHealth,
    required this.isBoss,
    required this.bulletSpec,
    required this.fireDelay,
  }) : _health = maxHealth;

  final String imageSrc;
  final Size size;
  final double speed;
  final int score;
  final int maxHealth;
  final bool isBoss;
  final EnemyBulletSpec bulletSpec;
  final double fireDelay;

  int _health;
  int get health => _health;

  bool _isDead = false;
  bool get isDead => _isDead;

  bool loseHealth(int health) {
    _health -= health;
    if (_health < 1) {
      kill();
    }
    return isDead;
  }

  void gainHealth(int health) {
    _health += health;
    if (_health > maxHealth) {
      _health = maxHealth;
    }
  }

  void kill() {
    _health = 0;
    _isDead = true;
  }
}
