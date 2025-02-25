import 'dart:io';

abstract class FaceDetectionState {
  List<Object?> get props => [];
}

class FaceDetectionInitial extends FaceDetectionState {}

class FaceProcessing extends FaceDetectionState {}

class FaceDetected extends FaceDetectionState {
  final int faceCount;
  final File image;
  final bool isNewFace;
  final Map<String, dynamic>? faceData;

  FaceDetected(this.image, this.faceCount, this.isNewFace, this.faceData);

  @override
  List<Object?> get props => [image, faceCount, isNewFace, faceData];
}

class FaceExists extends FaceDetectionState {
  final Map<String, dynamic> faceData;

  FaceExists(this.faceData);

  @override
  List<Object?> get props => [faceData];
}

class FaceAdded extends FaceDetectionState {}
