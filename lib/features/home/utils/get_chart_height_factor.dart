double getChartHeightFactor(int value, int maxValue) {
  if (maxValue == 0) maxValue = 1;
  final factor = value / maxValue;
  return factor;
}
