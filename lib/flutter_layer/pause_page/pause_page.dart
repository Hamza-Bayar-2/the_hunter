import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_hunter/blocs/mini_game/mini_game_bloc.dart';
import 'package:the_hunter/flutter_layer/pause_page/widgets/pause_menu_card.dart';

class PausePage extends StatelessWidget {
  const PausePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MiniGameBloc, MiniGameState>(
      builder: (context, state) {
        return PauseMenuCard(difficultyLevel: state.difficultyLevel);
      },
    );
  }
}
