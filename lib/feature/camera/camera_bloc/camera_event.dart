part of 'camera_bloc.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();
}

class InitializeCamera extends CameraEvent {
  @override
  List<Object?> get props => [];
}

class ImageCaptured extends CameraEvent {
  @override
  List<Object?> get props => [];
}

class StartRecording extends CameraEvent {
  @override
  List<Object?> get props => [];
}

class StopRecording extends CameraEvent {
  @override
  List<Object?> get props => [];
}

class CaptureDone extends CameraEvent {
  @override
  List<Object?> get props => [];
}

class CameraStopped extends CameraEvent {
  @override
  List<Object?> get props => [];
}

class DiscardCapturedImage extends CameraEvent {
  @override
  List<Object?> get props => [];
}

class SwitchCamera extends CameraEvent {
  @override
  List<Object?> get props => [];
}

class ResetCamera extends CameraEvent {
  @override
  List<Object?> get props => [];
}
