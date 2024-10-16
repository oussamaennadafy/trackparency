import 'package:intl/intl.dart';

String formateDate(DateTime date) {
  final DateFormat formatter = DateFormat('yyy-MM-dd HH-mm');
  return formatter.format(date);
}
