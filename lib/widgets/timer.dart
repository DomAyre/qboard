import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qboard/common.dart';
import '../pages/matches.dart';

class MatchTimer extends Stopwatch {

  final MatchState match;
  final List<Duration> events;
  final Function onNewEvent;
  MatchTimer({this.match, this.events, this.onNewEvent});

  static String _formatTime(int number) => number >= 10 ? "$number" : "0$number";

  static String getTimeString(Duration time) => 
    "${MatchTimer._formatTime(time.inMinutes)}:${MatchTimer._formatTime(time.inSeconds.round().remainder(60))}";
}

class TimerText extends StatefulWidget {

  final MatchTimer matchTimer;  
  TimerText({this.matchTimer});

  @override
  TimerTextState createState() => TimerTextState(matchTimer : matchTimer); 
}

class TimerTextState extends State<TimerText> {

  final MatchTimer matchTimer;
  final refreshFrequency = Duration(milliseconds : 100);

  String timeText = "00:00";

  TimerTextState({this.matchTimer}) {
    Timer.periodic(refreshFrequency, updateTime);
  }

  void updateTime(Timer timer) {
    setState(() {
      timeText = MatchTimer.getTimeString(matchTimer.elapsed);
    });

    List<Duration> passedEvents = matchTimer.events.where((Duration event) => matchTimer.elapsed > event).toList();
    for (Duration passedEvent in passedEvents) {
      matchTimer.events.remove(passedEvent);
      matchTimer.onNewEvent();
    }
  }

  @override
  Widget build(BuildContext context) { 
    return Text(timeText);
  }
}

class TimerPlayPause extends StatefulWidget {

  final MatchTimer matchTimer;
  TimerPlayPause({this.matchTimer});

  @override
  TimerPlayPauseState createState() => TimerPlayPauseState(matchTimer: matchTimer); 
}

class TimerPlayPauseState extends State<TimerPlayPause> with TickerProviderStateMixin {

  MatchTimer matchTimer;
  bool isTimerRunning = false; 
  AnimationController animation;
  Tween<double> playPauseTween = Tween<double>(begin: 0, end: 1);

  TimerPlayPauseState({this.matchTimer}) {
    animation = AnimationController(
      duration: mediumAnimation,
      vsync: this,
    );
  }

  void buttonPressed() {

    if (isTimerRunning) {
      matchTimer.stop();
      animation.animateBack(0);
    }
    else {
      matchTimer.start();
      animation.animateTo(1);
    }

    setState(() { isTimerRunning = !isTimerRunning; });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(icon: AnimatedIcons.play_pause, progress: playPauseTween.animate(animation)),
      onPressed: buttonPressed,
    );
  }

}