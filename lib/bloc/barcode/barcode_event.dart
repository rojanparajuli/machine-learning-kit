import 'dart:io';

abstract class BarcodeScannerEvent {
  const BarcodeScannerEvent();

  List<Object?> get props => [];
}
class CaptureImageEvent extends BarcodeScannerEvent {}


class PickImageEvent extends BarcodeScannerEvent {}

class ProcessImageEvent extends BarcodeScannerEvent {
  final File imageFile;

  const ProcessImageEvent(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}
