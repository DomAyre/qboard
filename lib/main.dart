import 'package:flutter/material.dart';
import 'pages/matches.dart';

void main() => runApp(new QBoard());

class QBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'QBoard',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MatchesPage(title: 'QBoard'),
    );
  }
}
