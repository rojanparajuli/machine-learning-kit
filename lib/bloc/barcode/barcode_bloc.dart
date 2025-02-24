import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ml_kit_test/bloc/barcode/barcode_event.dart';
import 'package:ml_kit_test/bloc/barcode/barcode_state.dart';

class BarcodeScannerBloc
    extends Bloc<BarcodeScannerEvent, BarcodeScannerState> {
  BarcodeScannerBloc() : super(BarcodeInitial()) {
    on<PickImageEvent>(_pickImage);
    on<CaptureImageEvent>(_captureImage);
    on<ProcessImageEvent>(_processImage);
  }

  Future<void> _captureImage(
    CaptureImageEvent event, Emitter<BarcodeScannerState> emit) async {
  try {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    emit(BarcodeLoading());
    add(ProcessImageEvent(File(pickedFile.path))); 
  } catch (e) {
    emit(BarcodeError("Failed to capture image: ${e.toString()}"));
  }
}


  Future<void> _pickImage(
      PickImageEvent event, Emitter<BarcodeScannerState> emit) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      emit(BarcodeLoading());
      add(ProcessImageEvent(File(pickedFile.path)));
    } catch (e) {
      emit(BarcodeError("Failed to pick image"));
    }
  }

  Future<void> _processImage(
      ProcessImageEvent event, Emitter<BarcodeScannerState> emit) async {
    try {
      final inputImage = InputImage.fromFile(event.imageFile);
      // ignore: deprecated_member_use
      final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
      final barcodes = await barcodeScanner.processImage(inputImage);
      barcodeScanner.close();

      final barcodeData = barcodes.isNotEmpty
          ? barcodes.first.displayValue ?? "No Data"
          : "No Barcode Found";

      await FirebaseFirestore.instance.collection('history').add({
        'barcode': barcodeData,
        'timestamp': DateTime.now(),
      });

      emit(BarcodeLoaded(imageFile: event.imageFile, barcodeData: barcodeData));
    } catch (e) {
      emit(BarcodeError("Failed to process image"));
    }
  }
}
