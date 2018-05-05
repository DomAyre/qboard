import 'package:flutter/material.dart';

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

class MatchesPage extends StatefulWidget {
  MatchesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MatchesPageState createState() => new _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(),
    );
  }
}
