import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:famici/feature/camera/view/camera_screen.dart';

Future<void> takePicture(
    BuildContext context, ValueChanged<dynamic> onDone) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return CameraScreen(
        showAfterPreview: true,
        isMultipleTake: false,
      );
    },
  ).then(onDone);
}
