import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ml_kit_test/bloc/language_translator/language_translator_bloc.dart';
import 'package:ml_kit_test/bloc/language_translator/language_translator_event.dart';
import 'package:ml_kit_test/bloc/language_translator/language_translator_state.dart';
import 'package:ml_kit_test/constant/app_color.dart';

class LanguageTranslatorScreen extends StatelessWidget {
  const LanguageTranslatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        backgroundColor: AppColor.primaryColor,
        title: const Text(
          'Language Translator',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocBuilder<TranslatorBloc, TranslatorState>(
              builder: (context, state) {
                if (state is TranslatingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TranslatedState) {
                  return Text(
                    state.translatedText,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  );
                } else if (state is TranslatorErrorState) {
                  return Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  );
                }
                return const Text(
                  'No text translated yet.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                );
              },
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _blackButton(
                  label: 'Gallery',
                  icon: Icons.image,
                  onPressed: () => context.read<TranslatorBloc>().add(PickImageEvent(ImageSource.gallery)),
                ),
                _blackButton(
                  label: 'Camera',
                  icon: Icons.camera_alt,
                  onPressed: () => context.read<TranslatorBloc>().add(PickImageEvent(ImageSource.camera)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: context.watch<TranslatorBloc>().selectedLanguage,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  context.read<TranslatorBloc>().add(ChangeLanguageEvent(newValue));
                }
              },
              items: context.read<TranslatorBloc>().languages.keys.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'Enter text to translate',
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (text) => context.read<TranslatorBloc>().add(TranslateTextEvent(text)),
            ),
            const SizedBox(height: 20),
            _blackButton(
              label: 'Translate',
              icon: Icons.translate,
              onPressed: () => context.read<TranslatorBloc>().add(TranslateTextEvent('Test text')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blackButton({required String label, required IconData icon, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    );
  }
}
