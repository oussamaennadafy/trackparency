import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileListHeader extends StatelessWidget {
  const ProfileListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.0),
        Container(
          height: 100,
          width: 100,
          decoration: const BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.all(
              Radius.circular(90.0),
            ),
          ),
          child: Image.asset(
            AppMemojis.smilingYouth,
          ),
        ),
        const SizedBox(height: 16.0),
        Text(
          // "Oussama ennadafy",
          FirebaseAuth.instance.currentUser!.displayName.toString(),
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          FirebaseAuth.instance.currentUser!.email.toString(),
          style: const TextStyle(
            fontSize: 12.0,
            color: AppColors.gray,
          ),
        ),
      ],
    );
  }
}
