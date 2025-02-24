import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ml_kit_test/bloc/barcode/barcode_bloc.dart';
import 'package:ml_kit_test/bloc/face/face_bloc.dart';
import 'package:ml_kit_test/bloc/label/label_bloc.dart';
import 'package:ml_kit_test/bloc/text/text_scanner_bloc.dart';
import 'package:ml_kit_test/bloc/text/text_scanner_event.dart';
import 'package:ml_kit_test/view/home/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TextScannerBloc()),
        BlocProvider(create: (_) => TextScannerBloc()..add(LoadHistoryEvent())),
        BlocProvider(create: (context) => LabelScannerCubit()),
        BlocProvider(create: (context) => BarcodeScannerBloc()),
        BlocProvider(create: (context) => FaceDetectionBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
