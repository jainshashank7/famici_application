part of 'camera_bloc.dart';

enum CameraStatus {
  initial,
  ready,
  failure,
  capturing,
  recording,
  captureSuccess,
  recordingSuccess,
  captureFailure,
  recordingFailure,
  done,
}

class CameraState extends Equatable {
  CameraState({
    required this.status,
    required this.cameras,
    required this.cameraController,
    required this.imagePath,
  });
  CameraStatus status;
  final List<CameraDescription> cameras;
  final CameraController? cameraController;
  final String imagePath;

  @override
  List<Object?> get props => [status, cameras, cameraController, imagePath];

  factory CameraState.initial() {
    return CameraState(
      status: CameraStatus.initial,
      cameras: [],
      cameraController: null,
      imagePath: '',
    );
  }

  CameraState copyWith({
    CameraStatus? status,
    List<CameraDescription>? cameras,
    CameraController? cameraController,
    String? imagePath,
  }) {
    return CameraState(
      status: status ?? this.status,
      cameras: cameras ?? this.cameras,
      cameraController: cameraController ?? this.cameraController,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
