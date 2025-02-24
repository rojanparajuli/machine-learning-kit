import 'dart:io';

abstract class TextScannerState {}
class TextScannerInitial extends TextScannerState {}
class TextScannerLoading extends TextScannerState {}
class TextScannerLoaded extends TextScannerState {
  final File image;
  final String text;
  TextScannerLoaded(this.image, this.text);
}
class TextScannerHistoryLoaded extends TextScannerState {
  final List<String> history;
  TextScannerHistoryLoaded(this.history);
}
class TextScannerError extends TextScannerState {
  final String message;
  TextScannerError(this.message);
}