import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/features/home/widgets/index/cards/index.dart';
import 'package:expense_tracker/features/home/widgets/index/categorie_tiles/index.dart';
import 'package:expense_tracker/features/home/widgets/index/chart/index.dart';
import 'package:expense_tracker/features/home/widgets/index/filter/index.dart';
import 'package:expense_tracker/shared/components/drop_downs/classes/drop_down_item.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final List<String> homeTabs = const [
    "Expenses",
    "Income"
  ];

  final months = const [
    DropDownItem(label: "january"),
    DropDownItem(label: "february"),
    DropDownItem(label: "march"),
    DropDownItem(label: "april"),
    DropDownItem(label: "may"),
    DropDownItem(label: "june"),
    DropDownItem(label: "july"),
    DropDownItem(label: "august"),
    DropDownItem(label: "september"),
    DropDownItem(label: "october"),
    DropDownItem(label: "november"),
    DropDownItem(label: "december"),
  ];

  late AnimationController _animationController;

  bool isRefreshing = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0,
      upperBound: 60,
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: (details) {
        setState(() {
          isRefreshing = true;
        });
      },
      onVerticalDragUpdate: (details) {
        _animationController.value += details.delta.dy;
      },
      onVerticalDragEnd: (details) async {
        if (_animationController.value == 60.0) {
          final appState = Provider.of<ApplicationState>(context, listen: false);
          await appState.refreshHome();
          setState(() {
            isRefreshing = false;
          });
          _animationController.animateTo(0);
        } else {
          _animationController.animateTo(0);
          setState(() {
            isRefreshing = false;
          });
        }
      },
      child: Stack(
        children: [
          if (isRefreshing)
            SizedBox(
              height: 60,
              child: Center(
                child: LoadingAnimationWidget.stretchedDots(
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
            ),
          AnimatedBuilder(
            animation: _animationController,
            child: Column(
              children: [
                Filter(
                  tabs: homeTabs,
                  months: months,
                ),
                const Chart(),
                const Cards(),
                const CategoryTiles(),
              ],
            ),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animationController.value),
                child: child,
              );
            },
          ),
        ],
      ),
    );
  }
}
