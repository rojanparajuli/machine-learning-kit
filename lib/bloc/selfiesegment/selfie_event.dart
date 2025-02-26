import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class SelfieSegmentEvent {}

class PickImageEvent extends SelfieSegmentEvent {
  final ImageSource source;
  PickImageEvent(this.source);
}

class ProcessImageEvent extends SelfieSegmentEvent {
  final File imageFile;
  ProcessImageEvent(this.imageFile);
}