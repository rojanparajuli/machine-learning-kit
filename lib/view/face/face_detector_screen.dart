import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ml_kit_test/bloc/face/face_bloc.dart';
import 'package:ml_kit_test/bloc/face/face_event.dart';
import 'package:ml_kit_test/bloc/face/face_state.dart';
import 'package:ml_kit_test/constant/app_color.dart';
import 'package:ml_kit_test/view/face/face_list_screen.dart';

class FaceDetectionScreen extends StatelessWidget {
  FaceDetectionScreen({super.key});

  final TextEditingController nameController = TextEditingController();

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      // ignore: use_build_context_synchronously
      context
          .read<FaceDetectionBloc>()
          .add(ProcessImageEvent(File(pickedFile.path)));
    }
  }

  Future<void> _showAddFaceDialog(BuildContext context, Map<String, dynamic> faceData) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Face"),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(hintText: "Enter Name"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                context.read<FaceDetectionBloc>().add(
                      AddFaceEvent(nameController.text, faceData),
                    );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Name cannot be empty")),
                );
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios_new)),
        title: Text(
          "Face Detection",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.list, color: Colors.black, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FaceDetailListScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<FaceDetectionBloc, FaceDetectionState>(
        builder: (context, state) {
          if (state is FaceProcessing) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FaceDetected) {
            return _buildFaceDetected(context, state);
          } else if (state is FaceExists) {
            return _buildFaceExists(context, state);
          }
          return _buildInitialScreen();
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _pickImage(context, ImageSource.gallery),
            heroTag: 'gallery',
            tooltip: 'Pick from Gallery',
            child: Icon(Icons.image),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => _pickImage(context, ImageSource.camera),
            heroTag: 'camera',
            tooltip: 'Capture from Camera',
            child: Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }

  Widget _buildFaceDetected(BuildContext context, FaceDetected state) {
    return Column(
      children: [
        Center(child: Card(child: Text("Faces Detected: ${state.faceCount}"))),
        if (state.isNewFace)
          ElevatedButton(
            onPressed: () => _showAddFaceDialog(context, state.faceData!),
            child: Text("Add Face"),
          ),
      ],
    );
  }

  Widget _buildFaceExists(BuildContext context, FaceExists state) {
    return Column(
      children: [
        Center(child: Text("Face Found: ${state.faceData['name']}")),
      ],
    );
  }

  Widget _buildInitialScreen() {
    return Center(child: Text("Pick an Image"));
  }
}