import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_hunter/blocs/mini_game/mini_game_bloc.dart';
import 'package:the_hunter/flutter_layer/game_page.dart';
import 'package:the_hunter/flutter_layer/main_page.dart';
import 'package:the_hunter/flutter_layer/pause_page.dart';
import 'package:the_hunter/flutter_layer/win_lose_page.dart';

class PageManager extends StatelessWidget {
  const PageManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MiniGameBloc, MiniGameState>(
      builder: (context, state) {
        return _pageManager(state);
      },
    );
  }

  Widget _pageManager(MiniGameState state) {
    if (state.flutterPage == 0) {
      return const MainPage();
    } else if (state.flutterPage == 1) {
      return const GamePage();
    } else if (state.flutterPage == 2) {
      return const PausePage();
    } else if (state.flutterPage == 3) {
      return const WinLosePage();
    } else {
      return const MainPage();
    }
  }

  // 0 => main page
  // 1 => game page
  // 2 => pause page
  // 3 => win or lose page
}
