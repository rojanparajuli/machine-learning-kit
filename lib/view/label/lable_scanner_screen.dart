import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ml_kit_test/bloc/label/label_bloc.dart';
import 'package:ml_kit_test/bloc/label/lable_state.dart';
import 'package:ml_kit_test/constant/app_color.dart';
import 'package:ml_kit_test/view/label/lable_history_screen.dart';

class LabelScannerScreen extends StatelessWidget {
  const LabelScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        title: Text(
          "Label Scanner",
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LableHistoryScreen()),
            ),
            icon: Icon(Icons.history, color: Colors.black, size: 28),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<LabelScannerCubit, LabelScannerState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(8),
                  child: state is LabelScannerSuccess
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(state.image,
                              height: 200, fit: BoxFit.cover),
                        )
                      : Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.image,
                            size: 100,
                            color: Colors.grey[600],
                          ),
                        ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          context.read<LabelScannerCubit>().pickImage(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text("Pick Image",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<LabelScannerCubit>().captureImage(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text("Capture Image",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: state is LabelScannerSuccess
                      ? ListView.separated(
                          itemCount: state.labels.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  state.labels[index],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            );
                          },
                        )
                      : state is LabelScannerLoading
                          ? Center(child: CircularProgressIndicator())
                          : Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_outlined,
                                      size: 30, color: Colors.black54),
                                  Text(
                                    "Please Select or Capture Image",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
