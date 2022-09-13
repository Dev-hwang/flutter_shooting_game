import 'package:flutter_shooting_game/models/enemy_spec.dart';

class StageData {
  StageData({
    required this.bossSpec,
    required this.enemySpawnDataList,
  });

  final EnemySpec bossSpec;
  final List<EnemySpawnData> enemySpawnDataList;
}

class EnemySpawnData {
  EnemySpawnData({
    required this.enemySpecList,
    required this.spawnDelay,
  });

  final List<EnemySpec> enemySpecList;
  final int spawnDelay;
}
