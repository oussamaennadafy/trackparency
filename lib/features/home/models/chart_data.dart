class BiggestDay {
  final String day;
  final int total;

  const BiggestDay({
    required this.day,
    required this.total,
  });
}

class ChartData {
  final List<MapEntry<String, int>> resultsMap;
  final BiggestDay biggestDay;

  const ChartData({
    required this.resultsMap,
    required this.biggestDay,
  });
}
