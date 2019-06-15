import 'package:flutter/material.dart';
import './match.dart';

class Player {

  List<Goal> goals = [];
  List<Goal> assists = [];
  List<FoulEvent> fouls = [];
  String firstName;
  String lastName;

  Player({this.firstName, this.lastName});

  String getFullName() => "${this.firstName} ${this.lastName}";
}

class PlayerSelector extends DropdownButton {

  PlayerSelector({
    Key key,
    @required List<Player> players,
    onChanged,
    Color foreground,
    Player value
  }) : super(
    key: key, 
    items: players.map((player) => DropdownMenuItem (
        child: Text(player.getFullName(), style: TextStyle(color: player == value ? foreground : Colors.grey[800])),
        value: player,
      )
    ).toList(),
    onChanged: onChanged,
    value: value,
    isExpanded: true
  );
}