import 'package:image_picker/image_picker.dart';

abstract class TextScannerEvent {}
class PickImageEvent extends TextScannerEvent {
  final ImageSource source;
  PickImageEvent(this.source);
}
class SaveTextEvent extends TextScannerEvent {
  final String text;
  SaveTextEvent(this.text);
}
class LoadHistoryEvent extends TextScannerEvent {}