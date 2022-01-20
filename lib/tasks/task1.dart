import 'package:flutter/material.dart';
import '../utility/number_stream.dart';

class Task1 extends StatelessWidget {
  const Task1({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: StreamBuilder<int>(
          initialData: 0,
          stream: NumberStream.getCounterStream,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Text("Counter: ${snapshot.data}")
                : const Text("No Counter Value");
          },
        ),
      ),
    );
  }
}
