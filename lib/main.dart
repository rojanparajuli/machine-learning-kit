import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ml_kit_test/main/myapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}