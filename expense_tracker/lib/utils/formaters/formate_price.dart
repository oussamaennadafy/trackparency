import 'package:intl/intl.dart';

String formatePrice(int balance) {
  final formatter = NumberFormat("#,##0", "fr_FR");
  return formatter.format(balance);
}
