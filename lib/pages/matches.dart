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
  MatchState createState() => MatchState();
}

class MatchState extends State<MatchesPage> {

  MatchTimer matchTimer;
  ScoreKeeper scoreKeeper;

  Team team1;
  Team team2;

  MatchState() {
    matchTimer = MatchTimer(match: this);
    team1 = Team("TeamA", "assets/bristol_bears.png", Colors.black, Colors.red);
    team2 = Team("TeamB", "assets/bristol_bees.png", Colors.black, Colors.yellow);

    team1.addPlayer(Player(firstName: "Player", lastName: "One"));
    team2.addPlayer(Player(firstName: "Player", lastName: "Two"));
    team2.addPlayer(Player(firstName: "Player", lastName: "Three"));
    scoreKeeper = ScoreKeeper(this, team1, team2);
  }

  @override
  Widget build(BuildContext context) {

    AppBar appBar = AppBar(
      title: TimerText(matchTimer: matchTimer),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Card(
                    color: team1.background,
                    shape: CircleBorder(),
                    child: Container(
                        width: 75,
                        height: 75,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Image.asset(team1.logoPath)))),
                ScoreText(scoreKeeper: scoreKeeper),
                Card(
                    color: team2.background,
                    shape: CircleBorder(),
                    child: Container(
                        width: 75,
                        height: 75,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Image.asset(team2.logoPath)))),
              ],
            )),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          ListView(
            reverse: true,
            children: [
              Container(
                height: 200,
              ),
              BludgerControlSlider(
                  scoreKeeper: scoreKeeper, matchTimer: matchTimer),
              Text("BLUDGER CONTROL",
                  style: headerStyle, textAlign: TextAlign.center),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ScoreButton(
                      scoreKeeper: scoreKeeper,
                      matchTimer: matchTimer,
                      team: scoreKeeper.matchData.team1),
                  TimerPlayPause(matchTimer: matchTimer),
                  ScoreButton(
                      scoreKeeper: scoreKeeper,
                      matchTimer: matchTimer,
                      team: scoreKeeper.matchData.team2),
                ],
              ),
              Text("GOALS", style: headerStyle, textAlign: TextAlign.center),
              EventStream(scoreKeeper: scoreKeeper),
            ],
          ),
          Positioned(              
            bottom: 80,
            left: 20,
            child: Card(
              color: Colors.red,
              child: Text("This is a card"), 
            ),
          )
        ]
      ),
    );
  }

  // MATCH API

  Map<String, dynamic> toJson() => {
        "duration": matchTimer.elapsed,
        "teams": {
          "0": scoreKeeper.matchData.team1,
          "1": scoreKeeper.matchData.team2,
        },
        "goals": scoreKeeper.getGoals(),
        "cards": [],
        "catches": [],
      };

  bool isMatchRunning() => matchTimer.isRunning;

  Duration getMatchTime() => matchTimer.elapsed;

  String getMatchTimeString() => MatchTimer.getTimeString(matchTimer.elapsed);

  void startTimer() => matchTimer.start();
}
