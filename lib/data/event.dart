import 'package:flutter/material.dart';
import '../widgets/scorekeeper.dart';
import '../widgets/timer.dart';

abstract class MatchEvent {

  Duration time;
  String symbolPath;

  String toString();
}

class EventStream extends StatefulWidget {
  const EventStream({
    Key key,
    @required this.scoreKeeper,
  }) : super(key: key);

  final ScoreKeeper scoreKeeper;

  @override
  EventStreamState createState() {
    return new EventStreamState();
  }
}

class EventStreamState extends State<EventStream> {
  @override
  Widget build(BuildContext context) {
    this.widget.scoreKeeper.register(this);
    return new Padding (
      padding: EdgeInsets.only(bottom: 30),
      child: new Column (
        children: this.widget.scoreKeeper.matchData.getEvents().map((MatchEvent event) => 
          new EventText(event: event)
        ).toList()
      ),
    );
  }
}

class EventText extends StatelessWidget {

  final MatchEvent event;

  const EventText({
    Key key,
    @required this.event
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Padding (
      padding: EdgeInsets.only(top: 25, left: 35, right: 35),
      child: new Row (
        children: [
          Container(
            width: 50,
            height: 50,
            child: new Padding (
              padding: EdgeInsets.only(right: 20),
              child : Image.asset(event.symbolPath),
            ),
          ),
          new Expanded ( 
            child : new Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(MatchTimer.getTimeString(event.time), textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold)),
                  new Container (
                    child: Text(event.toString(), textAlign: TextAlign.left, style: TextStyle(fontSize: 18))
                  )
              ]
            )
          )
        ]
      )
    );
  }
}