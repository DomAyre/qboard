import 'package:flutter/material.dart';
import '../widgets/timer.dart';
import '../widgets/scorekeeper.dart';
import '../data/team.dart';

class MatchesPage extends StatefulWidget {
    MatchesPage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    MatchState createState() => new MatchState(); 
}

class MatchState extends State<MatchesPage> {

  MatchTimer matchTimer;
  ScoreKeeper scoreKeeper;

  MatchState() {
    matchTimer = new MatchTimer(match: this);
    scoreKeeper = new ScoreKeeper(this, new Team(name: "TeamA"), new Team(name: "TeamB"));
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new TimerText(matchTimer : matchTimer),
        centerTitle: true,
        bottom: new PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: new Container(
            child: new Padding(
              padding: EdgeInsets.only(top: 40.0, bottom: 40.0,),
              child: ScoreText(scoreKeeper: scoreKeeper)),
          ),
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