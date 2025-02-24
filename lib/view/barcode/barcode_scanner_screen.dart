import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  BarcodeScannerScreenState createState() => BarcodeScannerScreenState();
}

class BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  File? _image;
  String _barcodeData = "Scan barcode from an image";

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
      _processImage(File(pickedFile.path));
    }
  }

  Future<void> _processImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    // ignore: deprecated_member_use
    final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
    final barcodes = await barcodeScanner.processImage(inputImage);

    setState(() {
      if (barcodes.isNotEmpty) {
        _barcodeData = barcodes.first.displayValue ?? "No Data";
      } else {
        _barcodeData = "No Barcode Found";
      }
    });

    barcodeScanner.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Barcode Scanner")),
      body: Column(
        children: [
          _image != null
              ? Image.file(_image!, height: 200)
              : Container(height: 200, color: Colors.grey),
          ElevatedButton(onPressed: _pickImage, child: Text("Pick Image")),
          Text(_barcodeData),
        ],
      ),
    );
  }
}
