import 'package:flutter/material.dart';
import 'pages/matches.dart';

void main() => runApp(QBoard());

class QBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QBoard',
      theme: ThemeData(
        primaryColor: Colors.blueGrey[800],
        accentColor: Colors.orange[600],
        fontFamily: 'NotoSans'
      ),
      home: MatchesPage(title: 'QBoard'),
    );
  }
}
