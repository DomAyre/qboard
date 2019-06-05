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
    this.onChanged
  }) : super(key: key);

  List<Player> players;
  VoidCallback onChanged;

  @override
  PlayerSelectorState createState() => PlayerSelectorState(players: players);
}

class PlayerSelectorState extends State<PlayerSelector> {

  List<Player> players;
  Player selected;

  PlayerSelectorState({this.players});

  @override
  Widget build(BuildContext context) {
    return DropdownButton (
      value: selected,
      items: players.map((player) => DropdownMenuItem (
          child: Text(player.getFullName()),
          value: player,
        )
      ).toList(),
      onChanged: (newValue) {
        setState(() {selected = newValue;});
        widget.onChanged();
      },
      isExpanded: true,
    );
  }
}