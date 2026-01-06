import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_hunter/blocs/mini_game/mini_game_bloc.dart';

class ExitButton extends StatelessWidget {
  const ExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          context.read<MiniGameBloc>().add(ResetAllGameEvent());
        },
        icon: const Icon(
          Icons.exit_to_app_outlined,
          color: Colors.red,
          size: 35,
        ));
  }
}
