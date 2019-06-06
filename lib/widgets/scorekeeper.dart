import 'package:flutter/material.dart';
import 'package:qboard/data/fouls.dart';
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

  void giveCard({@required Duration time, @required Player fouler, @required Foul foul, @required CardType cardType}) {
    FoulEvent foulEvent = FoulEvent(
      time: time,
      fouler: fouler,
      foul: foul,
      cardType: cardType, 
    );

    // if (fouler != null) fouler
    matchData.addEvent(foulEvent);
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
      duration : longAnimation,
      child : GestureDetector (
        onTap : () => showDialog(
          context: context,
          builder: (BuildContext context) => ScoreDialog(team: team, scoreKeeper: scoreKeeper, scoreTime: matchTimer.elapsed)
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

class ScoreDialog extends StatefulWidget {
  
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
  _ScoreDialogState createState() => _ScoreDialogState();
}

class _ScoreDialogState extends State<ScoreDialog> {

  Player scorer;
  Player assist;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog (
      contentPadding: EdgeInsets.all(24),
      title: Text("${widget.team.name} Goal"),              
      children: <Widget>[
        Text("SCORER", style: headerStyle),
        PlayerSelector(players: widget.team.players, value: scorer, onChanged: (dynamic newPlayer) {
          setState(() {scorer = newPlayer;});
        }),
        Text("ASSIST", style: headerStyle),
        PlayerSelector(players: widget.team.players, value: assist, onChanged: (dynamic newPlayer) {
          setState(() {assist = newPlayer;});
        }),
        FlatButton(
          child: Text("SCORE"),
          onPressed: () {
            widget.scoreKeeper.score(time: widget.scoreTime, team: widget.team, 
              scorer: scorer,
              assist: assist,
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
    return BludgerControlSliderState(scoreKeeper: scoreKeeper, matchTimer: matchTimer);
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
        child: Slider(value: sliderValue, min: 0, max: 2, divisions: 2,
          onChanged: (newState) => setState(() {sliderValue = newState;}),
          onChangeEnd: (newState) => scoreKeeper.setBludgerControlState(time: matchTimer.elapsed, newState: ControlState.values[newState.toInt()]),
        ),
      ),
    );
  }
}
