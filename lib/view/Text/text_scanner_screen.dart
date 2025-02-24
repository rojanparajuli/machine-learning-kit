import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ml_kit_test/bloc/text_scanner_bloc.dart';
import 'package:ml_kit_test/bloc/text_scanner_event.dart';
import 'package:ml_kit_test/bloc/text_scanner_state.dart';
import 'package:ml_kit_test/constant/app_color.dart';
import 'package:ml_kit_test/view/Text/text_history.dart';

class TextScannerScreen extends StatelessWidget {
  const TextScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new)),
        backgroundColor: AppColor.primaryColor,
        title: const Text(
          "Text Scanner",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoryScreen())),
              icon: const Icon(
                Icons.history,
                size: 30,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: const ScannerView(),
    );
  }
}

class ScannerView extends StatelessWidget {
  const ScannerView({super.key});

  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Copied to clipboard",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocBuilder<TextScannerBloc, TextScannerState>(
            builder: (context, state) {
              return Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    )
                  ],
                ),
                child: state is TextScannerLoaded
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(state.image, fit: BoxFit.cover),
                      )
                    : const Center(
                        child: Icon(
                          Icons.image,
                          size: 80,
                          color: Colors.black,
                        ),
                      ),
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                  context, "Pick from Gallery", ImageSource.gallery),
              SizedBox(
                width: 10,
              ),
              _buildActionButton(context, "Open Camera", ImageSource.camera),
            ],
          ),
          const SizedBox(height: 20),
          BlocBuilder<TextScannerBloc, TextScannerState>(
            builder: (context, state) {
              if (state is TextScannerLoaded) {
                return Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 3,
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            state.text,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSaveButton(context, state.text),
                          ElevatedButton.icon(
                            onPressed: () =>
                                copyToClipboard(context, state.text),
                            icon: const Icon(
                              Icons.copy,
                              color: Colors.white,
                            ),
                            label: const Text("Copy"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, String text, ImageSource source) {
    return ElevatedButton.icon(
      onPressed: () {
        context.read<TextScannerBloc>().add(PickImageEvent(source));
      },
      icon: Icon(
        source == ImageSource.gallery ? Icons.photo : Icons.camera_alt,
        size: 20,
        color: Colors.black,
      ),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, String text) {
    return ElevatedButton.icon(
      onPressed: () {
        context.read<TextScannerBloc>().add(SaveTextEvent(text));
      },
      icon: const Icon(
        Icons.download,
        size: 20,
        color: Colors.white,
      ),
      label: const Text("Save to History"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
