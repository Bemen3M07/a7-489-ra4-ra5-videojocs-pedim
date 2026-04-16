import 'package:flutter/material.dart';

import '../ember_quest.dart';

class LevelSelector extends StatelessWidget {
  final EmberQuestGame game;

  const LevelSelector({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 300,
          width: 300,
          decoration: const BoxDecoration(
            color: blackTextColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Select Level',
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  game.overlays.remove('LevelSelector');
                },
                child: const Text('Level 1'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  game.overlays.remove('LevelSelector');
                },
                child: const Text('Level 2'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  game.overlays.remove('LevelSelector');
                  game.overlays.add('MainMenu');
                },
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}