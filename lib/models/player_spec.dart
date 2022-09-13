import 'dart:ui';

import 'player_bullet_spec.dart';

class PlayerSpec {
  PlayerSpec({
    required this.imageSrc,
    required this.size,
    required this.maxSpeed,
    required this.maxHealth,
    required this.maxEnergy,
    required this.bulletSpec,
  }) : _health = maxHealth;

  final String imageSrc;
  final Size size;
  final double maxSpeed;
  final int maxHealth;
  final int maxEnergy;
  final PlayerBulletSpec bulletSpec;

  int _health;
  int get health => _health;

  int _energy = 0;
  int get energy => _energy;

  bool _isDead = false;
  bool get isDead => _isDead;

  int _score = 0;
  int get score => _score;

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

  void gainEnergy(int energy) {
    _energy += energy;
    if (_energy > maxEnergy) {
      _energy = maxEnergy;
    }
  }

  void gainScore(int score) {
    _score += score;
  }

  void kill() {
    _health = 0;
    _isDead = true;
  }
}
