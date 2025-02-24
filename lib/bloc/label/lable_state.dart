import 'dart:io';

abstract class LabelScannerState {}

class LabelScannerInitial extends LabelScannerState {}

class LabelScannerLoading extends LabelScannerState {}

class LabelScannerSuccess extends LabelScannerState {
  final File image;
  final List<String> labels;
  LabelScannerSuccess(this.image, this.labels);
}

class LabelScannerError extends LabelScannerState {
  final String message;
  LabelScannerError(this.message);
}
