import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

enum ButtonState {
  up,
  down,
}

class SpriteButton extends SpriteGroupComponent<ButtonState> with TapCallbacks {
  SpriteButton({
    required this.button,
    this.buttonDown,
    this.onPressed,
    this.onTapStart,
    this.onTapEnd,
    super.position,
    Vector2? size,
    super.paint,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
  }) : super(
          current: ButtonState.up,
          size: size ?? button.originalSize,
        );

  final Sprite button;
  Sprite? buttonDown;
  VoidCallback? onPressed;
  VoidCallback? onTapStart;
  VoidCallback? onTapEnd;

  @override
  void onMount() {
    sprites = {
      ButtonState.up: button,
      ButtonState.down: buttonDown ?? button,
    };
    super.onMount();
  }

  @override
  void onTapDown(TapDownEvent event) {
    current = ButtonState.down;
    onTapStart?.call();
  }

  @override
  void onTapUp(TapUpEvent event) {
    current = ButtonState.up;
    onPressed?.call();
    onTapEnd?.call();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    current = ButtonState.up;
    onTapEnd?.call();
  }
}
