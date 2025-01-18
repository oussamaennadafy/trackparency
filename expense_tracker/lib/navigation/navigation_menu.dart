import 'package:expense_tracker/features/home/screens/index.dart';
import 'package:expense_tracker/features/profile/screens/profile.dart';
import 'package:expense_tracker/features/transactions/screens/transactions.dart';
import 'package:expense_tracker/shared/components/headers/header/index.dart';
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
  int selectedIndex = 1;

  final screens = const [
    Transactions(),
    Home(),
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
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(63),
        child: Header(),
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
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
                selectedIndex == 0 ? AppIcons.menuListFill : AppIcons.menuList,
              ),
            ),
          ),
          IconButton(
            highlightColor: AppColors.surface,
            onPressed: () => handlePress(1),
            icon: Center(
              child: SvgPicture.asset(
                selectedIndex == 1 ? AppIcons.homeFill : AppIcons.home,
              ),
            ),
          ),
          IconButton(
            highlightColor: AppColors.surface,
            onPressed: () => handlePress(2),
            icon: Center(
              child: SvgPicture.asset(
                selectedIndex == 2 ? AppIcons.userFill : AppIcons.user,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
