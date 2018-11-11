import 'package:flutter/material.dart';
import './match.dart';

class Team {

  String name;
  String logoPath;
  Color background;
  List<Goal> goals = [];

  Team(this.name, this.logoPath, [this.background]);

  List<Map<String, dynamic>> getGoalsJson() => List.from(goals.map(Goal.toJson));
}