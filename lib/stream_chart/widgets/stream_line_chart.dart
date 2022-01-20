import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/event_value.dart';

class StreamLineChart extends StatelessWidget {
  const StreamLineChart({
    Key? key,
    required this.eventValues,
    required this.timeRange,
    this.maxY,
    this.minY,
  }) : super(key: key);
  final List<EventValue> eventValues;
  final Duration timeRange;
  final double? maxY;
  final double? minY;

  final List<Color> _colors = const [Colors.red, Colors.blue, Colors.orange];

  List<LineChartBarData> _eventValuesToLineBarsData(List<EventValue> eventValues) {
    List<List<FlSpot>> spots = [];

    for (var _ in eventValues[0].values) {
      spots.add([]);
    }
    for (var event in eventValues) {
      for (int i = 0; i < event.values.length; i++) {
        spots[i].add(FlSpot(event.timeStamp.millisecondsSinceEpoch.toDouble(), event.values[i]));
      }
    }
    List<LineChartBarData> lineBarsData = [];
    spots.map((e) => LineChartBarData(spots: e, dotData: FlDotData(show: false))).toList();
    for (var i = 0; i < spots.length; i++) {
      lineBarsData.add(LineChartBarData(
        spots: spots[i],
        colors: i < _colors.length ? [_colors[i]] : null,
        dotData: FlDotData(show: false),
      ));
    }
    return lineBarsData;
  }

  @override
  Widget build(BuildContext context) {
    if (eventValues.isEmpty) return const Center(child: Text("Waiting for first event..."));

    double latestTimeStampInMilliSec = eventValues.last.timeStamp.millisecondsSinceEpoch.toDouble();
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
            bottomTitles: SideTitles(showTitles: false), topTitles: SideTitles(showTitles: false)),
        axisTitleData: FlAxisTitleData(bottomTitle: AxisTitle(showTitle: false)),
        lineBarsData: _eventValuesToLineBarsData(eventValues),
        maxX: latestTimeStampInMilliSec,
        minX: latestTimeStampInMilliSec - timeRange.inMilliseconds,
        maxY: maxY,
        minY: minY,
      ),
      swapAnimationDuration: const Duration(seconds: 0),
    );
  }
}
