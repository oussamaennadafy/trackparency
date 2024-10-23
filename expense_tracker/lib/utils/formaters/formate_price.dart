import 'package:intl/intl.dart';

String formatBalance(int balance) {
  final formatter = NumberFormat("#,##0", "fr_FR");
  return "${formatter.format(balance)} DH";
}
