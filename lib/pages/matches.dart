import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qboard/data/fouls.dart';
import 'package:qboard/data/rule_set.dart';
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
  RuleSet rules = RuleSet(snitchReleased: Duration(seconds: 2));

  Team team1;
  Team team2;

  GlobalKey fadeBackgroundKey = GlobalKey();
  GlobalKey cardCollectionKey = GlobalKey();

  MatchState() {
    matchTimer = MatchTimer(match: this, events: [rules.snitchReleased], onNewEvent: () {
      setState(() {});
    });
    team1 = Team("Mermaids", "assets/mermaids.png", Color(0xFF144452), Color(0xFF7CB3D1));
    team2 = Team("Archers", "assets/archers.png", Color(0xFF0C3D00), Color(0xFF7A7A7A));

    team1.addPlayer(Player(firstName: "Player", lastName: "One"));
    team2.addPlayer(Player(firstName: "Player", lastName: "Two"));
    team2.addPlayer(Player(firstName: "Player", lastName: "Three"));
    scoreKeeper = ScoreKeeper(match: this, team1: team1, team2: team2);
  }

  @override
  Widget build(BuildContext context) {

    AppBar appBar = AppBar(
      title: TimerText(matchTimer: matchTimer),
      centerTitle: true,
      backgroundColor: Color(0xFF1E2D5C),
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
              child: NotificationListener<ScrollNotification>(onNotification: (notification) {
                CardCollectionState collectionState = cardCollectionKey.currentState;
                  List<GlobalKey> cardKeys = [
                    collectionState.blueCardKey,
                    collectionState.yellowCardKey,
                    collectionState.redCardKey,
                  ];
                  for (GlobalKey cardKey in cardKeys) {
                    ClippedDialogState cardState = cardKey.currentState;
                    if (cardState != null) {
                      cardState.setState(() {
                        cardState.offset = notification.metrics.extentBefore;
                      });
                    }
                  }
                },
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
                    Offstage(
                      offstage: matchTimer.elapsed < rules.snitchReleased,
                      child: Column(
                        children: [
                          Text("SNITCH", style: headerStyle, textAlign: TextAlign.center),
                          SnitchCatchSlider(scoreKeeper: scoreKeeper, matchTimer: matchTimer)
                        ]
                      )
                    ),
                    EventStream(scoreKeeper: scoreKeeper),
                  ],
                ),
              ),
            ),
          ),
          FadeBackground(key: fadeBackgroundKey, 
            onTapped: () {
              ClippedDialogState current = (cardCollectionKey.currentState as CardCollectionState).selectedCard;
              if (current != null) {
                current.setState(() {
                  current.animation.animateBack(0, curve: Curves.fastOutSlowIn);
                  (current.widget.child as FoulCard).clearCard();
                });
                (cardCollectionKey.currentState as CardCollectionState).selectedCard = null;
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


