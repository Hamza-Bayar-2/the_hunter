import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_hunter/blocs/mini_game/mini_game_bloc.dart';

class PauseButton extends StatelessWidget {
  const PauseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          alignment: AlignmentDirectional.topStart,
          onPressed: () {
            context.read<MiniGameBloc>().add(GoToPausePage());
          },
          icon: const Icon(Icons.pause),
          color: Colors.white,
          iconSize: 30,
        ),
      ],
    );
  }
}
