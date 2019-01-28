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

  ControlState getBludgerControlState() {
    Iterable<ControlChange> controlChanges = this.getEvents().whereType<ControlChange>();
    if (controlChanges.isNotEmpty) {
      return controlChanges.last.getNewState();
    }
    else return ControlState.NoTeamControl;
  }
}

class Goal extends MatchEvent {

  String symbolPath = "assets/goal_scored_symbol.png";
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

enum ControlState {Team1Control, NoTeamControl, Team2Control}

class ControlChange extends MatchEvent {

  String symbolPath = "assets/bludger_control_symbol.png";
  Match matchData;
  Duration time;
  ControlState newState;
  ControlState previousState;

  ControlChange({@required this.matchData, @required this.time, @required this.previousState, @required this.newState});

  String toString() {
    switch (newState) {
      case ControlState.Team1Control: return "${matchData.team1.name} wins bludger control";
      case ControlState.Team2Control: return "${matchData.team2.name} wins bludger control";
      case ControlState.NoTeamControl: {
        Team previousTeamControl = previousState == ControlState.Team1Control ? matchData.team1 : matchData.team2;
        return "${previousTeamControl.name} loses bludger control";
      }
    }
    return "";
  }

  ControlState getNewState() => this.newState;
}
