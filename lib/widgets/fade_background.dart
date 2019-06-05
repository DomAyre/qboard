
import 'dart:ui';

import 'package:flutter/material.dart';

class FadeBackground extends StatefulWidget {
  
  FadeBackground({
    Key key,
    @required this.onTapped,
  }) : super(key: key);

  final VoidCallback onTapped;

  @override
  FadeBackgroundState createState() => FadeBackgroundState();
}

class FadeBackgroundState extends State<FadeBackground> {

  bool isFaded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Offstage(
        offstage: !isFaded,
        child: GestureDetector(
          onTap: () => {
            widget.onTapped(),
            setState(() {isFaded = false;}),
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
