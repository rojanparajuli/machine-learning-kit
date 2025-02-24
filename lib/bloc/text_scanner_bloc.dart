import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ml_kit_test/bloc/text_scanner_event.dart';
import 'package:ml_kit_test/bloc/text_scanner_state.dart';

class TextScannerBloc extends Bloc<TextScannerEvent, TextScannerState> {
  TextScannerBloc() : super(TextScannerInitial()) {
    on<PickImageEvent>(_onPickImage);
    on<SaveTextEvent>(_onSaveText);
    on<LoadHistoryEvent>(_onLoadHistory);
  }

  Future<void> _onPickImage(
      PickImageEvent event, Emitter<TextScannerState> emit) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: event.source);
      if (pickedFile == null) return;
      File image = File(pickedFile.path);
      emit(TextScannerLoading());

      final inputImage = InputImage.fromFile(image);
      // ignore: deprecated_member_use
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);
      textRecognizer.close();

      emit(TextScannerLoaded(image, recognizedText.text));
    } catch (e) {
      emit(TextScannerError("Failed to process image"));
    }
  }

  Future<void> _onSaveText(
      SaveTextEvent event, Emitter<TextScannerState> emit) async {
    try {
      await FirebaseFirestore.instance
          .collection('scanned_texts')
          .add({'text': event.text, 'timestamp': FieldValue.serverTimestamp()});
    } catch (e) {
      emit(TextScannerError("Failed to save text"));
    }
  }

  Future<void> _onLoadHistory(
      LoadHistoryEvent event, Emitter<TextScannerState> emit) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('scanned_texts')
          .orderBy('timestamp', descending: true)
          .get();
      final history =
          snapshot.docs.map((doc) => doc['text'] as String).toList();
      emit(TextScannerHistoryLoaded(history));
    } catch (e) {
      emit(TextScannerError("Failed to load history"));
    }
  }
}
