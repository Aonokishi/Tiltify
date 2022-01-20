import 'package:flutter/material.dart';

class ChartLegend extends StatelessWidget {
  final String label;
  const ChartLegend({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(label),
          const DimensionDescription(label: "x", color: Colors.red),
          const DimensionDescription(label: "y", color: Colors.blue),
          const DimensionDescription(label: "z", color: Colors.orange),
        ],
      ),
    );
  }
}

class DimensionDescription extends StatelessWidget {
  final String label;
  final Color color;
  const DimensionDescription({required this.label, required this.color, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(label),
      const SizedBox(width: 5),
      Container(
        color: color,
        height: 20,
        width: 50,
      )
    ]);
  }
}
