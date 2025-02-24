import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ml_kit_test/bloc/barcode/barcode_bloc.dart';
import 'package:ml_kit_test/bloc/barcode/barcode_event.dart';
import 'package:ml_kit_test/bloc/barcode/barcode_state.dart';
import 'package:ml_kit_test/constant/app_color.dart';
import 'package:ml_kit_test/view/barcode/barcode_history_screen.dart';

class BarcodeScannerScreen extends StatelessWidget {
  const BarcodeScannerScreen({super.key});
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
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: const Text(
          "Barcode Scanner",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        backgroundColor: AppColor.primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BarcodeHistoryScreen(),
                ),
              );
            },
            icon: const Icon(Icons.history, color: Colors.black, size: 30),
          )
        ],
      ),
      body: BlocBuilder<BarcodeScannerBloc, BarcodeScannerState>(
        builder: (context, state) {
          File? image;
          String barcodeText = "Scan barcode from an image or camera";

          if (state is BarcodeLoading) {
            return  Center(child: SizedBox(
              height: 400,
              width: 400,
              child: Lottie.asset('assets/anime.json'),
            ));
          } else if (state is BarcodeLoaded) {
            image = state.imageFile;
            barcodeText = state.barcodeData;
          } else if (state is BarcodeError) {
            barcodeText = state.message;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(image, fit: BoxFit.cover),
                        )
                      : const Center(
                          child:
                              Icon(Icons.image, size: 80, color: Colors.grey),
                        ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        context
                            .read<BarcodeScannerBloc>()
                            .add(PickImageEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      icon: const Icon(Icons.image, color: Colors.white),
                      label: const Text(
                        "Pick Image",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        context
                            .read<BarcodeScannerBloc>()
                            .add(CaptureImageEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      label: const Text(
                        "Use Camera",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          barcodeText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          copyToClipboard(context, barcodeText);
                        },
                        child: const Icon(
                          Icons.copy,
                          color: Colors.blueAccent,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
