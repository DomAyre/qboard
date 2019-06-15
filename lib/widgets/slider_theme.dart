import 'package:flutter/material.dart';

SliderThemeData standardSlider(context) {
  return SliderTheme.of(context).copyWith(
    trackHeight: 8,
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
    tickMarkShape: SliderTickMarkShape.noTickMark,
  );
}