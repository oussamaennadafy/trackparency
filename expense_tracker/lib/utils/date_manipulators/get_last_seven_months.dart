import 'package:expense_tracker/features/home/classes/period_boundries.dart';

PeriodBoundries getLastSevenMonths() {
  final now = DateTime.now();
  final startOfPeriod = DateTime(now.year, now.month - 6, 1);
  final endOfPeriod = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  return PeriodBoundries(
    startOfPeriod: startOfPeriod,
    endOfPeriod: endOfPeriod,
  );
}
