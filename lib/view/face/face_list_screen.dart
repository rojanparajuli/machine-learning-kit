import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ml_kit_test/constant/app_color.dart';

class FaceDetailListScreen extends StatelessWidget {
  const FaceDetailListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Stored Faces",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        centerTitle: true,
      ),
      body: Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('faces').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: SizedBox(
                height: 400,
                width: 400,
                child: Lottie.asset('assets/anime.json'),
              ));
            }
            final faces = snapshot.data!.docs;
            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: faces.length,
              itemBuilder: (context, index) {
                final face = faces[index].data();
                final faceId = faces[index].id;
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    title: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          TextSpan(
                            text: "ID: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "$faceId\n",
                          ),
                          TextSpan(
                            text: "Name: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "${face['name']}",
                          ),
                          TextSpan(
                            text: "\nFeature: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "${face['features']}",
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
