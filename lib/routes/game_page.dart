import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shooting_game/builder/player_spec_builder.dart';
import 'package:flutter_shooting_game/components/player.dart';
import 'package:flutter_shooting_game/components/player_status.dart';
import 'package:flutter_shooting_game/components/stage.dart';
import 'package:flutter_shooting_game/input/button.dart';
import 'package:flutter_shooting_game/shooting_game.dart';

class GamePage extends Component with HasGameRef<ShootingGame> {
  // controller
  late final JoystickComponent _joystick;
  late final SpriteButton _attackButton;

  // components
  late final Player _player;
  late final PlayerStatus _playerStatus;
  late final Stage _stage;

  @override
  Future<void> onLoad() async {
    await addGameController();
    await addPlayer();
    await addPlayerStatus();
    await addStage();
    add(ScreenHitbox());
  }

  Future<void> addGameController() async {
    final controllerPaint = Paint()..color = Colors.white.withOpacity(0.5);
    final controllerImage = await Flame.images.load('game_controller.png');
    final controllerSheet = SpriteSheet.fromColumnsAndRows(
      image: controllerImage,
      columns: 6,
      rows: 1,
    );

    addAll([
      _joystick = JoystickComponent(
        knob: SpriteComponent(
          sprite: controllerSheet.getSpriteById(1),
          paint: controllerPaint,
          size: Vector2.all(50),
        ),
        background: SpriteComponent(
          sprite: controllerSheet.getSpriteById(0),
          paint: controllerPaint,
          size: Vector2.all(100),
        ),
        anchor: Anchor.bottomLeft,
        position: Vector2(40, gameRef.size.y - 40),
      ),
      _attackButton = SpriteButton(
        button: controllerSheet.getSpriteById(2),
        buttonDown: controllerSheet.getSpriteById(4),
        paint: controllerPaint,
        size: Vector2.all(100),
        anchor: Anchor.bottomRight,
        position: Vector2(gameRef.size.x - 20, gameRef.size.y - 20),
        onTapStart: () {
          _player.startAttack();
        },
        onTapEnd: () {
          _player.stopAttack();
        },
      ),
    ]);
  }

  Future<void> addPlayer() async {
    add(
      _player = Player(
        joystick: _joystick,
        spec: PlayerSpecBuilder.normalPlayer,
        position: Vector2(100, gameRef.size.y / 2),
      ),
    );
  }

  Future<void> addPlayerStatus() async {
    add(
      _playerStatus = PlayerStatus(
        player: _player,
        anchor: Anchor.topLeft,
        position: Vector2(10, 10),
      ),
    );
  }

  Future<void> addStage() async {
    add(
      _stage = Stage(player: _player),
    );
  }
}
