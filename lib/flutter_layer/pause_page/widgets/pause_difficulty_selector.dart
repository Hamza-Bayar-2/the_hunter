import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_hunter/blocs/mini_game/mini_game_bloc.dart';

class PauseDifficultySelector extends StatelessWidget {
  final int difficultyLevel;

  const PauseDifficultySelector({
    super.key,
    required this.difficultyLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'difficulty',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () {
            context.read<MiniGameBloc>().add(ChangeDifficultyLevelEvent());
          },
          child: Text(
            _difficultyText(difficultyLevel),
            style: const TextStyle(
              color: Colors.orange,
            ),
          ),
        ),
      ],
    );
  }

  String _difficultyText(int difficultyLevel) {
    switch (difficultyLevel) {
      case 1:
        return "easy";
      case 2:
        return "normal";
      case 3:
        return "hard";
      default:
        return "easy";
    }
  }
}
