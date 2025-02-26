import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:ml_kit_test/bloc/pose/pose_bloc.dart';
import 'package:ml_kit_test/bloc/pose/pose_event.dart';
import 'package:ml_kit_test/bloc/pose/pose_state.dart';
import 'package:ml_kit_test/constant/app_color.dart';

class PoseDetectionScreen extends StatefulWidget {
  const PoseDetectionScreen({super.key});

  @override
  PoseDetectionScreenState createState() => PoseDetectionScreenState();
}

class PoseDetectionScreenState extends State<PoseDetectionScreen> {
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
      _cameraController =
          CameraController(_cameras![0], ResolutionPreset.medium);
      await _cameraController!.initialize();
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: const Text(
          'Pose Detection',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: _cameraController != null &&
                      _cameraController!.value.isInitialized
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          CameraPreview(_cameraController!),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "Live Camera",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _customButton(
                  label: "Capture Image",
                  icon: Icons.camera_alt,
                  onPressed: () async {
                    final imageFile = await _captureImage(ImageSource.camera);
                    if (imageFile != null) {
                      // ignore: use_build_context_synchronously
                      context.read<PoseBloc>().add(CaptureImage(imageFile));
                    }
                  },
                ),
                _customButton(
                  label: "Pick from Gallery",
                  icon: Icons.image,
                  onPressed: () async {
                    final imageFile = await _captureImage(ImageSource.gallery);
                    if (imageFile != null) {
                      // ignore: use_build_context_synchronously
                      context.read<PoseBloc>().add(CaptureImage(imageFile));
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: BlocBuilder<PoseBloc, PoseState>(
                builder: (context, state) {
                  if (state is PoseLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PoseSuccess) {
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            itemCount: state.poses.length,
                            itemBuilder: (context, index) {
                              final pose = state.poses[index];
                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.only(bottom: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pose ${index + 1}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ...pose.landmarks.entries.map((entry) {
                                        final landmark = entry.value;
                                        return Text(
                                          '${entry.key.name}: (x: ${landmark.x.toStringAsFixed(2)}, y: ${landmark.y.toStringAsFixed(2)}, z: ${landmark.z.toStringAsFixed(2)})',
                                          style: const TextStyle(fontSize: 12),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else if (state is PoseFailure) {
                    return Center(
                      child: Text(
                        state.error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const Center(
                    child: Text(
                      "No pose detected",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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

  Widget _customButton(
      {required String label,
      required IconData icon,
      required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      label: Text(label, style: const TextStyle(fontSize: 14)),
    );
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
