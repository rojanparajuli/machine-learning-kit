import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ml_kit_test/bloc/smartreply/smart_reply_cubit.dart';
import 'package:ml_kit_test/bloc/smartreply/smart_reply_state.dart';
import 'package:ml_kit_test/constant/app_color.dart';



class SmartReplyView extends StatefulWidget {
  const SmartReplyView({super.key});

  @override
  SmartReplyViewState createState() => SmartReplyViewState();
}

class SmartReplyViewState extends State<SmartReplyView> {
  final TextEditingController receivedEditingController = TextEditingController();

  @override
  void dispose() {
    receivedEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Smart Reply', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
      backgroundColor: AppColor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<SmartReplyCubit, SmartReplyState>(
              builder: (context, state) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                    color: Colors.green,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          state.result,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                      border: Border.all(color: Colors.grey[400]!, width: 1),
                    ),
                    child: TextField(
                      controller: receivedEditingController,
                      decoration: const InputDecoration(
                        hintText: 'Type message here...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    context.read<SmartReplyCubit>().addMessage(receivedEditingController.text);
                    receivedEditingController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15),
                    backgroundColor: Colors.green,
                  ),
                  child: const Icon(Icons.send, size: 24, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}