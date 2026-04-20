import 'package:flutter/material.dart';

import '../ember_quest.dart';

/// Menú que apareix quan la partida està en pausa.
class PauseMenu extends StatelessWidget {
  final EmberQuestGame game;

  /// Rep el joc per poder reprendre l'execució.
  const PauseMenu({super.key, required this.game});

  @override

  /// Construeix la finestra de pausa amb el botó de reprendre.
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 200,
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
                'Paused',
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 75,
                child: ElevatedButton(
                  // Tanca la pausa i reactiva el motor del joc.
                  onPressed: () {
                    game.overlays.remove('PauseMenu');
                    game.resumeEngine();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'Resume',
                    style: TextStyle(
                      fontSize: 40.0,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
