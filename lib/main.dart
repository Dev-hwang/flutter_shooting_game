import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shooting_game/shooting_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.setLandscape();
  await Flame.device.fullScreen();

  runApp(const GameWidget.controlled(gameFactory: ShootingGame.new));
}
