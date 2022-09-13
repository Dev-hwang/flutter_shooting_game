import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shooting_game/shooting_game.dart';

class HomePage extends Component with HasGameRef<ShootingGame>, TapCallbacks {
  HomePage() {
    _interval = Timer(
      1,
      onTick: () {
        _isShowingText = !_isShowingText;
      },
      repeat: true,
    );

    _textPaint = TextPaint(
      style: const TextStyle(fontSize: 21.0, color: Colors.white),
    );
  }

  late final Timer _interval;
  late final TextPaint _textPaint;
  late Vector2 _textPosition;
  bool _isShowingText = true;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _textPosition = Vector2(gameRef.size.x / 2, gameRef.size.y - 50);
  }

  @override
  void update(double dt) {
    _interval.update(dt);
  }

  @override
  void render(Canvas canvas) {
    if (_isShowingText) {
      _textPaint.render(
        canvas,
        'TOUCH TO START',
        _textPosition,
        anchor: Anchor.center,
      );
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.router.pushNamed('game');
  }
}
