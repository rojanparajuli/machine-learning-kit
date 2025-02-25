import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ml_kit_test/bloc/digitalInk/digital_ink_cubit.dart';
import 'package:ml_kit_test/bloc/digitalInk/digital_ink_state.dart';
import 'package:ml_kit_test/constant/app_color.dart';

class DigitalInkView extends StatelessWidget {
  const DigitalInkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: const Text(
          "Digital Ink Recognition",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              onPressed: () => context.read<DigitalInkCubit>().clearCanvas(),
              icon:
                  const Icon(Icons.delete_forever, color: Colors.red, size: 40),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<DigitalInkCubit, DigitalInkState>(
                builder: (context, state) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          RenderBox renderBox =
                              context.findRenderObject() as RenderBox;
                          Offset localPosition =
                              renderBox.globalToLocal(details.globalPosition);
                          context
                              .read<DigitalInkCubit>()
                              .addPoint(localPosition);
                        },
                        onPanEnd: (_) =>
                            context.read<DigitalInkCubit>().addBreak(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CustomPaint(
                            painter: SignaturePainter(state.points),
                            size: Size.infinite,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<DigitalInkCubit, DigitalInkState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Recognized Text: ${state.recognizedText}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () =>
                            context.read<DigitalInkCubit>().recognizeInk(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_box,
                              size: 30,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 10),
                            const Text("Recognize",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset?> points;
  SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => true;
}
