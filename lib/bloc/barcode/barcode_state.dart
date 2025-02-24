import 'dart:io';

abstract class BarcodeScannerState  {
  const BarcodeScannerState();

  List<Object?> get props => [];
}

class BarcodeInitial extends BarcodeScannerState {}

class BarcodeLoading extends BarcodeScannerState {}

class BarcodeLoaded extends BarcodeScannerState {
  final File imageFile;
  final String barcodeData;

  const BarcodeLoaded({required this.imageFile, required this.barcodeData});

  @override
  List<Object?> get props => [imageFile, barcodeData];
}

class BarcodeError extends BarcodeScannerState {
  final String message;

  const BarcodeError(this.message);

  @override
  List<Object?> get props => [message];
}
