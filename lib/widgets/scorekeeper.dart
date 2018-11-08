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
  }

  String getScoreString() {
    return "${matchData.team1Score()}0 - ${matchData.team2Score()}0";
  }
}

class ScoreText extends StatefulWidget {

  final ScoreKeeper scoreKeeper;
  ScoreText({this.scoreKeeper});

  @override
  ScoreTextState createState() {
    return ScoreTextState(scoreKeeper: scoreKeeper);
  }
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
    return new RaisedButton (
      child: new Text(team.name),
      onPressed: () => scoreKeeper.score(matchTimer.elapsed, team),
    );
  }
}