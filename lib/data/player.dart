import 'package:flutter/material.dart';
import './match.dart';
import 'fouls.dart';

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
    @required onChanged,
    Player value
  }) : super(
    key: key, 
    items: players.map((player) => DropdownMenuItem (
        child: Text(player.getFullName()),
        value: player,
      )
    ).toList(),
    onChanged: onChanged,
    value: value,
    isExpanded: true
  );
}