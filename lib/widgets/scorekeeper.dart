import 'package:flutter/material.dart';
import '../pages/matches.dart';
import '../data/match.dart';

class ScoreKeeper {

  final MatchState match;
  Match matchData;

  ScoreKeeper(this.match, team1, team2) {
    matchData = new Match(team1: team1, team2: team2);
  }

  String getScoreString() {
    return "${matchData.team1Score()} - ${matchData.team2Score()}";
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
  ScoreTextState({this.scoreKeeper});

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