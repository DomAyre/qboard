import 'package:flutter/material.dart';
import 'package:qboard/common.dart';
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

  AnimationController alignmentController;
  Animation<Alignment> alignmentTween;

  ClippedDialogState() {    
    alignmentController = AnimationController(
      vsync: this,
      duration: longAnimation,
    );
  }

  @override
  Widget build(BuildContext context) {

    GlobalKey childWidgetKey = widget.child.key;
    if (childWidgetKey.currentState != null) {
      (childWidgetKey.currentState as FoulCardState).setOnSubmit(() {
        setState(() {
          alignmentController.value = 0;
        });
      });
    }

    alignmentTween = AlignmentTween(
      begin: Alignment(widget.edgeAlignment, 1.0),
      end: Alignment(0.0, 1.0),
    ).animate(alignmentController);

    return Align(
      alignment: Alignment(widget.edgeAlignment - (widget.edgeAlignment * alignmentController.value), 1.0),
      child: AnimatedContainer(
        transform: Matrix4.translation(Vector3(0, 370 - (450 * alignmentController.value), 0)),
        width: 220 + (100 * alignmentController.value),
        duration: longAnimation,
        curve: Curves.fastOutSlowIn,
        child: Transform.translate(
          offset: Offset(0, offset),
          child: GestureDetector(
            onTap: () => {
              widget.onTapped(this),
            },
            child: Card(
              color: widget.color,
              elevation: 3 + (21 * alignmentController.value),
              child: Opacity(
                opacity: alignmentController.value,
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