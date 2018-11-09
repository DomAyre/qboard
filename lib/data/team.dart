import './match.dart';

class Team {

  String name;
  List<Goal> goals = [];

  Team({this.name});

  List<Map<String, dynamic>> getGoalsJson() => List.from(goals.map(Goal.toJson));
}