import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ml_kit_test/bloc/document/document_bloc.dart';
import 'package:ml_kit_test/bloc/document/document_event.dart';
import 'package:ml_kit_test/bloc/document/document_state.dart';
import 'package:ml_kit_test/constant/app_color.dart';

class DocsHistory extends StatelessWidget {
  const DocsHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "History",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('docshistory')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: snapshot.data!.docs.map((doc) {
              String text = doc['text'];
              String formattedDate = doc['timestamp'] != null
                  ? doc['timestamp'].toDate().toString()
                  : "Unknown Date";

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  title: Text(text),
                  subtitle: Text(formattedDate),
                  trailing:
                      BlocBuilder<DocumentScannerBloc, DocumentScannerState>(
                    builder: (context, state) {
                      return IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () {
                          final bloc = context.read<DocumentScannerBloc>();
                          bloc.add(SaveText(text));
                        },
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
