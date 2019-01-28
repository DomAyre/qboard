import 'package:flutter/material.dart';
import 'pages/matches.dart';

void main() => runApp(new QBoard());

class QBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'QBoard',
      theme: new ThemeData(
        primaryColor: Colors.blueGrey[800],
        accentColor: Colors.orange[600],
        fontFamily: 'NotoSans'
      ),
      home: new MatchesPage(title: 'QBoard'),
    );
  }
}
