import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qboard/data/fouls.dart';
import 'package:qboard/widgets/card_collection.dart';
import 'package:qboard/widgets/clipped_dialog.dart';
import 'package:qboard/widgets/fade_background.dart';
import 'package:qboard/widgets/foul_card.dart';
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

Map<CardType, Color> cardTypeColor = {
  CardType.Blue: Colors.blue,
  CardType.Yellow: Colors.yellow,
  CardType.Red: Colors.red
};

class MatchState extends State<MatchesPage> {

  MatchTimer matchTimer;
  ScoreKeeper scoreKeeper;

  Team team1;
  Team team2;

  GlobalKey fadeBackgroundKey = GlobalKey();
  GlobalKey cardCollectionKey = GlobalKey();

  MatchState() {
    matchTimer = MatchTimer(match: this);
    team1 = Team("Bristol QC", "assets/bristol_bears.png", Colors.black, Colors.red);
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
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 700),
              child: ListView(
                reverse: true,
                children: [
                  Container(height: 80),
                  Text("CARDS", style: headerStyle, textAlign: TextAlign.center),
                  BludgerControlSlider(scoreKeeper: scoreKeeper, matchTimer: matchTimer),
                  Text("BLUDGER CONTROL", style: headerStyle, textAlign: TextAlign.center),
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
            ),
          ),
          FadeBackground(key: fadeBackgroundKey, 
            onTapped: () {
              ClippedDialogState current = (cardCollectionKey.currentWidget as CardCollection).selectedCard;
              if (current != null) {
                current.setState(() {
                  current.widget.isShown = false;
                  (current.widget.child as FoulCard).clearCard();
                });
              }
            }
          ),
          CardCollection(key: cardCollectionKey, fadeBackground: fadeBackgroundKey, matchState: this)
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


