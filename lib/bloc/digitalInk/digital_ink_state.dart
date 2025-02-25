import 'package:flutter/material.dart';

class DigitalInkState {
  final List<Offset?> points;
  final String recognizedText;

  DigitalInkState({required this.points, required this.recognizedText});

  DigitalInkState copyWith({List<Offset?>? points, String? recognizedText}) {
    return DigitalInkState(
      points: points ?? this.points,
      recognizedText: recognizedText ?? this.recognizedText,
    );
  }
}
