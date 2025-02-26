import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class PoseState {
  List<Object?> get props => [];
}

class PoseInitial extends PoseState {}

class PoseLoading extends PoseState {}

class PoseSuccess extends PoseState {
  final List<Pose> poses;
  PoseSuccess(this.poses);

  @override
  List<Object?> get props => [poses];
}

class PoseFailure extends PoseState {
  final String error;
  PoseFailure(this.error);

  @override
  List<Object?> get props => [error];
}
