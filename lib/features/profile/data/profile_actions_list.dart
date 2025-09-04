import 'package:expense_tracker/features/profile/widgets/actionsTileList.dart/index.dart';
import 'package:expense_tracker/shared/components/tiles/action_tile/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final profileActionsList = [
  ListData(
    sectionTitle: "manage categories",
    actionsList: [
      ActionTile(
        text: "manage expenses categories",
        leftIcon: Icons.inventory_rounded,
        onPress: (context) {
          context.go("/onboarding/categories");
        },
      ),
    ],
  ),
  ListData(
    sectionTitle: "actions",
    actionsList: [
      ActionTile(
        text: "logout",
        leftIcon: Icons.logout,
        isDanger: true,
        onPress: (context) {
          FirebaseAuth.instance.signOut();
        },
      ),
    ],
  ),
];
