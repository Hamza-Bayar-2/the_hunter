import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_hunter/blocs/mini_game/mini_game_bloc.dart';
import 'package:the_hunter/flutter_layer/main_page/widgets/game_settings_panel.dart';
import 'package:the_hunter/flutter_layer/main_page/widgets/game_title.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MiniGameBloc, MiniGameState>(
      builder: (context, state) {
        return Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const GameTitle(),
                GameSettingsPanel(
                  difficultyLevel: state.difficultyLevel,
                  gameMode: state.gameMode,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
