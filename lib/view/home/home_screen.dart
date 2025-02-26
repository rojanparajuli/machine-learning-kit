import 'package:flutter/material.dart';
import 'package:ml_kit_test/constant/app_color.dart';
import 'package:ml_kit_test/view/barcode/barcode_scanner_screen.dart';
import 'package:ml_kit_test/view/digitalInk/digital_ink_recognizer_view.dart';
import 'package:ml_kit_test/view/document/document_recognizer_screen.dart';
import 'package:ml_kit_test/view/face/face_detector_screen.dart';
import 'package:ml_kit_test/view/label/lable_scanner_screen.dart';
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
    {
      'title': 'Text Scanner',
      'screen': TextScannerScreen(),
      'icon': Icons.text_fields
    },
    {
      'title': 'Label Scanner',
      'screen': LabelScannerScreen(),
      'icon': Icons.label_important_outline
    },
    {
      'title': 'Barcode Scanner',
      'screen': BarcodeScannerScreen(),
      'icon': Icons.qr_code
    },
    {
      'title': 'Face Detection',
      'screen': FaceDetectionScreen(),
      'icon': Icons.face
    },
    {
      'title': 'Document Scanner',
      'screen': DocumentScannerScreen(),
      'icon': Icons.document_scanner
    },
    {
      'title': 'Digital Ink Recognition',
      'screen': DigitalInkView(),
      'icon': Icons.edit
    },
    {
      'title': 'Pose Detection',
      'screen': PoseDetectionScreen(),
      'icon': Icons.accessibility
    },
     {
      'title': 'subject segmentation',
      'screen': SubjectSegmentationScreen(),
      'icon': Icons.data_object
    },
      {
      'title': 'Selfie segmentation',
      'screen': SelfieSegmentationScreen(),
      'icon': Icons.person
    },
      {
      'title': 'Smart Reply',
      'screen': SmartReplyView(),
      'icon': Icons.reply
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text(
          "Machine Learning Kit",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.1,
            child: Image.asset(
              'assets/logo-vertical.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.7,
              ),
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => itemList[index]['screen'],
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          itemList[index]['icon'],
                          size: 50,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          itemList[index]['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
