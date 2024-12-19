import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
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
            const SizedBox(height: 24.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: const Text(
                "profile",
                style: TextStyle(
                  color: AppColors.gray,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 14.0),
              padding: const EdgeInsets.symmetric(vertical: 6),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: AppColors.onSurface,
                border: Border.all(
                  color: AppColors.extraLightGray,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(24.0),
                ),
              ),
              child: Column(
                children: [
                  InkWell(
                    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                    onTap: () {
                      context.go("/onboarding/categories");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            ),
                            child: const Icon(Icons.inventory_rounded),
                          ),
                          const SizedBox(width: 12.0),
                          const Expanded(
                            child: Text("Manage categories"),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            size: 18.0,
                            color: AppColors.gray,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 1.0,
                  //   width: double.infinity,
                  //   color: AppColors.extraLightGray,
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //         padding: const EdgeInsets.all(4.0),
                  //         decoration: const BoxDecoration(
                  //           color: AppColors.surface,
                  //           borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  //         ),
                  //         child: const Icon(Icons.align_horizontal_left_sharp),
                  //       ),
                  //       const SizedBox(width: 12.0),
                  //       const Expanded(
                  //         child: Text("Manage categories"),
                  //       ),
                  //       const Icon(
                  //         Icons.arrow_forward,
                  //         size: 18.0,
                  //         color: AppColors.gray,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 14.0),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: const Text(
                    "actions",
                    style: TextStyle(
                      color: AppColors.gray,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                InkWell(
                  onTap: FirebaseAuth.instance.signOut,
                  overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 14.0),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18.0),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: AppColors.onSurface,
                      border: Border.all(
                        color: AppColors.extraLightGray,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(24.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 255, 240, 240),
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              ),
                              child: const Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            const Expanded(
                              child: Text(
                                "logout",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              size: 18.0,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
