import 'package:flutter/material.dart';
import '../pages/matches.dart';
import '../data/match.dart';
import '../widgets/timer.dart';
import '../data/team.dart';
import '../widgets/manager.dart';
import '../common.dart';

class ScoreKeeper extends Manager {

  final MatchState match;
  Match matchData;

  ScoreKeeper(this.match, team1, team2) {
    matchData = new Match(team1: team1, team2: team2);
  }

  void score(Duration time, Team team) {
    new Goal(time, team);
    invalidate();
  }

  List<Map<String, dynamic>> getGoals() => matchData.getGoals();

  String getScoreString() => "${matchData.team1Score()}0 - ${matchData.team2Score()}0";
}

class ScoreText extends StatefulWidget {

  final ScoreKeeper scoreKeeper;
  ScoreText({this.scoreKeeper});

  @override
  ScoreTextState createState() => ScoreTextState(scoreKeeper: scoreKeeper);
}

class ScoreTextState extends State<ScoreText> {

  final ScoreKeeper scoreKeeper;
  ScoreTextState({this.scoreKeeper}) {
    scoreKeeper.register(this);
  }

  @override
  Widget build(BuildContext context) {
    return new Text(
      scoreKeeper.getScoreString(),
      style: TextStyle(
        color: Colors.white,
        fontSize: 40.0,
      ));
  }
}

class ScoreButton extends StatefulWidget {
  const ScoreButton({
    Key key,
    @required this.scoreKeeper,
    @required this.matchTimer,
    @required this.team,
  }) : super(key: key);

  final ScoreKeeper scoreKeeper;
  final MatchTimer matchTimer;
  final Team team;

  @override
  ScoreButtonState createState() => ScoreButtonState(scoreKeeper: scoreKeeper, matchTimer: matchTimer, team: team);
}

class ScoreButtonState extends State<ScoreButton> {

  final ScoreKeeper scoreKeeper;
  final MatchTimer matchTimer;
  final Team team;  

  SimpleDialog scoreDialog(context) => SimpleDialog (
    contentPadding: EdgeInsets.all(24),
    title: new Text("${team.name} Goal"),              
    children: <Widget>[
      Text("SCORER", style: headerStyle),
      Text("ASSIST", style: headerStyle),
    ]
  );

  ScoreButtonState({this.scoreKeeper, this.matchTimer, this.team});

  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer (
      duration : new Duration(milliseconds: 500),
      child : new GestureDetector (
        onTap : () => showDialog(
          context: context,
          builder: (BuildContext context) => scoreDialog(context) 
        ),
        child: new Card (
          color : team.background,
          shape : CircleBorder(),
          child : new Container (
            width : 100,
            height : 100,
            child : new Padding(
              padding : EdgeInsets.all(15),
              child: new Image.asset(team.logoPath)
            )
          )
        )
      )
    );
  }
}
