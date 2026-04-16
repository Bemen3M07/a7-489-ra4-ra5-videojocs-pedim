import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'ember_quest.dart';
import 'overlays/game_over.dart';
import 'overlays/main_menu.dart';
import 'overlays/pause_menu.dart';
import 'overlays/level_selector.dart';
import 'overlays/settings.dart';

void main() {
  runApp(
    GameWidget<EmberQuestGame>.controlled(
      gameFactory: EmberQuestGame.new,
      overlayBuilderMap: {
        'MainMenu': (_, game) => MainMenu(game: game),
        'GameOver': (_, game) => GameOver(game: game),
        'PauseMenu': (_, game) => PauseMenu(game: game),
        'LevelSelector': (_, game) => LevelSelector(game: game),
        'Settings': (_, game) => Settings(game: game),
      },
      initialActiveOverlays: const ['MainMenu'],
    ),
  );
}
