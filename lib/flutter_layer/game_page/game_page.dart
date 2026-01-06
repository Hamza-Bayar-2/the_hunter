import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_hunter/blocs/mini_game/mini_game_bloc.dart';
import 'package:the_hunter/flutter_layer/game_page/widgets/finite_game_stats.dart';
import 'package:the_hunter/flutter_layer/game_page/widgets/kill_game_stats.dart';
import 'package:the_hunter/flutter_layer/game_page/widgets/pause_button.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MiniGameBloc, MiniGameState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PauseButton(),
              state.gameMode == 0
                  ? FiniteGameStats(
                      archerHealth: state.archerHealth,
                      monsterKillNumber: state.monsterKillNumber,
                      gameStage: state.gameStage,
                    )
                  : KillGameStats(
                      archerHealth: state.archerHealth,
                      monsterKillNumber: state.monsterKillNumber,
                    )
            ],
          ),
        );
      },
    );
  }
}
