import './team.dart';
import './player.dart';

class Match {

  Team team1;
  Team team2;

  Match({this.team1, this.team2});

  int team1Score() => this.team1.goals.length;
  int team2Score() => this.team2.goals.length;
}

class Goal {

  Duration time;
  Team team;
  Player scorer;
  Player assist;

  Goal(this.time, this.team, [this.scorer, this.assist]) {
    this.team.goals.add(this);
    if (this.scorer is Player) this.scorer.goals.add(this);
    if (this.assist is Player) this.assist.assists.add(this);
  }
}