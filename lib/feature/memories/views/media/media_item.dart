import 'dart:io';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/feature/memories/entities/barrel.dart';
import 'package:famici/feature/memories/widgets/image_loading_widgets.dart';
import 'package:famici/utils/barrel.dart';

class MediaItem extends StatelessWidget {
  const MediaItem({
    Key? key,
    this.isSelectable = false,
    required this.media,
    this.onPressed,
    this.onSelect,
  }) : super(key: key);

  final bool isSelectable;
  final FamilyMemory media;
  final VoidCallback? onSelect;
  final VoidCallback? onPressed;

  Widget? syncImage(String? url) {
    if (media.type == MemoryType.photo) {
      StorageType _type = storageType(url ?? '');
      if (_type == StorageType.local) {
        return Image.file(
          File(url!),
          fit: BoxFit.cover,
        );
      } else if (_type == StorageType.network) {
        return Image.network(
          url!,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return ImageLoadingWidgets()
                .photoLoadingIndicator(loadingProgress: loadingProgress);
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return ImageLoadingWidgets().photoLoadingError();
          },
        );
      } else if (_type == StorageType.asset) {
        return Image.asset(
          FCDefaultImage.userProfile,
          fit: BoxFit.cover,
        );
      } else {
        return SizedBox.shrink();
      }
    } else {
      return Image.asset(
        AssetImagePath.welcomeImage,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NeumorphicButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          minDistance: 4,
          style: FCStyle.buttonCardStyle.copyWith(
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(20 * FCStyle.fem)),
            shadowLightColor: Colors.transparent,
            lightSource: LightSource.top,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: ClipRRect(
                    child: syncImage(media.url),
                    borderRadius: BorderRadius.circular(20 * FCStyle.fem),
                  ),
                ),
              ),
              media.type == MemoryType.video
                  ? Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorPallet.kDarkBackGround,
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.play_arrow,
                          color: ColorPallet.kLightBackGround,
                          size: 40,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            onSelect!();
          },
          child: isSelectable
              ? Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: media.isSelected
                          ? ColorPallet.kSecondary
                          : Color.fromARGB(77, 255, 255, 255),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: media.isSelected
                            ? ColorPallet.kSecondary
                            : ColorPallet.kSecondary,
                        width: 3,
                      ),
                    ),
                    child: media.isSelected
                        ? Icon(
                            Icons.check_rounded,
                            color: ColorPallet.kLightBackGround,
                            weight: 700,
                          )
                        : SizedBox.shrink(),
                  ),
                )
              : SizedBox.shrink(),
        )
      ],
    );
  }
}
