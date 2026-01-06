import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:the_hunter/flutter_layer/pause_page/widgets/exit_button.dart';
import 'package:the_hunter/flutter_layer/pause_page/widgets/pause_difficulty_selector.dart';
import 'package:the_hunter/flutter_layer/pause_page/widgets/paused_title.dart';
import 'package:the_hunter/flutter_layer/pause_page/widgets/resume_game_prompt.dart';

class PauseMenuCard extends StatelessWidget {
  final int difficultyLevel;

  const PauseMenuCard({
    super.key,
    required this.difficultyLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          width: 440,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: const Color.fromARGB(162, 0, 0, 0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PausedTitle(),
              const SizedBox(height: 20),
              PauseDifficultySelector(difficultyLevel: difficultyLevel),
              const SizedBox(height: 10),
              const ResumeGamePrompt(),
              const SizedBox(height: 10),
              const ExitButton(),
            ],
          ),
        ),
      ),
    );
  }
}
