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
  List<Foul> possibleFouls;
  MatchState parent;
  FoulCard card;
  GlobalKey fouler = GlobalKey();
  GlobalKey foul = GlobalKey();

  _FoulCardState({
    this.cardHeader,
    this.teams,
    this.selectedTeam,
    this.possibleFouls,
    this.parent,
    this.card
  });

  @override
  Widget build(BuildContext context) {

    List<Player> allPlayers = teams.fold([], (players, team) => players + team.players);
    List<Player> players = selectedTeam != null ? selectedTeam.players : allPlayers;
    
    bool hasFouler = fouler.currentState != null ? (fouler.currentState as PlayerSelectorState).selected != null : false;
    bool hasFoul = foul.currentState != null ? (foul.currentState as FoulSelectorState).selected != null : false;

    VoidCallback submitFunction = hasFoul && hasFouler ? () {
      parent.scoreKeeper.giveCard(
        time: parent.matchTimer.elapsed,
        fouler: (fouler.currentState as PlayerSelectorState).selected,
        foul: (foul.currentState as FoulSelectorState).selected,
        cardType: card.cardType
      );
      parent.setState(() {(parent.fadeBackgroundKey.currentWidget as FadeBackground).isFaded = false;});
    } : null;

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
                onValueChanged: (newTeam) {setState(() {
                  selectedTeam = newTeam;
                });},
              ),
            ),
          ),
          Container(height: 25),
          Text("PLAYER", style: headerStyle.copyWith(color: Colors.grey[800])),
          PlayerSelector(key: fouler, players: players, onChanged: () {setState(() {});}),
          Container(height: 25),
          Text("FOUL", style: headerStyle.copyWith(color: Colors.grey[800])),
          FoulSelector(key: foul, fouls: this.possibleFouls),
          Container(height: 5),
          FlatButton(
            child: Text("SUBMIT", style: headerStyle, textAlign: TextAlign.right,), 
            onPressed: submitFunction,
          )
        ],
      ),
    );
  }
}