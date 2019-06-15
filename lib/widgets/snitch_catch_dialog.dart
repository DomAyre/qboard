import 'package:flutter/material.dart';
import 'package:qboard/colors.dart';
import 'package:qboard/data/player.dart';
import 'package:qboard/data/team.dart';
import 'package:qboard/widgets/binary_team_selector.dart';
import 'package:qboard/widgets/scorekeeper.dart';
import 'package:qboard/widgets/timer.dart';
import '../common.dart';


class SnitchCatchDialog extends StatefulWidget {

  final List<Team> teams;
  final Team catchingTeam;
  final Function onDismiss;
  final ScoreKeeper scoreKeeper;
  final MatchTimer matchTimer;

  SnitchCatchDialog({
    @required this.catchingTeam,
    @required this.teams,
    @required this.scoreKeeper,
    @required this.matchTimer,
    this.onDismiss,
  });

  @override
  _SnitchCatchDialogState createState() => _SnitchCatchDialogState(catchingTeam: catchingTeam);
}

class _SnitchCatchDialogState extends State<SnitchCatchDialog> {

  Team catchingTeam;
  Player catchingPlayer;
  bool catchGood;
  List<Player> players;
  GlobalKey teamSelector = GlobalKey();
  GlobalKey catcher = GlobalKey();

  _SnitchCatchDialogState({this.catchingTeam});

  @override
  Widget build(BuildContext context) {

    List<Player> allPlayers = widget.teams.fold([], (players, team) => players + team.players);
    players = catchingTeam != null ? catchingTeam.players : allPlayers;

    return SimpleDialog(
      contentPadding: EdgeInsets.all(24),
      title: Text("Snitch Catch", style: dialogHeaderStyle.copyWith(color: snitchColor)),      
      children: [
        Text("TEAM", style: headerStyle),   
        Container(height: 24),
        BinaryTeamSelector(
          key: teamSelector,
          background: Colors.grey[800],
          foreground: snitchColor,
          teams: widget.teams,   
          initialSelectedTeam: catchingTeam,   
          onChanged: (Team newTeam) {
            setState(() {
              catchingPlayer = null;
              catchingTeam = newTeam;
              players = newTeam.players;
            });
          },
        ),
        Container(height: 24),
        Text("PLAYER", style: headerStyle),   
        PlayerSelector(key: catcher, players: players, value: catchingPlayer, onChanged: (dynamic newPlayer) {
          setState(() {
            catchingTeam = widget.teams.where((team) => team.players.contains(newPlayer)).toList()[0];
            teamSelector.currentState.setState(() {                
              (teamSelector.currentState as BinaryTeamSelectorState).selectedTeam = catchingTeam;
            });
            players = catchingTeam.players;
            catchingPlayer = newPlayer;
          });
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Text("BAD", style: headerStyle),
              onPressed: () {
                widget.scoreKeeper.snitchCatch(
                  time: widget.matchTimer.elapsed,
                  team: catchingTeam,
                  catcher: catchingPlayer,
                  isGood: false,
                );
                if (widget.onDismiss != null) {
                  widget.onDismiss();
                }
                return Navigator.pop(context);
              }
            ),
            FlatButton(
              child: Text("GOOD", style: headerStyle.copyWith(color: snitchColor)),
              onPressed: () {
                widget.scoreKeeper.snitchCatch(
                  time: widget.matchTimer.elapsed,
                  team: catchingTeam,
                  catcher: catchingPlayer,
                  isGood: true,
                );
                if (widget.onDismiss != null) {
                  widget.onDismiss();
                }
                return Navigator.pop(context);
              }
            ),
          ],
        )
      ],
    );
  }
}