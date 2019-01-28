import 'package:flutter/material.dart';
import './match.dart';
import './player.dart';

class Team {

  String name;
  String logoPath;
  Color background;
  Color foreground;
  List<Goal> goals = [];
  List<Player> players = [];

  Team(this.name, this.logoPath, [this.background, this.foreground]);

  List<Map<String, dynamic>> getGoalsJson() => List.from(goals.map(Goal.toJson));

  void addPlayer(Player player) => this.players.add(player);
}