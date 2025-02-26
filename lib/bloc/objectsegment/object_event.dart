import 'dart:io';
import 'package:image_picker/image_picker.dart';

abstract class SegmentationEvent {
  List<Object?> get props => [];
}

class PickImageEvent extends SegmentationEvent {
  final ImageSource source;
  PickImageEvent(this.source);
}

class ProcessImageEvent extends SegmentationEvent {
  final File imageFile;
  ProcessImageEvent(this.imageFile);
}
