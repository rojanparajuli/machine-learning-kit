import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ml_kit_test/bloc/objectsegment/object_bloc.dart';
import 'package:ml_kit_test/bloc/objectsegment/object_event.dart';
import 'package:ml_kit_test/bloc/objectsegment/object_state.dart';
import 'package:ml_kit_test/constant/app_color.dart';

class SubjectSegmentationScreen extends StatelessWidget {
  const SubjectSegmentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Subject Segmentation',
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<SegmentationBloc, SegmentationState>(
        builder: (context, state) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: state is SegmentationSuccess
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(state.selectedImage,
                                    fit: BoxFit.cover),
                              ),
                              CustomPaint(
                                size: Size.infinite,
                                painter: MaskPainter(state.maskImage),
                              ),
                            ],
                          )
                        : state is SegmentationLoading
                            ? const CircularProgressIndicator()
                            : state is SegmentationError
                                ? Text(state.message,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 16))
                                : const Text(
                                    "Pick an image to start segmentation",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton(
                        icon: Icons.image,
                        label: "Gallery",
                        onTap: () => context
                            .read<SegmentationBloc>()
                            .add(PickImageEvent(ImageSource.gallery))),
                    const SizedBox(width: 16),
                    _buildButton(
                        icon: Icons.camera,
                        label: "Camera",
                        onTap: () => context
                            .read<SegmentationBloc>()
                            .add(PickImageEvent(ImageSource.camera))),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        elevation: 5,
      ),
      icon: Icon(icon, size: 24 , color: Colors.white),
      label: Text(label, style: const TextStyle(fontSize: 16)),
      onPressed: onTap,
    );
  }
}

class MaskPainter extends CustomPainter {
  final ui.Image maskImage;

  MaskPainter(this.maskImage);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..filterQuality = FilterQuality.high
      ..blendMode = BlendMode.srcATop;

    final srcRect = Rect.fromLTWH(
        0, 0, maskImage.width.toDouble(), maskImage.height.toDouble());
    final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(maskImage, srcRect, dstRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
