import 'package:flutter/material.dart';

import '../ember_quest.dart';

/// Menú principal que es mostra en iniciar el joc.
class MainMenu extends StatelessWidget {
  final EmberQuestGame game;

  /// Rep la referència del joc per canviar overlays.
  const MainMenu({super.key, required this.game});

  @override

  /// Construeix el menú principal amb les opcions bàsiques.
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 350,
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
                'Ember Quest',
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
                  // Treu el menú i deixa visible el joc.
                  onPressed: () {
                    game.overlays.remove('MainMenu');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'Play',
                    style: TextStyle(
                      fontSize: 40.0,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  // Obre la pantalla de selecció de nivell.
                  onPressed: () {
                    game.overlays.remove('MainMenu');
                    game.overlays.add('LevelSelector');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'Select Level',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  // Obre la pantalla de configuració del joc.
                  onPressed: () {
                    game.overlays.remove('MainMenu');
                    game.overlays.add('Settings');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Aquest text explica els controls i l'objectiu bàsic.
              const Text(
                'Use WASD or Arrow Keys for movement.\nSpace bar to jump.\nCollect as many stars as you can and avoid enemies!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
