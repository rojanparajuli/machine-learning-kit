import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FaceDetailListScreen extends StatelessWidget {
  const FaceDetailListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stored Faces")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('faces').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child:SizedBox(
              height: 400,
              width: 400,
              child: Lottie.asset('assets/anime.json'),
            ));
          }
          final faces = snapshot.data!.docs;
          return ListView.builder(
            itemCount: faces.length,
            itemBuilder: (context, index) {
              final face = faces[index].data();
              return Card(child: ListTile(title: Text(face['name'])));
            },
          );
        },
      ),
    );
  }
}
