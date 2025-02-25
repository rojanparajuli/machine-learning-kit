import 'dart:io';

abstract class FaceDetectionEvent  {
  List<Object?> get props => [];
}

class PickImageEvent extends FaceDetectionEvent {}

class ProcessImageEvent extends FaceDetectionEvent {
  final File image;
  ProcessImageEvent(this.image);

  @override
  List<Object?> get props => [image];
}

class AddFaceEvent extends FaceDetectionEvent {
  final String name;
  final Map<String, dynamic> faceData;

  AddFaceEvent(this.name, this.faceData);

  @override
  List<Object?> get props => [name, faceData];
}
