import 'package:flutter/material.dart';
import './match.dart';

class Player {

  List<Goal> goals = [];
  List<Goal> assists = [];
  String firstName;
  String lastName;

  Player({this.firstName, this.lastName});

  String getFullName() => "${this.firstName} ${this.lastName}";
}

class PlayerSelector extends StatefulWidget {

  PlayerSelector({
    Key key,
    @required this.players,
  }) : super(key: key);

  final List<Player> players;

  @override
  PlayerSelectorState createState() => PlayerSelectorState(players: players);
}

class PlayerSelectorState extends State<PlayerSelector> {

  final List<Player> players;
  String selected;

  PlayerSelectorState({this.players});

  Player getSelected() => selected is String ? players.firstWhere((player) => player.getFullName() == selected) : null;

  @override
  Widget build(BuildContext context) {
    return DropdownButton (
      value: selected is String ? selected : null,
      items: players.map((player) => DropdownMenuItem (
          child: Text(player.getFullName()),
          value: player.getFullName(),
        )
      ).toList(),
      onChanged: (newValue) {
        setState(() {selected = newValue;});
      },
      isExpanded: true,
    );
  }
}