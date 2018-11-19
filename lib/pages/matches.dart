import 'package:flutter/material.dart';
import '../widgets/timer.dart';
import '../widgets/scorekeeper.dart';
import '../data/team.dart';
import '../data/player.dart';

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
    Team team1 = new Team("TeamA", "assets/bristol_bears.png", Colors.black);
    Team team2 = new Team("TeamB", "assets/bristol_bees.png", Colors.black);

    team1.addPlayer(new Player(firstName: "Team", lastName: "One"));
    team2.addPlayer(new Player(firstName: "Team", lastName: "Two"));
    team2.addPlayer(new Player(firstName: "Team", lastName: "Three"));
    scoreKeeper = new ScoreKeeper(this, team1, team2);
  }

  @override
  Widget build(BuildContext context) {

    AppBar appBar = new AppBar(
      title: new TimerText(matchTimer : matchTimer),
      centerTitle: true,
      bottom: new PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: new Container(
          child: new Padding(
            padding: EdgeInsets.only(bottom: 40.0,),
            child: ScoreText(scoreKeeper: scoreKeeper)),
        ),
      ),
    );

    return new Scaffold(
      appBar: appBar,
      body: new Center(
        child: new Row (
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new ScoreButton(scoreKeeper: scoreKeeper, matchTimer: matchTimer, team: scoreKeeper.matchData.team1),
            new TimerPlayPause(matchTimer: matchTimer),
            new ScoreButton(scoreKeeper: scoreKeeper, matchTimer: matchTimer, team: scoreKeeper.matchData.team2),
          ],
        ),
      ),
    );
  }

  // MATCH API

  Map<String, dynamic> toJson() => {
    "duration": matchTimer.elapsed,
    "teams" : {
      "0" : scoreKeeper.matchData.team1,
      "1" : scoreKeeper.matchData.team2,
    },
    "goals" : scoreKeeper.getGoals(),
    "cards" : [],
    "catches" : [],
  };

  bool isMatchRunning() => matchTimer.isRunning;

  Duration getMatchTime() => matchTimer.elapsed;

  String getMatchTimeString() => matchTimer.getTimeString();

  void startTimer() => matchTimer.start();
}
