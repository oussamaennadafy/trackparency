import 'package:expense_tracker/shared/components/drop_downs/classes/drop_down_item.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/icons.dart';

const incomeCategories = [
  DropDownItem(
    label: "Salary",
    backgroundColor: AppColors.green,
    icon: AppIcons.handUnderCash,
  ),
  DropDownItem(
    label: "side hustle",
    backgroundColor: AppColors.green,
    icon: AppIcons.dollar,
  ),
];

const paymentMethods = [
  DropDownItem(
    label: "Cash",
    backgroundColor: AppColors.blue,
    icon: AppIcons.cash,
  ),
  DropDownItem(
    label: "Card",
    backgroundColor: AppColors.lavenderGray,
    icon: AppIcons.creditCard,
  ),
];
