
import 'dart:io';

abstract class DocumentScannerState  {
  List<Object> get props => [];
}

class DocumentScannerInitial extends DocumentScannerState {}

class DocumentScannerLoading extends DocumentScannerState {}

class DocumentScannerExtracted extends DocumentScannerState {
  final File image;
  final String text;

  DocumentScannerExtracted(this.image, this.text);
}

class DocumentScannerSaved extends DocumentScannerState {}

class DocumentScannerError extends DocumentScannerState {
  final String message;

  DocumentScannerError(this.message);
}
