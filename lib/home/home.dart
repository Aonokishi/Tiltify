import 'package:flutter/material.dart';

import '../tasks/start.dart';
import '../tasks/task1.dart';
import '../tasks/task2.dart';
import '../tasks/task2_altn.dart';
import '../tasks/task3.dart';
import '../tasks/task4.dart';

import './widgets/task_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final Map<String, Widget> _screens = const {
    "Start": Start(title: "Start"),
    "Aufgabe 1": Task1(title: "Aufgabe 1"),
    "Aufgabe 2": Task2(title: "Aufgabe 2"),
    "Aufgabe 2 Altern.": Task2Altn(title: "Aufgabe 2 Alternative"),
    "Aufgabe 3": Task3(title: "Aufgabe 3"),
    "Aufagbe 4": Task4(title: "eSense Demo"),
  };

  List<Widget> _buildButtons() {
    return _screens.entries.map((e) => TaskButton(name: e.key, page: e.value)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Workshop"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blueGrey.shade200],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildButtons(),
          ),
        ),
      ),
    );
  }
}
