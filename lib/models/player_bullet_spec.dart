import 'dart:ui';

enum PlayerBulletType {
  normal,
}

class PlayerBulletSpec {
  const PlayerBulletSpec({
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
  final PlayerBulletType type;
  final int damage;
}
