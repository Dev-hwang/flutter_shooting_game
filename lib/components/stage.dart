import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_shooting_game/builder/enemy_spec_builder.dart';
import 'package:flutter_shooting_game/components/enemy.dart';
import 'package:flutter_shooting_game/components/player.dart';
import 'package:flutter_shooting_game/models/stage_data.dart';
import 'package:flutter_shooting_game/shooting_game.dart';

class Stage extends Component with HasGameRef<ShootingGame> {
  Stage({required this.player});

  final Player player;

  final _random = Random();

  int _stage = 0;
  late StageData _stageData;
  EnemySpawnData? _currEnemySpawnData;
  EnemySpawnData? _nextEnemySpawnData;

  int _spawnIndex = 0;
  int _spawnCount = 0;
  double _spawnDelay = 0;

  @override
  Future<void> onLoad() async => _stageUp();

  @override
  void update(double dt) {
    // 보스전
    if (_currEnemySpawnData == null) return;

    _spawnDelay += dt;
    if (_spawnCount == 0 ||
        (_spawnDelay >= (_nextEnemySpawnData?.spawnDelay ?? 0) &&
            _spawnCount < 2)) {
      _spawnEnemy();
    }
  }

  void _stageUp() {
    _stage++;
    if (_stage > stageData.length) {
      // TODO: 전투 결과 페이지 추가 필요
      // gameRef.router.pushNamed('game_result');
      return;
    }

    _stageData = stageData[_stage - 1];
    _currEnemySpawnData = _stageData.enemySpawnDataList[0];
    _nextEnemySpawnData = null;

    _spawnIndex = 0;
    _spawnDelay = 0;
  }

  void _onEnemyRemoved(Enemy enemy) {
    player.spec.gainScore(enemy.spec.score);

    _spawnCount--;
    if (enemy.spec.isBoss) {
      // 한 스테이지에 보스는 한마리!
      _stageUp();
    }
  }

  void _spawnEnemy() {
    final spawnEnemies = <Enemy>[];
    if (_spawnIndex >= _stageData.enemySpawnDataList.length) {
      // 보스몹
      final bossEnemy = Enemy(
        spec: _stageData.bossSpec,
        playerTransformGetter: () => player.transform,
        onRemoved: _onEnemyRemoved,
      );
      bossEnemy.position = Vector2(
        gameRef.size.x + bossEnemy.size.x,
        gameRef.size.y / 2,
      )..clamp(bossEnemy.size / 2, gameRef.size - bossEnemy.size / 2);
      spawnEnemies.add(bossEnemy);
      _currEnemySpawnData = null;
      _nextEnemySpawnData = null;
    } else {
      // 일반몹
      final currEnemySpawnData = _stageData.enemySpawnDataList[_spawnIndex];
      for (final enemySpec in currEnemySpawnData.enemySpecList) {
        final normalEnemy = Enemy(
          spec: enemySpec,
          playerTransformGetter: () => player.transform,
          onRemoved: _onEnemyRemoved,
        );
        normalEnemy.position = Vector2(
          gameRef.size.x + enemySpec.size.width,
          _random.nextDouble() * gameRef.size.y,
        )..clamp(normalEnemy.size / 2, gameRef.size - normalEnemy.size / 2);
        spawnEnemies.add(normalEnemy);
      }
      _currEnemySpawnData = currEnemySpawnData;
      if (_spawnIndex == _stageData.enemySpawnDataList.length - 1) {
        _nextEnemySpawnData = null;
      } else {
        _nextEnemySpawnData = _stageData.enemySpawnDataList[_spawnIndex + 1];
      }
    }

    gameRef.addAll(spawnEnemies);

    _spawnIndex++;
    _spawnCount += spawnEnemies.length;
    _spawnDelay = 0;
  }

  static List<StageData> stageData = [
    // Stage 1
    StageData(
      bossSpec: EnemySpecBuilder.kingGhost(1),
      enemySpawnDataList: [
        EnemySpawnData(
          enemySpecList: [
            EnemySpecBuilder.normalGhost(1),
            EnemySpecBuilder.normalGhost(1),
          ],
          spawnDelay: 0,
        ),
        EnemySpawnData(
          enemySpecList: [
            EnemySpecBuilder.normalGhost(1),
            EnemySpecBuilder.normalGhost(1),
          ],
          spawnDelay: 10,
        ),
        EnemySpawnData(
          enemySpecList: [
            EnemySpecBuilder.normalGhost(1),
            EnemySpecBuilder.normalGhost(1),
            EnemySpecBuilder.normalGhost(1),
          ],
          spawnDelay: 10,
        ),
        EnemySpawnData(
          enemySpecList: [
            EnemySpecBuilder.normalGhost(1),
            EnemySpecBuilder.normalGhost(1),
            EnemySpecBuilder.normalGhost(1),
          ],
          spawnDelay: 10,
        ),
      ],
    ),
  ];
}
