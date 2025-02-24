import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({super.key});

  @override
  FaceDetectionScreenState createState() => FaceDetectionScreenState();
}

class FaceDetectionScreenState extends State<FaceDetectionScreen> {
  File? _image;
  String _faceInfo = "Detect faces from an image";

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
    final faceDetector = GoogleMlKit.vision.faceDetector();
    final faces = await faceDetector.processImage(inputImage);

    setState(() {
      _faceInfo = faces.isNotEmpty
          ? "Faces Detected: ${faces.length}"
          : "No Faces Detected";
    });

    faceDetector.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Face Detection")),
      body: Column(
        children: [
          _image != null
              ? Image.file(_image!, height: 200)
              : Container(height: 200, color: Colors.grey),
          ElevatedButton(onPressed: _pickImage, child: Text("Pick Image")),
          Text(_faceInfo),
        ],
      ),
    );
  }
}
