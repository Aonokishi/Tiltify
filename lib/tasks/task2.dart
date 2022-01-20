import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

import '../utility/number_stream.dart';

class Task2 extends StatefulWidget {
  const Task2({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Task2> createState() => _Task2State();
}

class _Task2State extends State<Task2> {
  late StreamSubscription<FlSpot> _subscription;

  final List<FlSpot> _flSpots = [];

  @override
  void initState() {
    super.initState();
    _subscription = NumberStream.getSinusStream
        .map((event) => FlSpot(DateTime.now().millisecondsSinceEpoch.toDouble(), event))
        .listen((event) {
      setState(() {
        _flSpots.add(event);
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: _flSpots,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
