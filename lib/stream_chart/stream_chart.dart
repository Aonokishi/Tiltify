import 'dart:async';

import 'package:flutter/material.dart';

import './models/event_value.dart';
import 'widgets/stream_line_chart.dart';

class StreamChart<T> extends StatefulWidget {
  const StreamChart({
    Key? key,
    required this.stream,
    required this.handler,
    required this.timeRange,
    this.minValue,
    this.maxValue,
  }) : super(key: key);

  final Stream<T> stream;
  final List<double> Function(T) handler;
  final Duration timeRange;
  final double? minValue;
  final double? maxValue;

  @override
  _StreamChartState<T> createState() => _StreamChartState<T>();
}

class _StreamChartState<T> extends State<StreamChart<T>> {
  late StreamSubscription<List<double>> _subscription;
  final List<EventValue> _data = [];
  @override
  void initState() {
    super.initState();
    Stream<List<double>> mappedStream = widget.stream.map(widget.handler);
    _subscription = mappedStream.listen((event) {
      DateTime now = DateTime.now();
      //check if old data can be removed
      _data.removeWhere((element) => element.timeStamp.isBefore(now.subtract(widget.timeRange)));
      setState(() {
        _data.add(EventValue(event, DateTime.now()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamLineChart(
      eventValues: _data,
      timeRange: widget.timeRange,
      maxY: widget.maxValue,
      minY: widget.minValue,
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
