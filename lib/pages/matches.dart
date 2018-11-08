import 'package:flutter/material.dart';
import '../widgets/timer.dart';

class MatchesPage extends StatefulWidget {
    MatchesPage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    MatchState createState() => new MatchState(); 
}

class MatchState extends State<MatchesPage> {

  MatchTimer matchTimer;

  MatchState() {
    matchTimer = new MatchTimer(match: this);
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new TimerText(matchTimer : matchTimer),
        centerTitle: true,
        bottom: new PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: new Container(),
        ),
      ),
      body: new Center(
        child: new TimerPlayPause(matchTimer: matchTimer)
      ),
    );
  }

  // MATCH API

  bool isMatchRunning() {
    return matchTimer.isRunning;
  }

  Duration getMatchTime() {
    return matchTimer.elapsed;
  }

  String getMatchTimeString() {
    return matchTimer.getTimeString();
  }

  void startTimer() {
    matchTimer.start();
  }



}