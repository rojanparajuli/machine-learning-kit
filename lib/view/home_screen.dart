import 'package:flutter/material.dart';
import 'package:ml_kit_test/constant/app_color.dart';
import 'package:ml_kit_test/view/barcode_scanner_screen.dart';
import 'package:ml_kit_test/view/face_detector_screen.dart';
import 'package:ml_kit_test/view/lable_scanner_screen.dart';
import 'package:ml_kit_test/view/Text/text_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> itemList = [
    {'title': 'Text Scanner', 'screen': TextScannerScreen(), 'icon': Icons.text_fields},
    {'title': 'Label Scanner', 'screen': LabelScannerScreen(), 'icon': Icons.label},
    {'title': 'Barcode Scanner', 'screen': BarcodeScannerScreen(), 'icon': Icons.qr_code},
    {'title': 'Face Detection', 'screen': FaceDetectionScreen(), 'icon': Icons.face},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text("Firebase Machine Learning Kit"),
        centerTitle: true,
      ),
      body: Padding(
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
                color: AppColor.primaryColor.withValues(alpha: 0.8),
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
    );
  }
}
