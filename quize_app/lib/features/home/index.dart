import 'package:flutter/material.dart';
import 'package:quize_app/features/quize/screens/index.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "welcome to the app",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 300),
            OutlinedButton(
              child: const Text(
                "take a short quize",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const QuizeHome(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
