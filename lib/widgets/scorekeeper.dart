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

  void score({@required Duration time, @required Team team, Player scorer, Player assist}) {
    Goal goal = Goal(time: time, team: team, scorer: scorer, assist: assist);
    if (scorer != null) scorer.goals.add(goal);
    if (assist != null) assist.assists.add(goal);
    matchData.addEvent(goal);
    invalidate();
  }

  List<Map<String, dynamic>> getGoals() => matchData.getGoals();

  ControlState getBludgerControlState() => this.matchData.getBludgerControlState();

  void setBludgerControlState({@required Duration time, @required ControlState newState}) {
    ControlState currentState = getBludgerControlState();
    if (currentState != newState) {
      ControlChange controlChangeEvent = ControlChange(matchData: matchData, time: time, previousState: currentState, newState: newState);
      matchData.addEvent(controlChangeEvent);
      invalidate();
    }
  }

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
        fontSize: 32.0,
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
          builder: (BuildContext context) => new ScoreDialog(team: team, scoreKeeper: scoreKeeper, scoreTime: matchTimer.elapsed)
        ),
        child: Card (
          color : team.background,
          shape : CircleBorder(),
          child : Container (
            width : 130,
            height : 130,
            child : Padding(
              padding : EdgeInsets.all(20),
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
    @required this.scoreTime,
  }) : super(key: key);

  final Team team;
  final ScoreKeeper scoreKeeper;
  final Duration scoreTime;

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
            scoreKeeper.score(time: scoreTime, team: team, 
              scorer: (scorerKey.currentState as PlayerSelectorState).getSelected(),
              assist: (assistKey.currentState as PlayerSelectorState).getSelected(),
            );
            return Navigator.pop(context);
          }
        )
      ]
    );
  }
}

class BludgerControlSlider extends StatefulWidget {

  const BludgerControlSlider({
    Key key,
    @required this.scoreKeeper,
    @required this.matchTimer,
  }) : super(key: key);
  
  final ScoreKeeper scoreKeeper;
  final MatchTimer matchTimer;

  @override
  BludgerControlSliderState createState() {
    return new BludgerControlSliderState(scoreKeeper: scoreKeeper, matchTimer: matchTimer);
  }
}

class BludgerControlSliderState extends State<BludgerControlSlider> {

  final ScoreKeeper scoreKeeper;
  final MatchTimer matchTimer;
  double sliderValue = 1.0;

  BludgerControlSliderState({@required this.scoreKeeper, @required this.matchTimer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 8,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
          tickMarkShape: SliderTickMarkShape.noTickMark,
          thumbColor: Colors.red[900]
        ),
        child: new Slider(value: sliderValue, min: 0, max: 2, divisions: 2,
          onChanged: (newState) => setState(() {sliderValue = newState;}),
          onChangeEnd: (newState) => scoreKeeper.setBludgerControlState(time: matchTimer.elapsed, newState: ControlState.values[newState.toInt()]),
        ),
      ),
    );
  }
}
