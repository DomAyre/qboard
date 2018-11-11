import 'package:flutter/material.dart';
import '../pages/matches.dart';
import '../data/match.dart';
import '../widgets/timer.dart';
import '../data/team.dart';
import '../widgets/manager.dart';

class ScoreKeeper extends Manager {

  final MatchState match;
  Match matchData;

  ScoreKeeper(this.match, team1, team2) {
    matchData = new Match(team1: team1, team2: team2);
  }

  void score(Duration time, Team team) {
    new Goal(time, team);
    invalidate();
    print(match.toJson());
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

class ScoreButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return new AnimatedContainer (
      duration : new Duration(milliseconds: 500),
      child : new GestureDetector (
        onTap : () => scoreKeeper.score(matchTimer.elapsed, team),
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