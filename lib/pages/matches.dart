import 'package:flutter/material.dart';
import '../widgets/timer.dart';
import '../widgets/scorekeeper.dart';
import '../data/team.dart';
import '../data/player.dart';
import '../data/event.dart';
import '../common.dart';

class MatchesPage extends StatefulWidget {
    MatchesPage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    MatchState createState() => new MatchState(); 
}

class MatchState extends State<MatchesPage> {

  MatchTimer matchTimer;
  ScoreKeeper scoreKeeper;

  Team team1;
  Team team2;

  MatchState() {
    matchTimer = new MatchTimer(match: this);
    team1 = new Team("TeamA", "assets/bristol_bears.png", Colors.black);
    team2 = new Team("TeamB", "assets/bristol_bees.png", Colors.black);

    team1.addPlayer(new Player(firstName: "Player", lastName: "One"));
    team2.addPlayer(new Player(firstName: "Player", lastName: "Two"));
    team2.addPlayer(new Player(firstName: "Player", lastName: "Three"));
    scoreKeeper = new ScoreKeeper(this, team1, team2);
  }

  @override
  Widget build(BuildContext context) {

    AppBar appBar = new AppBar(
      title: TimerText(matchTimer : matchTimer),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Padding (
          padding: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Card (
                color : team1.background,
                shape : CircleBorder(),
                child : Container (
                  width : 75,
                  height : 75,
                  child : Padding(
                    padding : EdgeInsets.all(10),
                    child: Image.asset(team1.logoPath)
                  )
                )
              ),
              ScoreText(scoreKeeper: scoreKeeper),
              Card (
                color : team2.background,
                shape : CircleBorder(),
                child : Container (
                  width : 75,
                  height : 75,
                  child : Padding(
                    padding : EdgeInsets.all(10),
                    child: Image.asset(team2.logoPath)
                  )
                )
              ),
            ],
          )
        ),
      ),
    );

    return new Scaffold(
      appBar: appBar,
      body: new ListView (
        reverse: true,
        children: [
          new Container(
            height: 250,
          ),
          new Row (
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new ScoreButton(scoreKeeper: scoreKeeper, matchTimer: matchTimer, team: scoreKeeper.matchData.team1),
              new TimerPlayPause(matchTimer: matchTimer),
              new ScoreButton(scoreKeeper: scoreKeeper, matchTimer: matchTimer, team: scoreKeeper.matchData.team2),
            ],
          ),
          new Text("GOALS", style: headerStyle, textAlign: TextAlign.center),
          new EventStream(scoreKeeper: scoreKeeper),
        ],
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

  String getMatchTimeString() => MatchTimer.getTimeString(matchTimer.elapsed);

  void startTimer() => matchTimer.start();
}
