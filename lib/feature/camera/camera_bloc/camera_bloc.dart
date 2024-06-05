import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:device_orientation/device_orientation.dart';
import 'package:equatable/equatable.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(CameraState.initial()) {
    on<InitializeCamera>(_onInitializeCamera);
    on<ImageCaptured>(_onImageCaptured);
    on<DiscardCapturedImage>(_onCaptureDiscard);
    on<CaptureDone>(_onCaptureDone);
    on<CameraStopped>(_onCameraStopped);
    on<SwitchCamera>(_onSwitchCamera);
    on<ResetCamera>(_onResetCamera);
  }

  StreamSubscription? _orientation;

  void _onInitializeCamera(InitializeCamera event, Emitter emit) async {
    List<CameraDescription> _cameras = await availableCameras();

    CameraController _camera = CameraController(
      _cameras.first,
      ResolutionPreset.high,
    );

    await _camera.initialize();

    // _orientation = deviceOrientation$.listen((event) {
    //   _camera.lockCaptureOrientation(event);
    // });

    emit(state.copyWith(
      status: CameraStatus.ready,
      cameras: _cameras,
      cameraController: _camera,
    ));
  }

  void _onImageCaptured(ImageCaptured event, Emitter emit) async {
    try {
      CameraController _camera = state.cameraController!;
      XFile image = await _camera.takePicture();
      emit(state.copyWith(
        status: CameraStatus.captureSuccess,
        imagePath: image.path,
      ));
    } catch (err) {
      emit(state.copyWith(status: CameraStatus.captureFailure));
    }
  }

  void _onCaptureDone(CaptureDone event, Emitter emit) async {
    try {
      emit(state.copyWith(
        status: CameraStatus.done,
      ));
    } catch (err) {
      emit(state.copyWith(status: CameraStatus.captureFailure));
    }
  }

  void _onCameraStopped(CameraStopped event, Emitter emit) async {
    try {
      CameraController _controller = state.cameraController!;
      _controller.dispose();
      emit(state.copyWith(
        status: CameraStatus.initial,
        cameraController: _controller,
      ));
    } catch (err) {
      emit(state.copyWith(status: CameraStatus.initial));
    }
  }

  void _onCaptureDiscard(DiscardCapturedImage event, Emitter emit) async {
    try {
      emit(state.copyWith(status: CameraStatus.ready, imagePath: ''));
    } catch (err) {
      emit(state.copyWith(status: CameraStatus.captureFailure));
    }
  }

  void _onSwitchCamera(SwitchCamera event, Emitter emit) async {
    try {
      CameraController _camera = state.cameraController!;
      List<CameraDescription> _cameras = state.cameras;

      CameraDescription _otherCamera = _cameras.firstWhere(
        (cam) => cam.name != _camera.description.name,
      );
      CameraController newCameara = CameraController(
        _otherCamera,
        ResolutionPreset.high,
      );
      await newCameara.initialize();

      emit(state.copyWith(
        status: CameraStatus.ready,
        cameraController: newCameara,
      ));
    } catch (err) {
      DebugLogger.error(err.toString());
    }
  }

  void _onResetCamera(ResetCamera event, Emitter emit) async {
    try {
      emit(state.copyWith(
        status: CameraStatus.ready,
      ));
    } catch (err) {
      DebugLogger.error(err.toString());
    }
  }

  @override
  Future<void> close() {
    _orientation?.cancel();
    state.cameraController?.dispose();
    return super.close();
  }
}
