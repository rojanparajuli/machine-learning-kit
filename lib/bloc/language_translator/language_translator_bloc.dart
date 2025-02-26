import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ml_kit_test/bloc/language_translator/language_translator_event.dart';
import 'package:ml_kit_test/bloc/language_translator/language_translator_state.dart';

class TranslatorBloc extends Bloc<TranslatorEvent, TranslatorState> {
  File? image;
  final ImagePicker _picker = ImagePicker();
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  late OnDeviceTranslator onDeviceTranslator;
  final Map<String, TranslateLanguage> languages = {
    'English': TranslateLanguage.english,
    'Spanish': TranslateLanguage.spanish,
    'Japanese': TranslateLanguage.japanese,
    'Chinese': TranslateLanguage.chinese,
    'Hindi': TranslateLanguage.hindi,
    'Russian': TranslateLanguage.russian,
  };
  String selectedLanguage = 'Spanish';

  TranslatorBloc() : super(TranslatorInitial()) {
    on<PickImageEvent>((event, emit) async {
      final pickedFile = await _picker.pickImage(source: event.source);
      if (pickedFile != null) {
        image = File(pickedFile.path);
        await _processImage(emit);
      }
    });

    on<TranslateTextEvent>((event, emit) async {
      await _translateText(event.text, emit);
    });

    on<ChangeLanguageEvent>((event, emit) {
      selectedLanguage = event.language;
      _updateTranslator();
    });
  }

  void _updateTranslator() {
    onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: languages[selectedLanguage]!,
    );
  }

  Future<void> _processImage(Emitter<TranslatorState> emit) async {
    if (image == null) return;
    final inputImage = InputImage.fromFile(image!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    if (recognizedText.text.isNotEmpty) {
      await _translateText(recognizedText.text, emit);
    }
  }

  Future<void> _translateText(
      String text, Emitter<TranslatorState> emit) async {
    emit(TranslatingState());
    try {
      final translatedText = await onDeviceTranslator.translateText(text);
      emit(TranslatedState(translatedText));
    } catch (e) {
      emit(TranslatorErrorState('Translation failed: $e'));
    }
  }

  @override
  Future<void> close() {
    textRecognizer.close();
    onDeviceTranslator.close();
    return super.close();
  }
}
