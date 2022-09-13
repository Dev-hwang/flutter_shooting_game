import 'dart:ui';

enum EnemyBulletType {
  normal,
}

class EnemyBulletSpec {
  const EnemyBulletSpec({
    required this.imageSrc,
    required this.imageSize,
    required this.hitBoxSize,
    required this.speed,
    required this.type,
    required this.damage,
  });

  final String imageSrc;
  final Size imageSize;
  final Size hitBoxSize;
  final double speed;
  final EnemyBulletType type;
  final int damage;
}
