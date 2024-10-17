import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// firebase auth
// new
import 'package:go_router/go_router.dart'; // new
import 'package:provider/provider.dart'; // new
import 'package:expense_tracker/app_state.dart'; // new

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<ApplicationState>(
          builder: (context, appState, _) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  !appState.loggedIn ? context.push('/sign-in') : FirebaseAuth.instance.signOut();
                },
                child: appState.loggedIn ? const Text("sign out") : const Text("sign in"),
              ),
              const SizedBox(width: 12),
              Visibility(
                visible: appState.loggedIn,
                child: OutlinedButton(
                    onPressed: () {
                      context.push('/profile');
                    },
                    child: const Text('Profile')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
