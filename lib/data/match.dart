import 'package:flutter/material.dart';
import './team.dart';
import './player.dart';
import './event.dart';
import 'dart:collection';

class Match {

  Team team1;
  Team team2;
  Queue<MatchEvent> matchEvents = new Queue();

  Match({this.team1, this.team2});

  int team1Score() => this.team1.goals.length;
  int team2Score() => this.team2.goals.length;

  void addEvent(MatchEvent event) => this.matchEvents.addLast(event);

  Queue<MatchEvent> getEvents() => this.matchEvents;

  List<Map<String, dynamic>> getGoals() => team1.getGoalsJson() + team2.getGoalsJson();
}

class Goal extends MatchEvent {

  Duration time;
  Team team;
  Player scorer;
  Player assist;

  Goal({@required this.time, @required this.team, this.scorer, this.assist}) {
    this.team.goals.add(this);
    if (this.scorer is Player) this.scorer.goals.add(this);
    if (this.assist is Player) this.assist.assists.add(this);
  }

  static Map<String, dynamic> toJson(Goal goal) => {
    "time" : goal.time,
    "team" : goal.team
  };

  String toString() {

    String goalString = this.scorer is Player ? 
      '${this.scorer.getFullName()} scores for ${this.team.name}' : '${this.team.name} scores';

    if (this.assist is Player) goalString += ', assist from ${this.assist.getFullName()}';

    return goalString;
  }
}