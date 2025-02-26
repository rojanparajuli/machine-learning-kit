import 'package:image_picker/image_picker.dart';

abstract class TranslatorEvent {}
class PickImageEvent extends TranslatorEvent {
  final ImageSource source;
  PickImageEvent(this.source);
}
class TranslateTextEvent extends TranslatorEvent {
  final String text;
  TranslateTextEvent(this.text);
}
class ChangeLanguageEvent extends TranslatorEvent {
  final String language;
  ChangeLanguageEvent(this.language);
}