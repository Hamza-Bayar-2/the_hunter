import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_hunter/blocs/mini_game/mini_game_bloc.dart';
import 'package:the_hunter/flutter_layer/win_lose_page/widgets/game_over_card.dart';
import 'package:the_hunter/flutter_layer/win_lose_page/widgets/you_win_card.dart';

class WinLosePage extends StatelessWidget {
  const WinLosePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MiniGameBloc, MiniGameState>(
      builder: (context, state) {
        return state.isArcherDead ? const GameOverCard() : const YouWinCard();
      },
    );
  }
}
