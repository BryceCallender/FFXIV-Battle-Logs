import 'package:flutter/material.dart';

class ColorHelper {
  static Color getProgressColor(num progressPercent) {
    if (progressPercent > 75) {
      return Colors.white;
    } else if (progressPercent <= 75 && progressPercent > 50) {
      return Colors.green;
    } else if (progressPercent <= 50 && progressPercent > 20) {
      return Colors.blue;
    } else if (progressPercent <= 20 && progressPercent > 10) {
      return Colors.deepPurpleAccent;
    } else {
      return Colors.deepOrangeAccent;
    }
  }
}