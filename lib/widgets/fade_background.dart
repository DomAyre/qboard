
import 'dart:ui';

import 'package:flutter/material.dart';

class FadeBackground extends StatefulWidget {
  
  FadeBackground({
    Key key,
    @required this.isFaded,
    @required this.onTapped,
  }) : super(key: key);

  bool isFaded;
  VoidCallback onTapped;

  @override
  _FadeBackgroundState createState() => _FadeBackgroundState();
}

class _FadeBackgroundState extends State<FadeBackground> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Offstage(
        offstage: !widget.isFaded,
        child: GestureDetector(
          onTap: () => {
            widget.onTapped(),
            setState(() {widget.isFaded = false;}),
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
        ),
      )
    );
  }
}
