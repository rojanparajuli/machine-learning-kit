import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart'
    as mlkit;import 'package:ml_kit_test/bloc/digitalInk/digital_ink_state.dart';

class DigitalInkCubit extends Cubit<DigitalInkState> {
  final mlkit.DigitalInkRecognizer _recognizer = mlkit.DigitalInkRecognizer(languageCode: 'en-US');

  DigitalInkCubit() : super(DigitalInkState(points: [], recognizedText: ""));

  void addPoint(Offset point) {
    emit(state.copyWith(points: List.from(state.points)..add(point)));
  }

  void addBreak() {
    emit(state.copyWith(points: List.from(state.points)..add(null)));
  }

  void clearCanvas() {
    emit(DigitalInkState(points: [], recognizedText: ""));
  }

  Future<void> recognizeInk() async {
    final modelManager = mlkit.DigitalInkRecognizerModelManager();
    bool isDownloaded = await modelManager.isModelDownloaded('en-US');
    if (!isDownloaded) {
      await modelManager.downloadModel('en-US');
    }

    final ink = mlkit.Ink();
    mlkit.Stroke stroke = mlkit.Stroke();
    for (Offset? point in state.points) {
      if (point != null) {
        stroke.points.add(mlkit.StrokePoint(
            x: point.dx,
            y: point.dy,
            t: DateTime.now().millisecondsSinceEpoch));
      } else {
        ink.strokes.add(stroke);
        stroke = mlkit.Stroke();
      }
    }
    if (stroke.points.isNotEmpty) {
      ink.strokes.add(stroke);
    }

    final candidates = await _recognizer.recognize(ink);
    emit(state.copyWith(
      recognizedText: candidates.isNotEmpty ? candidates.first.text : "No text recognized",
    ));
  }
}
