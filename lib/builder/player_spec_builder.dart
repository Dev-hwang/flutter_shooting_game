import 'dart:ui';

import 'package:flutter_shooting_game/builder/player_bullet_spec_builder.dart';
import 'package:flutter_shooting_game/models/player_spec.dart';

class PlayerSpecBuilder {
  static PlayerSpec get normalPlayer => PlayerSpec(
        imageSrc: 'player/player.png',
        size: const Size(36, 48),
        maxSpeed: 300,
        maxHealth: 10,
        maxEnergy: 100,
        bulletSpec: PlayerBulletSpecBuilder.normal,
      );
}
