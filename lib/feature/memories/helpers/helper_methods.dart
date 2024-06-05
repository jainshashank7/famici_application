import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:famici/feature/memories/views/media/method_selection_add_media.dart';

Future<void> showSelectMethodToAddPhotos(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return MethodSelectionToAddMedia();
    },
  );
}

Future<List<String>> pickImagesFromGallery() async {
  List<String> imagePaths = [];

  final picker = ImagePicker();

  try {
    final pickedImages = await picker.pickMultiImage();
    if (pickedImages != null) {
      for (var image in pickedImages) {
        if (image != null) {
          imagePaths.add(image.path);
        }
      }
    }
  } catch (e) {
    print(e.toString());
  }

  return imagePaths;
}
