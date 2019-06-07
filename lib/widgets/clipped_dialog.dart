import 'package:flutter/material.dart';
import 'package:qboard/common.dart';

import 'foul_card.dart';

class ClippedDialog extends StatefulWidget {
  
  final double edgeAlignment;
  final Color color;
  final Widget child;
  
  final Function onShow;
  final Function onHide;
  final Function onDrag;

  ClippedDialog({
    GlobalKey key,
    @required this.edgeAlignment,
    @required this.color,
    @required this.child,
    @required this.onShow,
    @required this.onHide,
    @required this.onDrag,
  }) : super(key: key);

  @override
  ClippedDialogState createState() => ClippedDialogState();
}

class ClippedDialogState extends State<ClippedDialog> with TickerProviderStateMixin {

  double offset = 0;
  double dragStart;
  bool dragClosing;

  AnimationController animation;

  ClippedDialogState() {   
    animation = AnimationController(
      vsync: this,
      duration: longAnimation,
    );

    animation.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    // Setup closing the card on submit
    GlobalKey childWidgetKey = widget.child.key;
    if (childWidgetKey.currentState != null) {
      (childWidgetKey.currentState as FoulCardState).setOnSubmit(() {
        setState(() {
          animation.animateBack(0, curve: Curves.fastOutSlowIn);
          widget.onHide(this);
        });
      });
    }

    AlignmentTween alignmentTween = AlignmentTween(
      begin: Alignment(widget.edgeAlignment, 1.0),
      end: Alignment(0.0, 1.0),
    );

    Tween<Offset> translateTween = Tween<Offset>(
      begin: Offset(0, 370 + offset), 
      end: Offset(0, -80 + offset)
    );

    Tween<double> widthTween = Tween<double>(begin: 220, end: 320);

    Tween<double> elevationTween = Tween<double>(begin: 3, end: 24);

    return Align(
      alignment: alignmentTween.animate(animation).value,
      child: Transform.translate(
        offset: translateTween.animate(animation).value,
        child: Container(
          width: widthTween.animate(animation).value,
          child: GestureDetector(
            onTap: () {
              animation.animateTo(1, curve: Curves.fastOutSlowIn);
              widget.onShow(this);
            },
            onVerticalDragStart: (DragStartDetails start) {
              dragStart = start.globalPosition.dy;
              dragClosing = animation.value == 1.0;
            },
            onVerticalDragUpdate: (DragUpdateDetails update) {
              double translateDiff = translateTween.begin.dy - translateTween.end.dy;
              double dragDiff = ((update.globalPosition.dy - dragStart).abs() / translateDiff);
              widget.onDrag(this, dragDiff);
              if (dragClosing) dragDiff = 1 - dragDiff;
              animation.value = dragDiff.clamp(0.0, 1.0);
            },
            onVerticalDragEnd: (DragEndDetails end) {
              double threshold = dragClosing ? 0.85 : 0.15;
              bool toShow = animation.value > threshold;
              animation.animateTo(toShow ? 1 : 0, curve: Curves.fastOutSlowIn);
              if (toShow) widget.onShow(this);
              else widget.onHide(this);
            },
            child: Card(
              color: widget.color,
              elevation: elevationTween.animate(animation).value,
              child: Opacity(
                opacity: animation.value,
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