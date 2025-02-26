abstract class TranslatorState {}
class TranslatorInitial extends TranslatorState {}
class TranslatingState extends TranslatorState {}
class TranslatedState extends TranslatorState {
  final String translatedText;
  TranslatedState(this.translatedText);
}
class TranslatorErrorState extends TranslatorState {
  final String message;
  TranslatorErrorState(this.message);
}
