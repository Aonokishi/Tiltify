import 'package:flutter/material.dart';
import '../stream_chart/stream_chart.dart';
import '../utility/number_stream.dart';

class Task2Altn extends StatelessWidget {
  const Task2Altn({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamChart<double>(
          stream: NumberStream.getSinusStream,
          handler: (d) => [d],
          timeRange: const Duration(seconds: 15),
          minValue: -2,
          maxValue: 2,
        ),
      ),
    );
  }
}
