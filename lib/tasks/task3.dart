import 'package:flutter/material.dart';
import '../stream_chart/chart_legend.dart';
import '../stream_chart/stream_chart.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Task3 extends StatelessWidget {
  const Task3({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamChart<AccelerometerEvent>(
                stream: accelerometerEvents,
                handler: (event) => [event.x, event.y, event.z],
                timeRange: const Duration(seconds: 15),
                minValue: -10.0,
                maxValue: 10.0,
              ),
            ),
          ),
          const ChartLegend(label: "Accel"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamChart<GyroscopeEvent>(
                stream: gyroscopeEvents,
                handler: (event) => [event.x, event.y, event.z],
                timeRange: const Duration(seconds: 15),
                minValue: -10.0,
                maxValue: 10.0,
              ),
            ),
          ),
          const ChartLegend(label: "Gyro"),
        ],
      ),
    );
  }
}
