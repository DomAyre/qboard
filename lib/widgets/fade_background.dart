
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

  double opacity = 0;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Offstage(
        offstage: opacity == 0,
        child: GestureDetector(
          onTap: () => {
            widget.onTapped(),
            setState(() {opacity = 0;}),
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5 * opacity, sigmaY: 5 * opacity),
            child: Container(color: Colors.black.withOpacity(0),),
          ),
        ),
      )
    );
  }
}
