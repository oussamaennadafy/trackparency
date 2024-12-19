// ignore_for_file: file_names

class TopCategory {
  TopCategory({
    required this.icon,
    required this.name,
    required this.total,
    this.color,
    this.percentage,
  });

  String icon;
  String name;
  int total;
  String? color;
  double? percentage;
}
