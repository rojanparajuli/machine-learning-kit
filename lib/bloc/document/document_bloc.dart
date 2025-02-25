import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ml_kit_test/bloc/document/document_event.dart';
import 'package:ml_kit_test/bloc/document/document_state.dart';
import 'package:ml_kit_test/widget/custom_paint_widget.dart';
import 'package:flutter/services.dart';

class DocumentScannerBloc
    extends Bloc<DocumentScannerEvent, DocumentScannerState> {
  final ImagePicker _picker = ImagePicker();
  final textRecognizer = TextRecognizer();
  final MethodChannel _platform = MethodChannel("image_saver");

  DocumentScannerBloc() : super(DocumentScannerInitial()) {
    on<PickImage>(_onPickImage);
    on<ExtractText>(_onExtractText);
    on<SaveText>(_onSaveText);
  }

  // Handle Image Picking
  Future<void> _onPickImage(
      PickImage event, Emitter<DocumentScannerState> emit) async {
    final pickedFile = await _picker.pickImage(source: event.source);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      emit(DocumentScannerLoading());
      add(ExtractText(image));
    }
  }

  // Handle Text Extraction
  Future<void> _onExtractText(
      ExtractText event, Emitter<DocumentScannerState> emit) async {
    final inputImage = InputImage.fromFile(event.image);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    emit(DocumentScannerExtracted(event.image, recognizedText.text));
  }

  // Handle Saving Text as Image
  Future<void> _onSaveText(
      SaveText event, Emitter<DocumentScannerState> emit) async {
    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final painter = TextCanvasPainter(event.text);
      const imageSize = Size(500, 600);
      painter.paint(canvas, imageSize);

      final ui.Image image = await recorder.endRecording().toImage(
            imageSize.width.toInt(),
            imageSize.height.toInt(),
          );

      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        emit(DocumentScannerError("Failed to convert image to bytes."));
        return;
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Get the public directory for saving the image
      final directory =
          Directory('/storage/emulated/0/Pictures'); // Public gallery folder
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filePath =
          '${directory.path}/scanned_text_${DateTime.now().millisecondsSinceEpoch}.png';
      File file = File(filePath);
      await file.writeAsBytes(pngBytes);

      // Save metadata to Firebase
      await FirebaseFirestore.instance.collection('docshistory').add({
        'text': event.text,
        'image_path': filePath,
        'timestamp': DateTime.now(),
      });

      // Refresh gallery so image appears
      final result = await _platform
          .invokeMethod("refreshGallery", {"imagePath": filePath});
      if (result == "success") {
        emit(DocumentScannerSaved());
      } else {
        emit(DocumentScannerError("Image saved but not showing in gallery."));
      }
    } catch (e) {
      emit(DocumentScannerError(
          "Failed to save text as image: ${e.toString()}"));
    }
  }

  @override
  Future<void> close() {
    textRecognizer.close();
    return super.close();
  }
}
