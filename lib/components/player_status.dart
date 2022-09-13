import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shooting_game/components/player.dart';

const Size _kHealthBarSize = Size(200, 8);
const Size _kEnergyBarSize = Size(200, 8);

class PlayerStatus extends PositionComponent {
  PlayerStatus({
    required this.player,
    super.position,
    super.anchor,
  });

  final Player player;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _drawHealthBar(canvas);
    _drawEnergyBar(canvas);
  }

  void _drawHealthBar(Canvas canvas) {
    final healthRect = Rect.fromLTWH(
      0,
      0,
      (_kHealthBarSize.width / player.spec.maxHealth) * player.spec.health,
      _kHealthBarSize.height,
    );
    final healthPaint = Paint()..color = Colors.green;
    canvas.drawRect(healthRect, healthPaint);

    final linePath = Path()
      ..moveTo(0, 0)
      ..lineTo(_kHealthBarSize.width, 0)
      ..lineTo(_kHealthBarSize.width, _kHealthBarSize.height)
      ..lineTo(0, _kHealthBarSize.height)
      ..close();
    final linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(linePath, linePaint);
  }

  void _drawEnergyBar(Canvas canvas) {
    final energyRect = Rect.fromLTWH(
      0,
      _kHealthBarSize.height,
      (_kEnergyBarSize.width / player.spec.maxEnergy) * player.spec.energy,
      _kEnergyBarSize.height,
    );
    final healthPaint = Paint()..color = Colors.blue;
    canvas.drawRect(energyRect, healthPaint);

    final linePath = Path()
      ..moveTo(0, _kHealthBarSize.height + 5)
      ..lineTo(_kEnergyBarSize.width, _kHealthBarSize.height + 5)
      ..lineTo(_kEnergyBarSize.width,
          _kHealthBarSize.height + _kEnergyBarSize.height + 5)
      ..lineTo(0, _kHealthBarSize.height + _kEnergyBarSize.height + 5)
      ..close();
    final linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(linePath, linePaint);
  }
}
