import 'package:flutter/material.dart';

class GameTitle extends StatelessWidget {
  const GameTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text.rich(TextSpan(
            style: TextStyle(
              fontSize: 100,
              color: Colors.orange,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(-10.0, 10.0),
                  blurRadius: 9.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
            ),
            children: <TextSpan>[
              TextSpan(text: 'the\n', style: TextStyle(fontSize: 72)),
              TextSpan(
                text: 'hunter',
              )
            ])),
      ],
    );
  }
}
