import 'dart:async';
import 'package:flutter/material.dart';
import '../pages/matches.dart';

class MatchTimer extends Stopwatch {

  final MatchState match;
  MatchTimer({this.match});

  String _formatTime(int number) {
    return number >= 10 ? "$number" : "0$number"; 
  }

  String getTimeString() {
    return "${this._formatTime(this.elapsed.inMinutes)}:${this._formatTime(this.elapsed.inSeconds.round().remainder(60))}";
  }
}

class TimerText extends StatefulWidget {

  final MatchTimer matchTimer;  
  TimerText({this.matchTimer});

  @override
  TimerTextState createState() => new TimerTextState(matchTimer : matchTimer); 
}

class TimerTextState extends State<TimerText> {

  final MatchTimer matchTimer;
  final refreshFrequency = new Duration(milliseconds : 100);

  String timeText;

  TimerTextState({this.matchTimer}) {
    new Timer.periodic(refreshFrequency, updateTime);
  }

  void updateTime(Timer timer) {
    setState(() {
      timeText = matchTimer.getTimeString();
    });
  }

  @override
  Widget build(BuildContext context) { 
    return new Text(timeText);
  }
}

class TimerPlayPause extends StatefulWidget {

  final MatchTimer matchTimer;
  const TimerPlayPause({this.matchTimer});

  @override
  TimerPlayPauseState createState() => new TimerPlayPauseState(matchTimer: matchTimer); 
}

class TimerPlayPauseState extends State<TimerPlayPause> {

  MatchTimer matchTimer;
  bool isTimerRunning = false; 

  TimerPlayPauseState({this.matchTimer});

  void buttonPressed() {

    if (isTimerRunning) matchTimer.stop();
    else matchTimer.start();

    setState(() { isTimerRunning = !isTimerRunning; });
  }

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: Icon(isTimerRunning ? Icons.pause : Icons.play_arrow),
      onPressed: buttonPressed,
    );
  }

}