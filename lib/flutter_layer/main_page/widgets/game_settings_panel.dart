import 'package:flutter/material.dart';
import 'package:the_hunter/flutter_layer/main_page/widgets/difficulty_selector.dart';
import 'package:the_hunter/flutter_layer/main_page/widgets/game_mode_selector.dart';
import 'package:the_hunter/flutter_layer/main_page/widgets/start_game_prompt.dart';

class GameSettingsPanel extends StatelessWidget {
  final int difficultyLevel;
  final int gameMode;

  const GameSettingsPanel({
    super.key,
    required this.difficultyLevel,
    required this.gameMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          width: 380,
          decoration: BoxDecoration(
            color: const Color.fromARGB(162, 0, 0, 0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DifficultySelector(difficultyLevel: difficultyLevel),
              const SizedBox(height: 20),
              GameModeSelector(gameMode: gameMode),
            ],
          ),
        ),
        const StartGamePrompt(),
      ],
    );
  }
}
