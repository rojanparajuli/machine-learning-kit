import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ml_kit_test/constant/app_color.dart';

class LableHistoryScreen extends StatelessWidget {
  const LableHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new)),
        title: Text(
          "History",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('label_history')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: SizedBox(
                    height: 400,
                    width: 400,
                    child: Lottie.asset('assets/anime.json')));
          }
          return ListView(
            padding: EdgeInsets.all(12),
            children: snapshot.data!.docs.map((doc) {
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  title: Text(doc['labels'].join(", ")),
                  subtitle: Text(doc['timestamp'].toDate().toString()),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
