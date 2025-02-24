import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:ml_kit_test/bloc/text/text_scanner_bloc.dart';
import 'package:ml_kit_test/bloc/text/text_scanner_event.dart';
import 'package:ml_kit_test/bloc/text/text_scanner_state.dart';
import 'package:ml_kit_test/constant/app_color.dart';

class TextHistory extends StatefulWidget {
  const TextHistory({super.key});

  @override
  State<TextHistory> createState() => _TextHistoryState();
}

class _TextHistoryState extends State<TextHistory> {
  @override
  void initState() {
    super.initState();
    context.read<TextScannerBloc>().add(LoadHistoryEvent());
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Copied to clipboard"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: AppColor.primaryColor,
        title: Text(
          "History",
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/logo.png',
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          BlocBuilder<TextScannerBloc, TextScannerState>(
            builder: (context, state) {
              if (state is TextScannerLoading) {
                return Center(child: SizedBox(
                  height: 400,
                  width: 400,
                  child: Lottie.asset('assets/anime.json'),
                ));
              } else if (state is TextScannerHistoryLoaded) {
                return ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: state.history.length,
                  itemBuilder: (context, index) => Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      title: Text(
                        state.history[index],
                        style: TextStyle(fontSize: 16, color: Colors.black87, ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.copy, color: Colors.blueAccent),
                        onPressed: () => copyToClipboard(state.history[index]),
                      ),
                    ),
                  ),
                );
              } else if (state is TextScannerError) {
                return Center(child: Text(state.message));
              } else {
                return Center(child: Text("No history available."));
              }
            },
          ),
        ],
      ),
    );
  }
}
