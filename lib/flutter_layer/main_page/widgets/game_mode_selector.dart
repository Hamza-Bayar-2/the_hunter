import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_hunter/blocs/mini_game/mini_game_bloc.dart';

class GameModeSelector extends StatelessWidget {
  final int gameMode;

  const GameModeSelector({
    super.key,
    required this.gameMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'game mode',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () {
            context.read<MiniGameBloc>().add(ChangeGameMode());
          },
          child: Text(
            gameMode == 0 ? "finite" : "kill",
            style: const TextStyle(
              color: Colors.orange,
            ),
          ),
        ),
      ],
    );
  }
}
