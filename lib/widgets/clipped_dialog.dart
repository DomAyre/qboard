import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

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

class ClippedDialogState extends State<ClippedDialog> with TickerProviderStateMixin {

  double offset = 0;
  bool isShown = false;

  AnimationController alignmentController;
  Animation<Alignment> alignmentTween;

  ClippedDialogState() {    
    alignmentController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

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

    alignmentTween = AlignmentTween(
      begin: Alignment(widget.edgeAlignment, 1.0),
      end: Alignment(0.0, 0.0),
    ).animate(alignmentController);

    alignmentController.animateTo(isShown ? 1 : 0, curve: Curves.fastOutSlowIn);

    return AlignTransition(
      alignment: alignmentTween,
      child: AnimatedContainer(
        transform: Matrix4.translation(Vector3(0, isShown? 0 : 370, 0)),
        width: isShown ? 320 : 220,
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        child: Transform.translate(
          offset: Offset(0, offset),
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
                  height: 420,
                  child: widget.child
                )
              )
            )
          ),
        ),  
      )
    );
  }
}