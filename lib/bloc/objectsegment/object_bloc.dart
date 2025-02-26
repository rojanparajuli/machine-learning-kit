import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:ml_kit_test/bloc/objectsegment/object_event.dart';
import 'package:ml_kit_test/bloc/objectsegment/object_state.dart';


class SegmentationBloc extends Bloc<SegmentationEvent, SegmentationState> {
  final ImagePicker _picker = ImagePicker();
  // ignore: deprecated_member_use
  final SelfieSegmenter _selfieSegmenter = GoogleMlKit.vision.selfieSegmenter();

  SegmentationBloc() : super(SegmentationInitial()) {
    on<PickImageEvent>(_onPickImage);
    on<ProcessImageEvent>(_onProcessImage);
  }

  Future<void> _onPickImage(
      PickImageEvent event, Emitter<SegmentationState> emit) async {
    try {
      final pickedFile = await _picker.pickImage(source: event.source);
      if (pickedFile == null) return;

      emit(SegmentationLoading());
      add(ProcessImageEvent(File(pickedFile.path)));
    } catch (e) {
      emit(SegmentationError("Failed to pick image."));
    }
  }

  Future<void> _onProcessImage(
      ProcessImageEvent event, Emitter<SegmentationState> emit) async {
    try {
      emit(SegmentationLoading());

      final inputImage = InputImage.fromFile(event.imageFile);
      final mask = await _selfieSegmenter.processImage(inputImage);

      if (mask != null) {
        final maskImage = _convertMaskToImage(mask);
        final uiMaskImage = await _imageToUiImage(maskImage);
        emit(SegmentationSuccess(event.imageFile, uiMaskImage));
      } else {
        emit(SegmentationError("Failed to process image."));
      }
    } catch (e) {
      emit(SegmentationError("Error processing image."));
    }
  }

  img.Image _convertMaskToImage(SegmentationMask mask) {
    final width = mask.width;
    final height = mask.height;
    final confidences = mask.confidences;

    final image = img.Image(width: width, height: height);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final confidence = confidences[y * width + x];
        final pixelValue = (confidence * 255).toInt();
        image.setPixelRgba(x, y, pixelValue, pixelValue, pixelValue, 255);
      }
    }
    return image;
  }

  Future<ui.Image> _imageToUiImage(img.Image image) async {
    final Uint8List byteData = Uint8List.fromList(img.encodePng(image));
    final codec = await ui.instantiateImageCodec(byteData);
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  @override
  Future<void> close() {
    _selfieSegmenter.close();
    return super.close();
  }
}
