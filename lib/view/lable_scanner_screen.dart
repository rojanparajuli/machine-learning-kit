import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class LabelScannerScreen extends StatefulWidget {
  const LabelScannerScreen({super.key});

  @override
  LabelScannerScreenState createState() => LabelScannerScreenState();
}

class LabelScannerScreenState extends State<LabelScannerScreen> {
  File? _image;
  List<String> _labels = [];

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
    final imageLabeler = GoogleMlKit.vision.imageLabeler();
    final labels = await imageLabeler.processImage(inputImage);

    setState(() {
      _labels = labels.map((label) => "${label.label} (${label.confidence})").toList();
    });

    imageLabeler.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Label Scanner")),
      body: Column(
        children: [
          _image != null
              ? Image.file(_image!, height: 200)
              : Container(height: 200, color: Colors.grey),
          ElevatedButton(onPressed: _pickImage, child: Text("Pick Image")),
          Expanded(child: ListView(children: _labels.map((l) => Text(l)).toList())),
        ],
      ),
    );
  }
}
