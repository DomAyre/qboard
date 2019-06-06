import 'dart:core';

import 'package:flutter/material.dart';

enum CardType { Blue, Yellow, Red }

class Foul {
  
  String name;
  String description;
  List<CardType> possibleCards;

  Foul({
    this.name,
    this.description,
    this.possibleCards,
  });
}

getFoulsForCardType(CardType type) => fouls.where((Foul foul) => foul.possibleCards.contains(type)).toList();

class FoulSelector extends DropdownButton {

  FoulSelector({
    Key key,
    @required List<Foul> fouls,
    @required onChanged,
    Foul value
  }) : super(
    key: key, 
    items: fouls.map((foul) => DropdownMenuItem (
        child: Text(foul.name),
        value: foul,
      )
    ).toList(),
    onChanged: onChanged,
    value: value,
    isExpanded: true
  );
}

List<Foul> fouls = [
  Foul(
    name: "Illegal Interaction", 
    description: "Interacting with a ball or fouls you're not allowed to",
    possibleCards: [CardType.Blue, CardType.Yellow],
  ),
  Foul(
    name: "Back Tackle", 
    description: "Wrapping a player while the tacklers chest is behind the chest of the tackled player",
    possibleCards: [CardType.Yellow],
  ),
  Foul(
    name: "Helpless Reciever", 
    description: "Tackling a player when they're just about to recieve a ball",
    possibleCards: [CardType.Red],
  ),
  Foul(
    name: "Second Yellow", 
    description: "Receiving two yellow cards",
    possibleCards: [CardType.Red],
  ),
];