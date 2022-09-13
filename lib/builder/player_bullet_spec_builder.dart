import 'dart:ui';

import 'package:flutter_shooting_game/models/player_bullet_spec.dart';

class PlayerBulletSpecBuilder {
  static PlayerBulletSpec get normal => const PlayerBulletSpec(
        imageSrc: 'bullet/player_bullet.png',
        imageSize: Size(48, 48),
        hitBoxSize: Size(18, 18),
        speed: 700,
        type: PlayerBulletType.normal,
        damage: 1,
      );
}
