import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:the_hunter/flutter_layer/win_lose_page/widgets/go_to_menu_button.dart';

class GameOverCard extends StatelessWidget {
  const GameOverCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
              color: const Color.fromARGB(162, 0, 0, 0),
              borderRadius: BorderRadius.circular(10)),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Game Over',
                style: TextStyle(
                  fontSize: 32.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              GoToMenuButton()
            ],
          ),
        ),
      ),
    );
  }
}
