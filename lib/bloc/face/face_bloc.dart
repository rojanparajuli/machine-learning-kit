import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'face_event.dart';
import 'face_state.dart';

class FaceDetectionBloc extends Bloc<FaceDetectionEvent, FaceDetectionState> {
  FaceDetectionBloc() : super(FaceDetectionInitial()) {
    on<ProcessImageEvent>(_processImage);
    on<AddFaceEvent>(_addFaceToDatabase);
  }

  Future<void> _processImage(
      ProcessImageEvent event, Emitter<FaceDetectionState> emit) async {
    emit(FaceProcessing());

    final inputImage = InputImage.fromFile(event.image);
    final faceFeaturesList = await _extractFaceFeatures(inputImage);

    if (faceFeaturesList.isNotEmpty) {
      for (var faceFeatures in faceFeaturesList) {
        final existingFace = await _checkFaceInDatabase(faceFeatures);

        if (existingFace != null) {
          emit(FaceExists(existingFace)); 
          return;
        } else {
          emit(FaceDetected(event.image, faceFeaturesList.length, true, {
            'features': faceFeatures,
          }));
          return;
        }
      }
    } else {
      emit(FaceDetectionInitial()); 
    }
  }

  Future<Map<String, dynamic>?> _checkFaceInDatabase(
      List<double> newFaceFeatures) async {
    final collection = FirebaseFirestore.instance.collection('faces');
    final snapshot = await collection.get();
    const double similarityThreshold = 0.8;

    for (var doc in snapshot.docs) {
      final faceData = doc.data();
      List<dynamic>? storedFeatures = faceData['features'];

      if (storedFeatures != null) {
        List<double> storedFaceFeatures = List<double>.from(storedFeatures);
        double similarity = cosineSimilarity(newFaceFeatures, storedFaceFeatures);

        if (similarity >= similarityThreshold) {
          return faceData; 
        }
      }
    }
    return null; 
  }

  Future<void> _addFaceToDatabase(
      AddFaceEvent event, Emitter<FaceDetectionState> emit) async {
    if (event.faceData['features'] == null) {
      emit(FaceDetectionInitial());
      return;
    }

    await FirebaseFirestore.instance.collection('faces').add({
      'name': event.name,
      'features': event.faceData['features'],
    });

    emit(FaceAdded());
    emit(FaceDetectionInitial());
  }

  Future<List<List<double>>> _extractFaceFeatures(InputImage inputImage) async {
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(enableContours: true, enableLandmarks: true),
    );

    final faces = await faceDetector.processImage(inputImage);
    faceDetector.close();

    List<List<double>> allFaceFeatures = [];

    for (var face in faces) {
      List<double> features = [];

      if (face.landmarks[FaceLandmarkType.noseBase] != null) {
        features.add(face.landmarks[FaceLandmarkType.noseBase]!.position.x.toDouble());
        features.add(face.landmarks[FaceLandmarkType.noseBase]!.position.y.toDouble());
      }
      if (face.landmarks[FaceLandmarkType.leftEye] != null) {
        features.add(face.landmarks[FaceLandmarkType.leftEye]!.position.x.toDouble());
        features.add(face.landmarks[FaceLandmarkType.leftEye]!.position.y.toDouble());
      }
      if (face.landmarks[FaceLandmarkType.rightEye] != null) {
        features.add(face.landmarks[FaceLandmarkType.rightEye]!.position.x.toDouble());
        features.add(face.landmarks[FaceLandmarkType.rightEye]!.position.y.toDouble());
      }

      if (features.isNotEmpty) {
        allFaceFeatures.add(features);
      }
    }

    return allFaceFeatures;
  }

  double cosineSimilarity(List<double> vec1, List<double> vec2) {
    double dotProduct = 0.0;
    double magnitude1 = 0.0;
    double magnitude2 = 0.0;

    for (int i = 0; i < vec1.length; i++) {
      dotProduct += vec1[i] * vec2[i];
      magnitude1 += vec1[i] * vec1[i];
      magnitude2 += vec2[i] * vec2[i];
    }

    magnitude1 = sqrt(magnitude1);
    magnitude2 = sqrt(magnitude2);

    if (magnitude1 == 0 || magnitude2 == 0) return 0.0;

    return dotProduct / (magnitude1 * magnitude2);
  }
}
