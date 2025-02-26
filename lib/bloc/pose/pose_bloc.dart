import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'pose_event.dart';
import 'pose_state.dart';

class PoseBloc extends Bloc<PoseEvent, PoseState> {
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());

  PoseBloc() : super(PoseInitial()) {
    on<CaptureImage>(_onCaptureImage);
  }

  Future<void> _onCaptureImage(
      CaptureImage event, Emitter<PoseState> emit) async {
    emit(PoseLoading());
    try {
      final inputImage = InputImage.fromFile(event.image);
      final poses = await _poseDetector.processImage(inputImage);
      emit(PoseSuccess(poses));
    } catch (e) {
      emit(PoseFailure("Failed to process image"));
    }
  }

  @override
  Future<void> close() {
    _poseDetector.close();
    return super.close();
  }
}
