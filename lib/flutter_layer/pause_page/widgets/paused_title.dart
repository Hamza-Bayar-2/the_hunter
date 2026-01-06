import 'package:flutter/material.dart';

class PausedTitle extends StatelessWidget {
  const PausedTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Game Paused',
      style: TextStyle(
        fontSize: 32.0,
        color: Colors.orange,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
