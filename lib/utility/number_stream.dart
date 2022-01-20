import 'dart:math';

class NumberStream {
  //Use private Constructor for Utility class
  NumberStream._();

  //Use async* for generator method
  static Stream<int> _counterStream() async* {
    int i = 1;
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield i++;
    }
  }

  static Stream<int> get getCounterStream => _counterStream();

  static Stream<double> _radianStream() async* {
    int resolution = 100;
    int i = 0;
    double piFrac = 2 * pi / resolution;
    while (true) {
      double radian = piFrac * i;
      i < resolution - 1 ? i++ : i = 0;
      await Future.delayed(const Duration(milliseconds: 100));
      yield radian;
    }
  }

  static Stream<double> get getSinusStream => _radianStream().map((event) => sin(event));
  static Stream<double> get getCosinusStream => _radianStream().map((event) => cos(event));
}
