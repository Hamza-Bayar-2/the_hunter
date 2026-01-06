import 'package:flutter/material.dart';

class FiniteGameStats extends StatelessWidget {
  final int archerHealth;
  final int monsterKillNumber;
  final int gameStage;

  const FiniteGameStats({
    super.key,
    required this.archerHealth,
    required this.monsterKillNumber,
    required this.gameStage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
          color: const Color.fromARGB(162, 0, 0, 0),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("health: $archerHealth"),
          const SizedBox(height: 20),
          Text("kill: $monsterKillNumber / 40"),
          const SizedBox(height: 20),
          Text("stage: $gameStage / 4"),
        ],
      ),
    );
  }
}
