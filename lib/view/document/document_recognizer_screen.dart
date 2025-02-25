import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ml_kit_test/bloc/document/document_bloc.dart';
import 'package:ml_kit_test/bloc/document/document_event.dart';
import 'package:ml_kit_test/bloc/document/document_state.dart';
import 'package:ml_kit_test/constant/app_color.dart';
import 'package:ml_kit_test/view/document/docs_history.dart';

class DocumentScannerScreen extends StatelessWidget {
  const DocumentScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DocumentScannerBloc(),
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          ),
          title: const Text(
            "Document Scanner",
            style: TextStyle(
              color: Colors.black, 
              fontSize: 22, 
              fontWeight: FontWeight.w600
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.history, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => DocsHistory())
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: BlocBuilder<DocumentScannerBloc, DocumentScannerState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (state is DocumentScannerExtracted) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          state.image,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    
                    Wrap(
                      spacing: 15,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => context
                              .read<DocumentScannerBloc>()
                              .add(PickImage(ImageSource.camera)),
                          icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                          label: const Text(
                            "Capture Image",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => context
                              .read<DocumentScannerBloc>()
                              .add(PickImage(ImageSource.gallery)),
                          icon: const Icon(Icons.image, color: Colors.white),
                          label: const Text(
                            "Pick from Gallery",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    if (state is DocumentScannerExtracted)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          state.text,
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),

                    const SizedBox(height: 15),

                    if (state is DocumentScannerExtracted)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          final bloc = context.read<DocumentScannerBloc>();
                          bloc.add(SaveText(state.text));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.download, color: Colors.white, size: 20,),
                            SizedBox(width: 10,),
                            const Text(
                              "Save Text as Image",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                    if (state is DocumentScannerSaved)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Text saved successfully!",
                          style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),

                    if (state is DocumentScannerError)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
