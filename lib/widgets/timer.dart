import 'dart:async';
import 'package:flutter/material.dart';


class TimerText extends StatefulWidget {
    TimerText({this.stopwatch});

    final Stopwatch stopwatch;  

    @override
    TimerTextState createState() => new TimerTextState(stopwatch : stopwatch); 
}

class TimerTextState extends State<TimerText> {

  Timer timer;
  final Stopwatch stopwatch;

  TimerTextState({this.stopwatch}) {
    timer = new Timer.periodic(new Duration(milliseconds : 100), (Timer timer) => setState(() => {}));
    stopwatch.start();
  }

  String formatTime(int number) {
    return number >= 10 ? "$number" : "0$number"; 
  }

  String getTimeString() {
    return "${this.formatTime(this.stopwatch.elapsed.inMinutes)}:${this.formatTime(this.stopwatch.elapsed.inSeconds.round().remainder(60))}";
  }

  void broomsDown() {

    stopwatch.stop();

    // Show the brooms up button
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Play Stopped'),
      duration: Duration(days: 1),
      action: new SnackBarAction(
        label: 'Resume',
        onPressed: broomsUp,
      ),
    ));
  }

  void broomsUp() {
    stopwatch.start();
  }

  @override
  Widget build(BuildContext context) { 
    return new GestureDetector(
      onTap: this.broomsDown,
      child: new Text(this.getTimeString())
    );
  }
}