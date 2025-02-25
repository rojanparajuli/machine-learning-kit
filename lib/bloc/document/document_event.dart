import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class DocumentScannerEvent {
  
  List<Object> get props => [];
}

class PickImage extends DocumentScannerEvent {
  final ImageSource source;

  PickImage(this.source);
}

class ExtractText extends DocumentScannerEvent {
  final File image;

  ExtractText(this.image);
}

class SaveText extends DocumentScannerEvent {
  final String text;

  SaveText(this.text);
}
