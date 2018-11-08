import 'package:flutter/material.dart';

class Manager {

  List<State<StatefulWidget>> children = [];

  void register(State<StatefulWidget> child) {
    children.add(child);
  }

  void invalidate() {
    children.forEach((child) => child.setState(() => {}));
  }
}