import 'package:flutter/material.dart';
import '../pages/matches.dart';
import '../data/match.dart';
import '../widgets/timer.dart';
import '../data/team.dart';
import '../data/player.dart';
import '../widgets/manager.dart';
import '../common.dart';

class ScoreKeeper extends Manager {

  final MatchState match;
  Match matchData;

  ScoreKeeper(this.match, team1, team2) {
    matchData = Match(team1: team1, team2: team2);
  }

  void score(Duration time, Team team, [Player scorer, Player assist]) {
    Goal goal = Goal(time, team);
    if (scorer != null) scorer.goals.add(goal);
    if (assist != null) assist.assists.add(goal);
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
    return Text(
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

  ScoreButtonState({this.scoreKeeper, this.matchTimer, this.team});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer (
      duration : Duration(milliseconds: 500),
      child : GestureDetector (
        onTap : () => showDialog(
          context: context,
          builder: (BuildContext context) => new ScoreDialog(team: team, scoreKeeper: scoreKeeper, matchTimer: matchTimer)
        ),
        child: Card (
          color : team.background,
          shape : CircleBorder(),
          child : Container (
            width : 100,
            height : 100,
            child : Padding(
              padding : EdgeInsets.all(15),
              child: Image.asset(team.logoPath)
            )
          )
        )
      )
    );
  }
}

class ScoreDialog extends StatelessWidget {
  const ScoreDialog({
    Key key,
    @required this.team,
    @required this.scoreKeeper,
    @required this.matchTimer,
  }) : super(key: key);

  final Team team;
  final ScoreKeeper scoreKeeper;
  final MatchTimer matchTimer;

  @override
  Widget build(BuildContext context) {

    GlobalKey scorerKey = new GlobalKey();
    GlobalKey assistKey = new GlobalKey();

    return new SimpleDialog (
      contentPadding: EdgeInsets.all(24),
      title: new Text("${team.name} Goal"),              
      children: <Widget>[
        new Text("SCORER", style: headerStyle),
        new PlayerSelector(key: scorerKey, players: team.players),
        new Text("ASSIST", style: headerStyle),
        new PlayerSelector(key: assistKey, players: team.players),
        new FlatButton(
          child: new Text("SCORE"),
          onPressed: () {
            scoreKeeper.score(matchTimer.elapsed, team, 
              (scorerKey.currentState as PlayerSelectorState).getSelected(),
              (assistKey.currentState as PlayerSelectorState).getSelected(),
            );
            return Navigator.pop(context);
          }
        )
      ]
    );
  }
}
