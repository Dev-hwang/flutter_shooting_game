import 'dart:ui';

import 'package:flutter_shooting_game/models/enemy_bullet_spec.dart';

class EnemyBulletSpecBuilder {
  static EnemyBulletSpec normal(int stage) => EnemyBulletSpec(
        imageSrc: 'bullet/enemy_bullet.png',
        imageSize: const Size(48, 48),
        hitBoxSize: const Size(18, 18),
        speed: 120,
        type: EnemyBulletType.normal,
        damage: 1 + stage ~/ 2,
      );
}
