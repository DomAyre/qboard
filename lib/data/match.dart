import 'package:flutter/material.dart';
import 'package:qboard/data/fouls.dart';
import 'package:qboard/widgets/scorekeeper.dart';
import './team.dart';
import './player.dart';
import './event.dart';
import 'dart:collection';

class Match {

  Team team1;
  Team team2;
  Queue<MatchEvent> matchEvents = Queue();

  Match({this.team1, this.team2});

  int team1Score() => team1.goals.length + team1.catches.length * 3;
  int team2Score() => team2.goals.length + team2.catches.length * 3;

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

class FoulEvent extends MatchEvent {

  String symbolPath = "assets/card_symbol.png";
  Duration time;
  Player fouler;
  Foul foul;
  CardType cardType;

  FoulEvent({
    @required this.time, 
    @required this.fouler,
    @required this.foul,
    @required this.cardType,
  });

  String toString() {
    return "${this.fouler.getFullName()} given a ${this.cardType.toString().split(".").last} Card for ${this.foul.name}";
  }
  
}

class CatchEvent extends MatchEvent {

  String symbolPath = "assets/snitch_catch_symbol.png";
  Duration time;
  Team team;
  Player catcher;
  bool isGood;

  CatchEvent({
    @required this.time,
    @required this.team,
    @required this.catcher,
    @required this.isGood,
  });

  String toString() {
    return "${this.catcher.getFullName()} caught for ${this.team.name}, catch called ${isGood ? "good" : "no good"}";
  }

}

class PhaseChangeEvent extends MatchEvent {

  Duration time;
  String symbolPath = "assets/snitch_catch_symbol.png";
  MatchPhase oldPhase;
  MatchPhase newPhase;

  PhaseChangeEvent({
    @required this.time,
    @required this.oldPhase,
    @required this.newPhase,
  });

  String toString() {

    String phaseChangeString = "";

    switch (newPhase) {
      case MatchPhase.Finished:
        phaseChangeString = "Match Over";
        break;
      case MatchPhase.Overtime:
        phaseChangeString = "Overtime!";
        break;
      case MatchPhase.DoubleOvertime:
        phaseChangeString = "Double Overtime!";
        break;
      case MatchPhase.Regulation:
        phaseChangeString = "Match Started";
        break;
    }

    return phaseChangeString;
  }
}
