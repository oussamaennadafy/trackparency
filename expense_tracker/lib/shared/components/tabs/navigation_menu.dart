import 'package:expense_tracker/features/analytics/screens/index.dart';
import 'package:expense_tracker/features/home/index.dart';
import 'package:expense_tracker/features/profile/profile.dart';
import 'package:expense_tracker/features/transactions/transactions.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int selectedIndex = 0;

  final screens = const [
    Home(),
    Transactions(),
    Analytics(),
    Profile(),
  ];

  void handlePress(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        animationDuration: Duration.zero,
        selectedIndex: selectedIndex,
        backgroundColor: AppColors.surface,
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        destinations: [
          IconButton(
            highlightColor: AppColors.surface,
            onPressed: () => handlePress(0),
            icon: Center(
              child: SvgPicture.asset(
                selectedIndex == 0 ? AppIcons.homeFill : AppIcons.home,
              ),
            ),
          ),
          IconButton(
            highlightColor: AppColors.surface,
            onPressed: () => handlePress(1),
            icon: Center(
              child: SvgPicture.asset(
                selectedIndex == 1 ? AppIcons.gridFill : AppIcons.grid,
              ),
            ),
          ),
          IconButton(
            highlightColor: AppColors.surface,
            onPressed: () => handlePress(2),
            icon: Center(
              child: SvgPicture.asset(
                selectedIndex == 2 ? AppIcons.analyticsFill : AppIcons.analytics,
              ),
            ),
          ),
          IconButton(
            highlightColor: AppColors.surface,
            onPressed: () => handlePress(3),
            icon: Center(
              child: SvgPicture.asset(
                selectedIndex == 3 ? AppIcons.userFill : AppIcons.user,
              ),
            ),
          ),
        ],
      ),
      body: screens[selectedIndex],
    );
  }
}
