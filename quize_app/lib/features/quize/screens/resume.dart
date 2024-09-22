import 'package:flutter/material.dart';
import 'package:quize_app/features/quize/screens/index.dart';

class QuizeResume extends StatelessWidget {
  const QuizeResume({super.key, required this.numberOfAnsweredQuestions, required this.results});

  final int numberOfAnsweredQuestions;
  final List results;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You answered $numberOfAnsweredQuestions out of ${results.length} questions correctly!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: results
                      .asMap()
                      .entries
                      .map(
                        (answer) => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 22.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align top to make long text readable
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: (answer.value["is_right"] ?? false) ? Colors.green : Colors.red,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(9999),
                                  ),
                                ),
                                child: Text(
                                  '${answer.key + 1}',
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Wrap the long text in a Flexible or Expanded widget
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      answer.value["question"],
                                      softWrap: true, // Allow wrapping to new lines
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "you answer is : ${answer.value["users_answer"]}",
                                      softWrap: true, // Allow wrapping to new lines
                                      style: TextStyle(
                                        color: (answer.value["is_right"] ?? false) ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "the right answer is : ${answer.value["right_answer"]}",
                                      softWrap: true, // Allow wrapping to new lines
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.deepPurpleAccent),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.replay_outlined),
                    SizedBox(width: 15),
                    Text("Restart quiz!")
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QuizeHome()));
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
