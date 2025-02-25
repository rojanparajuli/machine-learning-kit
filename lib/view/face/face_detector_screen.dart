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
      // print("Image Picked: ${pickedFile.path}");
      // ignore: use_build_context_synchronously
      context.read<FaceDetectionBloc>().add(ProcessImageEvent(File(pickedFile.path)));
    } else {
      // print("No image selected.");
    }
  }

  Future<void> _showAddFaceDialog(BuildContext context, Map<String, dynamic> faceData) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Face"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Enter Name"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                // print("Adding Face: ${nameController.text}, Data: $faceData"); 
                context.read<FaceDetectionBloc>().add(AddFaceEvent(nameController.text, faceData));
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Name cannot be empty")),
                );
              }
            },
            child: const Text("Add"),
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
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          "Face Detection",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.list, color: Colors.black, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FaceDetailListScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocListener<FaceDetectionBloc, FaceDetectionState>(
        listener: (context, state) {
          // print("New State: $state"); 
        },
        child: BlocBuilder<FaceDetectionBloc, FaceDetectionState>(
          builder: (context, state) {
            // print("Current UI State: $state"); 

            if (state is FaceProcessing) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FaceDetected) {
              return _buildFaceDetected(context, state);
            } else if (state is FaceExists) {
              return _buildFaceExists(context, state);
            }
            return _buildInitialScreen();
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _pickImage(context, ImageSource.gallery),
            heroTag: 'gallery',
            tooltip: 'Pick from Gallery',
            child: const Icon(Icons.image),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => _pickImage(context, ImageSource.camera),
            heroTag: 'camera',
            tooltip: 'Capture from Camera',
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }

  Widget _buildFaceDetected(BuildContext context, FaceDetected state) {
    // print("Face Detected: ${state.faceCount} faces, Data: ${state.faceData}");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Faces Detected: ${state.faceCount}"),
            ),
          ),
          const SizedBox(height: 10),
          if (state.isNewFace && state.faceData != null)
            ElevatedButton(
              onPressed: () => _showAddFaceDialog(context, state.faceData!),
              child: const Text("Add Face"),
            )
          else
            const Text("Face already exists in the database."),
        ],
      ),
    );
  }

  Widget _buildFaceExists(BuildContext context, FaceExists state) {
    // print("Face Exists: ${state.faceData}"); 
    return Center(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Face Found: ${state.faceData['name']}"),
        ),
      ),
    );
  }

  Widget _buildInitialScreen() {
    return const Center(
      child: Text("Pick an Image to Detect Faces", style: TextStyle(fontSize: 18)),
    );
  }
}
