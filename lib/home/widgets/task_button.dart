import 'package:flutter/material.dart';

class TaskButton extends StatelessWidget {
  const TaskButton({Key? key, required this.name, required this.page}) : super(key: key);

  final String name;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 180,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => page,
          ),
        ),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
        child: Text(name, style: const TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
