import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppKeyboard extends StatelessWidget {
  const AppKeyboard({
    super.key,
    required this.handleItemPress,
  });

  final void Function(String caracter) handleItemPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.width - 12.0,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        handleItemPress("1");
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.onSurface,
                          borderRadius: BorderRadius.all(
                            Radius.circular(22.0),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "1",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        handleItemPress("4");
                      },
                      child: Container(
                        margin: const EdgeInsets.all(1.0),
                        decoration: const BoxDecoration(
                          color: AppColors.onSurface,
                          borderRadius: BorderRadius.all(
                            Radius.circular(22.0),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "4",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        handleItemPress("7");
                      },
                      child: Container(
                        margin: const EdgeInsets.all(1.0),
                        decoration: const BoxDecoration(
                          color: AppColors.onSurface,
                          borderRadius: BorderRadius.all(
                            Radius.circular(22.0),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "7",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        handleItemPress("+");
                      },
                      child: Container(
                        margin: const EdgeInsets.all(1.0),
                        decoration: const BoxDecoration(
                          color: AppColors.yellow,
                          borderRadius: BorderRadius.all(
                            Radius.circular(22.0),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "+",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        handleItemPress("2");
                      },
                      child: Container(
                        margin: const EdgeInsets.all(1.0),
                        decoration: const BoxDecoration(
                          color: AppColors.onSurface,
                          borderRadius: BorderRadius.all(
                            Radius.circular(22.0),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "2",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        handleItemPress("5");
                      },
                      child: Container(
                        margin: const EdgeInsets.all(1.0),
                        decoration: const BoxDecoration(
                          color: AppColors.onSurface,
                          borderRadius: BorderRadius.all(
                            Radius.circular(22.0),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "5",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        handleItemPress("8");
                      },
                      child: Container(
                        margin: const EdgeInsets.all(1.0),
                        decoration: const BoxDecoration(
                          color: AppColors.onSurface,
                          borderRadius: BorderRadius.all(
                            Radius.circular(22.0),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "8",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        handleItemPress("0");
                      },
                      child: Container(
                        margin: const EdgeInsets.all(1.0),
                        decoration: const BoxDecoration(
                          color: AppColors.onSurface,
                          borderRadius: BorderRadius.all(
                            Radius.circular(22.0),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "0",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        handleItemPress("3");
                      },
                      child: Container(
                        margin: const EdgeInsets.all(1.0),
                        decoration: const BoxDecoration(
                          color: AppColors.onSurface,
                          borderRadius: BorderRadius.all(
                            Radius.circular(22.0),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "3",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        handleItemPress("6");
                      },
                      child: Container(
                        margin: const EdgeInsets.all(1.0),
                        decoration: const BoxDecoration(
                          color: AppColors.onSurface,
                          borderRadius: BorderRadius.all(
                            Radius.circular(22.0),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "6",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        handleItemPress("9");
                      },
                      child: Container(
                        margin: const EdgeInsets.all(1.0),
                        decoration: const BoxDecoration(
                          color: AppColors.onSurface,
                          borderRadius: BorderRadius.all(
                            Radius.circular(22.0),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "9",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        handleItemPress("AC");
                      },
                      child: Container(
                        margin: const EdgeInsets.all(1.0),
                        decoration: const BoxDecoration(
                          color: AppColors.onSurface,
                          borderRadius: BorderRadius.all(
                            Radius.circular(22.0),
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.delete_forever),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        handleItemPress("clear");
                      },
                      child: Container(
                        margin: const EdgeInsets.all(1.0),
                        decoration: const BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.all(
                            Radius.circular(22.0),
                          ),
                        ),
                        child: Center(
                          child: Center(
                            child: SvgPicture.asset(
                              AppIcons.clear,
                              height: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        handleItemPress("calendar");
                      },
                      child: Container(
                        margin: const EdgeInsets.all(1.0),
                        decoration: const BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(22.0),
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(AppIcons.calendar),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        handleItemPress("check");
                      },
                      child: Container(
                        margin: const EdgeInsets.all(1.0),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.all(
                            Radius.circular(22.0),
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppIcons.checkMark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
