import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qboard/data/team.dart';

import '../common.dart';

class BinaryTeamSelector extends StatefulWidget {

  final Color background;
  final Color foreground;

  final List<Team> teams;
  final Team initialSelectedTeam;

  final Function onChanged;

  BinaryTeamSelector({
    Key key,
    @required this.background,
    @required this.foreground,
    @required this.teams,
    this.initialSelectedTeam,
    this.onChanged,
  }) : super(key: key);

  @override
  BinaryTeamSelectorState createState() => BinaryTeamSelectorState(selectedTeam: initialSelectedTeam);
}

class BinaryTeamSelectorState extends State<BinaryTeamSelector> {

  Team selectedTeam;

  BinaryTeamSelectorState({this.selectedTeam});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.background,
      borderRadius: BorderRadius.circular(5.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal:0.0),
        child: CupertinoSegmentedControl(
          borderColor: widget.background,
          unselectedColor: widget.background,
          pressedColor: widget.foreground,
          selectedColor: widget.foreground,
          groupValue: selectedTeam,
          children: <Team, Widget>{
            widget.teams[0]: Text(widget.teams[0].name, style: headerStyle.copyWith(fontSize: 14)),
            widget.teams[1]: Text(widget.teams[1].name, style: headerStyle.copyWith(fontSize: 14)),
          }, 
          onValueChanged: (Team newTeam) {
            setState(() {selectedTeam = newTeam;});
            if (widget.onChanged != null) {
              widget.onChanged(newTeam);
            }
          },
        ),
      ),
    );
  }
}