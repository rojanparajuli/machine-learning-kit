import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ml_kit_test/bloc/label/lable_state.dart';

class LabelScannerCubit extends Cubit<LabelScannerState> {
  LabelScannerCubit() : super(LabelScannerInitial());

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      emit(LabelScannerLoading());
      _processImage(imageFile);
    }
  }

  Future<void> _processImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      // ignore: deprecated_member_use
      final imageLabeler = GoogleMlKit.vision.imageLabeler();
      final labels = await imageLabeler.processImage(inputImage);
      List<String> labelList = labels
          .map((label) =>
              "${label.label} (${label.confidence.toStringAsFixed(2)})")
          .toList();
      imageLabeler.close();

      _saveToFirebase(labelList);
      emit(LabelScannerSuccess(imageFile, labelList));
    } catch (e) {
      emit(LabelScannerError("Failed to process image"));
    }
  }

  Future<void> _saveToFirebase(List<String> labels) async {
    await FirebaseFirestore.instance.collection('label_history').add({
      'labels': labels,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> captureImage() async {
  final pickedFile =
      await ImagePicker().pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
    emit(LabelScannerLoading());
    _processImage(imageFile);
  }
}

}
