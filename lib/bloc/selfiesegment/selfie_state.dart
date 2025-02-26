import 'dart:io';
import 'dart:ui' as ui;

abstract class SelfieSegmentState {}

class SelfieSegmentInitial extends SelfieSegmentState {}

class SelfieSegmentLoading extends SelfieSegmentState {}

class SelfieSegmentSuccess extends SelfieSegmentState {
  final File selectedImage;
  final ui.Image maskImage;
  SelfieSegmentSuccess(this.selectedImage, this.maskImage);
}

class SelfieSegmentError extends SelfieSegmentState {
  final String message;
  SelfieSegmentError(this.message);
}
