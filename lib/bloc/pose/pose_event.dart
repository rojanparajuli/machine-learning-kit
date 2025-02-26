import 'dart:io';

abstract class PoseEvent {
  List<Object?> get props => [];
}

class CaptureImage extends PoseEvent {
  final File image;
  CaptureImage(this.image);

  @override
  List<Object?> get props => [image];
}
