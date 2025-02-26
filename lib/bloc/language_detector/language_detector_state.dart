import 'dart:io';

class LanguageDetectorState {
  final File? image;
  final String detectedText;
  final String detectedLanguage;

  LanguageDetectorState({this.image, this.detectedText = '', this.detectedLanguage = ''});

  LanguageDetectorState copyWith({
    File? image,
    String? detectedText,
    String? detectedLanguage,
  }) {
    return LanguageDetectorState(
      image: image ?? this.image,
      detectedText: detectedText ?? this.detectedText,
      detectedLanguage: detectedLanguage ?? this.detectedLanguage,
    );
  }
}
