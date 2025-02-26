import 'dart:io';
import 'dart:ui' as ui;

abstract class SegmentationState {
  List<Object?> get props => [];
}

class SegmentationInitial extends SegmentationState {}

class SegmentationLoading extends SegmentationState {}

class SegmentationSuccess extends SegmentationState {
  final File selectedImage;
  final ui.Image maskImage;

  SegmentationSuccess(this.selectedImage, this.maskImage);

  @override
  List<Object?> get props => [selectedImage, maskImage];
}

class SegmentationError extends SegmentationState {
  final String message;
  SegmentationError(this.message);
}
