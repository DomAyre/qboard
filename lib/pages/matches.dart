import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/timer.dart';


class MatchesPage extends StatefulWidget {
    MatchesPage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _MatchesPageState createState() => new _MatchesPageState(); 
}

class _MatchesPageState extends State<MatchesPage> {

  Stopwatch matchStopwatch = new Stopwatch();

  @override
  Widget build(BuildContext context) { 
    return new Scaffold(
      appBar: new AppBar(
        title: new TimerText(stopwatch : matchStopwatch),
        centerTitle: true,
        bottom: new PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: new Container(),
        ),
      ),
      body: new Center(
      ),
    );
  }
}