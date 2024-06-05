import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crop_image/crop_image.dart';
import 'package:famici/utils/barrel.dart';

class CropRotateImage extends StatefulWidget {
  final String imageSrc;

  const CropRotateImage({Key? key, required this.imageSrc}) : super(key: key);

  @override
  State<CropRotateImage> createState() => _CropRotateImageState();
}

class _CropRotateImageState extends State<CropRotateImage> {
  final controller = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        "Edit Photo",
        style: TextStyle(
          color: ColorPallet.kPrimaryText,
          fontWeight: FontWeight.w700
        ),
      ),
      centerTitle: true,
      backgroundColor: ColorPallet.kPrimary,
      automaticallyImplyLeading: false,
    ),
    body: Center(
      child: CropImage(
        controller: controller,
        image: widget.imageSrc.contains("https://") ? Image.network(widget.imageSrc): Image.file(File(widget.imageSrc)),
        paddingSize: 25.0,
        alwaysMove: true,
      ),
    ),
    backgroundColor: ColorPallet.kBackground,
    bottomNavigationBar: _buildButtons(),
  );

  Widget _buildButtons() => BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: ColorPallet.kPrimary,
    selectedItemColor: ColorPallet.kPrimaryText,
    unselectedItemColor: ColorPallet.kPrimaryText,
    onTap: (itemNumber){
      if(itemNumber == 0){
        Navigator.of(context).pop();
      }
      else if(itemNumber == 1){
        controller.rotation = CropRotation.up;
        controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
        controller.aspectRatio = 1.0;
      }
      else if(itemNumber == 2){
        _aspectRatios();
      }
      else if(itemNumber == 3){
        _rotateLeft();
      }
      else if(itemNumber == 4){
        _rotateRight();
      }
      else if(itemNumber == 5){
        _finished();
      }
    },
    items: [
      BottomNavigationBarItem(
          icon: Icon(
            Icons.close,
            color: ColorPallet.kPrimaryText,
          ),
          label: "Close"
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.restore_rounded,
            color: ColorPallet.kPrimaryText,
          ),
          label: "Restore"
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.aspect_ratio,
            color: ColorPallet.kPrimaryText,
          ),
          label: "Crop Ratio"
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.rotate_90_degrees_ccw_outlined,
            color: ColorPallet.kPrimaryText,
          ),
          label: "Rotate Left"
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.rotate_90_degrees_cw_outlined,
            color: ColorPallet.kPrimaryText,
          ),
          label: "Rotate Right"
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.done_outlined,
            color: ColorPallet.kPrimaryText,
          ),
          label: "Done"
      ),
    ],
  );

  Future<void> _aspectRatios() async {
    final value = await showDialog<double>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select aspect ratio', textAlign: TextAlign.center,),
          children: [
            // special case: no aspect ratio
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, -1.0),
              child: const Text('free', textAlign: TextAlign.center,),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 1.0),
              child: const Text('square', textAlign: TextAlign.center,),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 2.0),
              child: const Text('2:1', textAlign: TextAlign.center,),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 1 / 2),
              child: const Text('1:2', textAlign: TextAlign.center,),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 4.0 / 3.0),
              child: const Text('4:3', textAlign: TextAlign.center,),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 16.0 / 9.0),
              child: const Text('16:9', textAlign: TextAlign.center,),
            ),
          ],
        );
      },
    );
    if (value != null) {
      controller.aspectRatio = value == -1 ? null : value;
      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
    }
  }

  Future<void> _rotateLeft() async => controller.rotateLeft();

  Future<void> _rotateRight() async => controller.rotateRight();

  Future<void> _finished() async {
    ui.Image croppedImage = await controller.croppedBitmap();
    ByteData? byteData = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? imageData = byteData?.buffer.asUint8List();
    final directory = await getTemporaryDirectory();
    String fileName = "${Random().nextInt(4294967295)}_${Random().nextInt(4294967295)}_${Random().nextInt(4294967295)}";
    final file = File('${directory.path}/cropped_image_$fileName.png');

    await file.writeAsBytes(imageData!);
    Navigator.of(context).pop(file);
  }
}