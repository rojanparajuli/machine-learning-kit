import 'package:flutter/material.dart';
import 'package:ml_kit_test/view/barcode/barcode_scanner_screen.dart';
import 'package:ml_kit_test/view/digitalInk/digital_ink_recognizer_view.dart';
import 'package:ml_kit_test/view/document/document_recognizer_screen.dart';
import 'package:ml_kit_test/view/face/face_detector_screen.dart';
import 'package:ml_kit_test/view/label/lable_scanner_screen.dart';
import 'package:ml_kit_test/view/languageDetector/language_detector.dart';
import 'package:ml_kit_test/view/languageTranslator/language_translator_view.dart';
import 'package:ml_kit_test/view/pose/pose_detection_screen.dart';
import 'package:ml_kit_test/view/selfiesegment/selfie_segment_screen.dart';
import 'package:ml_kit_test/view/smartReply/smart_reply_screen.dart';
import 'package:ml_kit_test/view/subjectsegment/subject_segment_screen.dart';
import 'package:ml_kit_test/view/text/text_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> itemList = [
    {'title': 'Text Scanner', 'screen': TextScannerScreen(), 'icon': Icons.text_fields},
    {'title': 'Label Scanner', 'screen': LabelScannerScreen(), 'icon': Icons.label_important_outline},
    {'title': 'Barcode Scanner', 'screen': BarcodeScannerScreen(), 'icon': Icons.qr_code},
    {'title': 'Face Detection', 'screen': FaceDetectionScreen(), 'icon': Icons.face},
    {'title': 'Document Scanner', 'screen': DocumentScannerScreen(), 'icon': Icons.document_scanner},
    {'title': 'Digital Ink Recognition', 'screen': DigitalInkView(), 'icon': Icons.edit},
    {'title': 'Pose Detection', 'screen': PoseDetectionScreen(), 'icon': Icons.accessibility},
    {'title': 'Subject Segmentation', 'screen': SubjectSegmentationScreen(), 'icon': Icons.data_object},
    {'title': 'Selfie Segmentation', 'screen': SelfieSegmentationScreen(), 'icon': Icons.person},
    {'title': 'Smart Reply', 'screen': SmartReplyView(), 'icon': Icons.reply},
    {'title': 'Language Detector', 'screen': LanguageDetectorScreen(), 'icon': Icons.language},
    {'title': 'Language Translator', 'screen': LanguageTranslatorScreen(), 'icon': Icons.translate},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Machine Learning Kit",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          _buildGradientBackground(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return _buildAnimatedCard(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => itemList[index]['screen']),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(3, 3)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              itemList[index]['icon'],
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              itemList[index]['title'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
