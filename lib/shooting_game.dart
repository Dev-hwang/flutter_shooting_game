import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter_shooting_game/routes/game_page.dart';
import 'package:flutter_shooting_game/routes/home_page.dart';

class ShootingGame extends FlameGame
    with HasTappableComponents, HasDraggables, HasCollisionDetection {
  late final RouterComponent router;

  @override
  Future<void> onLoad() async {
    add(
      router = RouterComponent(
        routes: {
          'home': Route(HomePage.new),
          'game': Route(GamePage.new),
        },
        initialRoute: 'home',
      ),
    );
  }
}
