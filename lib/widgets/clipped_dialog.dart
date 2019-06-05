import 'package:flutter/material.dart';

class ClippedDialog extends StatefulWidget {
  
  bool isShown = false;
  double edgeAlignment;
  Color color;
  Widget child;
  Function onTapped;

  ClippedDialog({
    @required this.edgeAlignment,
    @required this.color,
    @required this.child,
    @required this.onTapped,
  });

  @override
  ClippedDialogState createState() => ClippedDialogState();

  show() {
    this.isShown = true;
  }

  hide() {
    this.isShown = false;
  }
}

class ClippedDialogState extends State<ClippedDialog> {
  
  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: widget.isShown? Alignment(0.0, 0.0) : Alignment(widget.edgeAlignment, 1.0),
      child: Transform.translate(
        offset: Offset(0.0, widget.isShown? 0.0 : 370),
        child: GestureDetector(
          onTap: () => {
            widget.onTapped(this),
          },
          child: Card(
            color: widget.color,
            elevation: widget.isShown ? 30 : 3,
            child: Opacity(
              opacity: widget.isShown ? 1.0 : 0.0,
              child: Container(
                width: widget.isShown ? 320 : 220,
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