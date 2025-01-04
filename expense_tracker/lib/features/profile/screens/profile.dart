import 'package:expense_tracker/features/profile/data/profile_actions_list.dart';
import 'package:expense_tracker/features/profile/widgets/actionsTileList.dart/index.dart';
import 'package:expense_tracker/features/profile/widgets/profileListHeader/index.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileListHeader(),
            const SizedBox(height: 24.0),
            ActionsTileList(
              listData: profileActionsList,
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
