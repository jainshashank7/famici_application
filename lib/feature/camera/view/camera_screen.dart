import 'dart:async';
import 'dart:io';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:camera/camera.dart';
import 'package:device_orientation/device_orientation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/feature/camera/camera_bloc/camera_bloc.dart';

import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

import '../../../core/router/router_delegate.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    Key? key,
    this.onDone,
    this.onCancel,
    this.showAfterPreview,
    this.isMultipleTake,
  }) : super(key: key);

  final ValueChanged<String>? onDone;
  final ValueChanged<String>? onCancel;
  final bool? showAfterPreview;
  final bool? isMultipleTake;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final CameraBloc _cameraBloc = CameraBloc();

  ValueChanged<String> get onDone => widget.onDone ?? (value) {};
  ValueChanged<String> get onCancel => widget.onCancel ?? (value) {};
  bool get isMultipleTake => widget.isMultipleTake ?? false;

  double getScale(BuildContext context, CameraController cameraController) {
    CameraValue camera = cameraController.value;
    Size size = MediaQuery.of(context).size;
    double scale = size.aspectRatio * camera.aspectRatio;
    if (scale < 1) {
      scale = 1 / scale;
    }
    return scale;
  }

  bool get showAfterPreview => widget.showAfterPreview ?? false;

  StreamSubscription? _orientationStream;

  DeviceOrientation _deviceOrientation = deviceOrientation;

  @override
  void initState() {
    _orientationStream = deviceOrientation$.listen((event) {
      setState(() {
        if (event == DeviceOrientation.landscapeRight) {
          _deviceOrientation = DeviceOrientation.landscapeLeft;
        } else if (event == DeviceOrientation.landscapeLeft) {
          _deviceOrientation = DeviceOrientation.landscapeRight;
        } else {
          _deviceOrientation = event;
        }
      });
    });
    // AutoOrientation.fullAutoMode();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    _cameraBloc.add(InitializeCamera());
  }

  @override
  void dispose() {
    // AutoOrientation.landscapeAutoMode(forceSensor: true);
    // _orientationStream?.cancel();

    _cameraBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cameraBloc,
      child: Scaffold(
        backgroundColor: ColorPallet.kBackground,
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<CameraBloc, CameraState>(
          listener: (context, CameraState state) {
            if (state.status == CameraStatus.done) {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeRight,
                DeviceOrientation.landscapeLeft,
              ]);
              onDone.call(state.imagePath);

              state.status = CameraStatus.initial;
              Navigator.of(context).popAndPushNamed(FamilyMemoriesRoute.name,
                  result: state.imagePath);
            } else if (state.status == CameraStatus.captureSuccess) {
              if (!showAfterPreview && !isMultipleTake) {
                _cameraBloc.add(CaptureDone());
              } else if (isMultipleTake) {
                onDone.call(state.imagePath);
                _cameraBloc.add(ResetCamera());
              }
            }
          },
          builder: (context, state) {
            if (state.status == CameraStatus.ready) {
              return Stack(
                children: [
                  Builder(builder: (context) {
                    final size = MediaQuery.of(context).size;
                    final deviceRatio = size.width / size.height;
                    state.cameraController
                        ?.lockCaptureOrientation(_deviceOrientation);
                    return Center(
                      child: Transform.scale(
                        scale: 1,
                        child: AspectRatio(
                          aspectRatio: deviceRatio,
                          child: CameraPreview(
                            state.cameraController!,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              _cameraBloc.add(SwitchCamera());
                            },
                            iconSize: 64,
                            icon: Icon(
                              Icons.flip_camera_ios,
                              color: ColorPallet.kLightBackGround,
                            ),
                          ),
                          SizedBox(width: 48.0),
                          FCGradientButton(
                            onPressed: () {
                              _cameraBloc.add(ImageCaptured());
                            },
                            borderRadius: 64,
                            child: Icon(
                              Icons.camera,
                              color: ColorPallet.kPrimaryText,
                              size: 80.0,
                            ),
                          ),
                          SizedBox(width: 48.0),
                          IconButton(
                            onPressed: () {
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.landscapeRight,
                                DeviceOrientation.landscapeLeft,
                              ]);
                              state.status = CameraStatus.initial;
                              onCancel.call(state.imagePath);
                              Navigator.popAndPushNamed(
                                  context, FamilyMemoriesRoute.name);
                            },
                            iconSize: 64,
                            icon: Icon(
                              Icons.cancel_rounded,
                              color: ColorPallet.kLightBackGround,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            } else if (state.status == CameraStatus.captureSuccess) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(
                            File(state.imagePath),
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              _cameraBloc.add(DiscardCapturedImage());
                            },
                            iconSize: 64,
                            icon: Icon(
                              Icons.refresh,
                              color: ColorPallet.kLightBackGround,
                            ),
                          ),
                          SizedBox(width: 48.0),
                          IconButton(
                            onPressed: () {
                              _cameraBloc.add(CaptureDone());
                            },
                            padding: EdgeInsets.all(16.0),
                            icon: Icon(Icons.check),
                            iconSize: 64,
                            color: ColorPallet.kLightBackGround,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
