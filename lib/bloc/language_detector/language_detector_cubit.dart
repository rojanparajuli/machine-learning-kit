import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ml_kit_test/bloc/language_detector/language_detector_state.dart';

class LanguageDetectorCubit extends Cubit<LanguageDetectorState> {
  LanguageDetectorCubit() : super(LanguageDetectorState());

  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();
  final LanguageIdentifier _languageIdentifier =
      LanguageIdentifier(confidenceThreshold: 0.5);


//Ux kharab vo tesaile rakheko ho...................
  final Map<String, String> _languageNames = {
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'it': 'Italian',
    'pt': 'Portuguese',
    'zh': 'Chinese',
    'ja': 'Japanese',
    'ko': 'Korean',
    'hi': 'Hindi',
    'ar': 'Arabic',
    'ru': 'Russian',
    'bn': 'Bengali',
    'tr': 'Turkish',
    'ur': 'Urdu',
    'fa': 'Persian',
    'id': 'Indonesian',
    'nl': 'Dutch',
    'sv': 'Swedish',
    'pl': 'Polish',
    'tl': 'Tagalog',
    'th': 'Thai',
    'vi': 'Vietnamese',
  };

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      emit(state.copyWith(image: File(pickedFile.path), detectedText: '', detectedLanguage: ''));
      _processImage(File(pickedFile.path));
    }
  }

  Future<void> _processImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    String extractedText = recognizedText.text;

    String detectedLanguageCode = 'Unknown';
    String detectedLanguageName = 'Unknown';

    if (extractedText.isNotEmpty) {
      detectedLanguageCode = await _languageIdentifier.identifyLanguage(extractedText);
      detectedLanguageName = _languageNames[detectedLanguageCode] ?? 'Unknown';
    }

    emit(state.copyWith(
      detectedText: extractedText,
      detectedLanguage: detectedLanguageName,
    ));
  }

  @override
  Future<void> close() {
    _textRecognizer.close();
    _languageIdentifier.close();
    return super.close();
  }
}
