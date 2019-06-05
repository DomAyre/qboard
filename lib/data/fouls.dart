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

class FoulSelector extends StatefulWidget {

  FoulSelector({
    Key key,
    @required this.fouls,
  }) : super(key: key);

  final List<Foul> fouls;

  @override
  FoulSelectorState createState() => FoulSelectorState(fouls: fouls);
}

class FoulSelectorState extends State<FoulSelector> {

  final List<Foul> fouls;
  Foul selected;

  FoulSelectorState({this.fouls});

  @override
  Widget build(BuildContext context) {
    return DropdownButton (
      value: selected,
      items: fouls.map((foul) => DropdownMenuItem (
          child: Text(foul.name),
          value: foul,
        )
      ).toList(),
      onChanged: (newValue) {
        setState(() {selected = newValue;});
      },
      isExpanded: true,
    );
  }
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
];