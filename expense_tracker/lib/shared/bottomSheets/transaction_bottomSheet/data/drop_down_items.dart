import 'package:expense_tracker/shared/components/drop_downs/classes/drop_down_item.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/icons.dart';

const expenseCategories = [
  DropDownItem(
    label: "Shopping",
    backgroundColor: AppColors.green,
    icon: AppIcons.tShirt,
  ),
  DropDownItem(
    label: "Gifts",
    backgroundColor: AppColors.violet,
    icon: AppIcons.gift,
  ),
  DropDownItem(
    label: "Food",
    backgroundColor: AppColors.red,
    icon: AppIcons.pizza,
  ),
  DropDownItem(
    label: "transaport and ridings",
    backgroundColor: AppColors.red,
    icon: AppIcons.pizza,
  ),
  DropDownItem(
    label: "chi 9wada kanchriha ghir bo7di a zebi deplomatico",
    backgroundColor: AppColors.red,
    icon: AppIcons.pizza,
  ),
];

const incomeCategories = [
  DropDownItem(
    label: "Salary",
    backgroundColor: AppColors.green,
    icon: AppIcons.pizza,
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
