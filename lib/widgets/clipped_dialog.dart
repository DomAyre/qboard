import 'package:flutter/material.dart';

import 'foul_card.dart';

class ClippedDialog extends StatefulWidget {
  
  final double edgeAlignment;
  final Color color;
  final Widget child;
  final Function onTapped;

  ClippedDialog({
    GlobalKey key,
    @required this.edgeAlignment,
    @required this.color,
    @required this.child,
    @required this.onTapped,
  }) : super(key: key);

  @override
  ClippedDialogState createState() => ClippedDialogState();
}

class ClippedDialogState extends State<ClippedDialog> {

  double offset = 0;
  bool isShown = false;

  @override
  Widget build(BuildContext context) {

    GlobalKey childWidgetKey = widget.child.key;
    if (childWidgetKey.currentState != null) {
      (childWidgetKey.currentState as FoulCardState).setOnSubmit(() {
        setState(() {
          isShown = false;
        });
      });
    }

    return Align(
      alignment: isShown? Alignment(0.0, 0.0) : Alignment(widget.edgeAlignment, 1.0),
      child: Transform.translate(
        offset: Offset(0.0, isShown? 0.0 : 370 + offset),
        child: GestureDetector(
          onTap: () => {
            widget.onTapped(this),
          },
          child: Card(
            color: widget.color,
            elevation: isShown ? 30 : 3,
            child: Opacity(
              opacity: isShown ? 1.0 : 0.0,
              child: Container(
                width: isShown ? 320 : 220,
                height: 420,
                child: widget.child
              )
            )
          )
        ),  
      )
    );
  }
}