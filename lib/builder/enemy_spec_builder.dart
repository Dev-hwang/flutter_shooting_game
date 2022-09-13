import 'dart:ui';

import 'package:flutter_shooting_game/builder/enemy_bullet_spec_builder.dart';
import 'package:flutter_shooting_game/models/enemy_spec.dart';

class EnemySpecBuilder {
  static EnemySpec normalGhost(int stage) => EnemySpec(
        imageSrc: 'enemy/normal_ghost.png',
        size: const Size(48, 48),
        speed: 30,
        score: 10 * stage,
        maxHealth: 10 + stage ~/ 2,
        isBoss: false,
        bulletSpec: EnemyBulletSpecBuilder.normal(stage),
        fireDelay: 2,
      );

  static EnemySpec kingGhost(int stage) => EnemySpec(
        imageSrc: 'enemy/king_ghost.png',
        size: const Size(96, 96),
        speed: 30,
        score: 100 * stage,
        maxHealth: 100 + stage ~/ 2,
        isBoss: true,
        bulletSpec: EnemyBulletSpecBuilder.normal(stage),
        fireDelay: 1,
      );
}
