import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_hunter/blocs/mini_game/mini_game_bloc.dart';

class GoToMenuButton extends StatelessWidget {
  const GoToMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<MiniGameBloc>().add(GoToMainPage());
        context.read<MiniGameBloc>().add(ResetHealthEvent());
      },
      child: const Text(
        "Go to menu",
      ),
    );
  }
}
