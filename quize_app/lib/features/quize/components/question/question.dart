import 'package:flutter/material.dart';
import 'package:quize_app/shared/components/buttons/main_button.dart';

class Question extends StatelessWidget {
  const Question({required this.question, required this.choices, required this.onAnswerPress, super.key});

  final String question;
  final List<String> choices;
  final void Function(int id) onAnswerPress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    question,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ...choices.asMap().entries.map(
                        (answer) => MainButton(
                          label: answer.value,
                          onPressed: () {
                            onAnswerPress(answer.key);
                          },
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
