import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ml_kit_test/bloc/barcode/barcode_bloc.dart';
import 'package:ml_kit_test/bloc/digitalInk/digital_ink_cubit.dart';
import 'package:ml_kit_test/bloc/document/document_bloc.dart';
import 'package:ml_kit_test/bloc/face/face_bloc.dart';
import 'package:ml_kit_test/bloc/label/label_bloc.dart';
import 'package:ml_kit_test/bloc/language_detector/language_detector_cubit.dart';
import 'package:ml_kit_test/bloc/language_translator/language_translator_bloc.dart';
import 'package:ml_kit_test/bloc/objectsegment/object_bloc.dart';
import 'package:ml_kit_test/bloc/pose/pose_bloc.dart';
import 'package:ml_kit_test/bloc/selfiesegment/selfie_bloc.dart';
import 'package:ml_kit_test/bloc/smartreply/smart_reply_cubit.dart';
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
        BlocProvider(create: (context) => DocumentScannerBloc()),
        BlocProvider(create: (_) => DigitalInkCubit()),
        BlocProvider(create: (_) => PoseBloc()),
        BlocProvider(create: (context) => SelfieSegmentBloc()),
        BlocProvider(create: (context) => SegmentationBloc()),
        BlocProvider(
      create: (context) => SmartReplyCubit()),
      BlocProvider(
      create: (_) => LanguageDetectorCubit()),
      BlocProvider(
      create: (context) => TranslatorBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
