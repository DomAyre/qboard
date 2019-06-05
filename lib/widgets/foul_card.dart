import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qboard/data/fouls.dart';
import 'package:qboard/data/player.dart';
import 'package:qboard/data/team.dart';
import 'package:qboard/pages/matches.dart';
import 'package:qboard/widgets/fade_background.dart';

import '../common.dart';

class FoulCard extends StatefulWidget {

  CardType cardType;
  List<Team> teams;
  MatchState parent;
  bool isShown;

  FoulCard({
    Key key, 
    @required this.cardType, 
    @required this.teams, 
    @required this.parent
  });

  @override
  _FoulCardState createState() => _FoulCardState(
    cardHeader: this.cardType.toString().split(".").last + " Card",
    teams: this.teams,
    possibleFouls: getFoulsForCardType(this.cardType),
    parent: parent,
    card: this
  );
}

class _FoulCardState extends State<FoulCard> {

  String cardHeader;
  List<Team> teams;
  Team selectedTeam;
  List<Player> players;
  Player selectedPlayer;
  List<Foul> possibleFouls;
  Foul selectedFoul;
  MatchState parent;
  FoulCard card;
  bool hasFoul = false;
  bool hasFouler = false;
  GlobalKey fouler = GlobalKey();
  GlobalKey foul = GlobalKey();

  submitFunction() {
      parent.scoreKeeper.giveCard(
        time: parent.matchTimer.elapsed,
        fouler: selectedPlayer,
        foul: selectedFoul,
        cardType: card.cardType
      );
      parent.setState(() {(parent.fadeBackgroundKey.currentState as FadeBackgroundState).isFaded = false;});
  }

  _FoulCardState({
    this.cardHeader,
    this.teams,
    this.selectedTeam,
    this.possibleFouls,
    this.parent,
    this.card
  }) {
    players = teams.fold([], (players, team) => players + team.players);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(height: 25),
          Text(cardHeader, style: dialogHeaderStyle, textAlign: TextAlign.left),
          Container(height: 25),
          Text("TEAM", style: headerStyle.copyWith(color: Colors.grey[800])),
          Container(height: 20),
          Material(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(5.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal:0.0),
              child: CupertinoSegmentedControl(
                borderColor: Colors.grey[800],
                unselectedColor: Colors.grey[800],
                pressedColor: cardTypeColor[this.card.cardType],
                selectedColor: cardTypeColor[this.card.cardType],
                groupValue: selectedTeam,
                children: <Team, Widget>{
                  teams[0]: Text(teams[0].name, style: headerStyle.copyWith(fontSize: 14)),
                  teams[1]: Text(teams[1].name, style: headerStyle.copyWith(fontSize: 14)),
                }, 
                onValueChanged: (Team newTeam) {setState(() {
                  selectedTeam = newTeam;
                  selectedPlayer = null;
                  players = newTeam.players;
                });},
              ),
            ),
          ),
          Container(height: 25),
          Text("PLAYER", style: headerStyle.copyWith(color: Colors.grey[800])),
          PlayerSelector(key: fouler, players: players, value: selectedPlayer, onChanged: (dynamic newPlayer) {
            setState(() {
              selectedTeam = teams.where((team) => team.players.contains(newPlayer)).toList()[0];
              players = selectedTeam.players;
              selectedPlayer = newPlayer;
            });
        }),
          Container(height: 25),
          Text("FOUL", style: headerStyle.copyWith(color: Colors.grey[800])),
          FoulSelector(key: foul, fouls: this.possibleFouls, value: selectedFoul, onChanged: (dynamic newFoul) {
            setState(() {
              selectedFoul = newFoul;
            });
          }),
          Container(height: 5),
          FlatButton(
            child: Text("SUBMIT", style: headerStyle, textAlign: TextAlign.right,), 
            onPressed: selectedPlayer != null && selectedFoul != null ? submitFunction : null,
          )
        ],
      ),
    );
  }
}