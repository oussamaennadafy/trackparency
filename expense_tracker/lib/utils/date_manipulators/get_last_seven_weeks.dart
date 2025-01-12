import 'package:expense_tracker/features/home/classes/period_boundries.dart';

PeriodBoundries getLastSevenWeeks() {
  final now = DateTime.now();
  final padEnd = 7 - now.weekday;
  final endOfPeriod = DateTime(now.year, now.month, now.day + padEnd, 23, 59, 59);
  final daysToSubstract = 48;
  final startOfPeriod = DateTime(endOfPeriod.year, endOfPeriod.month, endOfPeriod.day - daysToSubstract);

  return PeriodBoundries(
    startOfPeriod: startOfPeriod,
    endOfPeriod: endOfPeriod,
  );
}
