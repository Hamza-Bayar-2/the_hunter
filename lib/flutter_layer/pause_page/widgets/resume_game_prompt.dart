import 'package:flutter/material.dart';

class ResumeGamePrompt extends StatelessWidget {
  const ResumeGamePrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
          style: TextStyle(fontSize: 42),
          children: <TextSpan>[
            TextSpan(text: "press"),
            TextSpan(
                text: " space ",
                style: TextStyle(
                  color: Colors.orange,
                )),
            TextSpan(text: "to start"),
          ]),
    );
  }
}
