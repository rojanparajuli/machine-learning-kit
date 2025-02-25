import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class PoseDetectionScreen extends StatefulWidget {
  const PoseDetectionScreen({super.key});

  @override
  PoseDetectionScreenState createState() => PoseDetectionScreenState();
}

class PoseDetectionScreenState extends State<PoseDetectionScreen> {
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());
  bool _isProcessing = false;
  List<Pose> _poses = [];
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _cameraController = CameraController(_cameras![0], ResolutionPreset.medium);
      await _cameraController!.initialize();
      if (mounted) setState(() {});
    }
  }

  void _processImage(File imageFile) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    
    final inputImage = InputImage.fromFile(imageFile);
    final poses = await _poseDetector.processImage(inputImage);
    
    setState(() {
      _poses = poses;
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _poseDetector.close();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pose Detection')),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: _cameraController != null && _cameraController!.value.isInitialized
                ? CameraPreview(_cameraController!)
                : Center(child: CircularProgressIndicator()),
          ),
          ElevatedButton(
            onPressed: () async {
              final imageFile = await _captureImage(ImageSource.camera);
              if (imageFile != null) {
                _processImage(imageFile);
              }
            },
            child: Text('Capture Image'),
          ),
          ElevatedButton(
            onPressed: () async {
              final imageFile = await _captureImage(ImageSource.gallery);
              if (imageFile != null) {
                _processImage(imageFile);
              }
            },
            child: Text('Pick from Gallery'),
          ),
          if (_poses.isNotEmpty)
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    child: CustomPaint(
                      painter: PosePainter(_poses),
                      child: Container(),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _poses.length,
                      itemBuilder: (context, index) {
                        final pose = _poses[index];
                        return ListTile(
                          title: Text('Pose ${index + 1}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: pose.landmarks.entries.map((entry) {
                              final landmark = entry.value;
                              return Text(
                                '${entry.key.name}: (x: ${landmark.x.toStringAsFixed(2)}, y: ${landmark.y.toStringAsFixed(2)}, z: ${landmark.z.toStringAsFixed(2)})',
                                style: TextStyle(fontSize: 12),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<File?> _captureImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}

class PosePainter extends CustomPainter {
  final List<Pose> poses;
  PosePainter(this.poses);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    for (var pose in poses) {
      for (var landmark in pose.landmarks.values) {
        canvas.drawCircle(Offset(landmark.x, landmark.y), 5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
