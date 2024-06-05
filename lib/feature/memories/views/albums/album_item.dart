import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/feature/memories/entities/barrel.dart';
import 'package:famici/feature/memories/widgets/image_loading_widgets.dart';
import 'package:famici/utils/barrel.dart';

class AlbumItem extends StatelessWidget {
  const AlbumItem({
    Key? key,
    required this.album,
    this.onPressed,
    this.isSelectable = false,
    this.onSelect,
  }) : super(key: key);

  final Album album;
  final bool isSelectable;
  final VoidCallback? onSelect;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      minDistance: 4,
      padding: EdgeInsets.zero,
      style: FCStyle.buttonCardStyle.copyWith(
          border: NeumorphicBorder.none(),
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(25.0),
          )),
      onPressed: isSelectable ? onSelect : onPressed,
      child: Stack(
        children: [
          PhysicalModel(
            color: Colors.black,
            elevation: 4,
            child: Container(
              color: ColorPallet.kPrimaryGrey,
              width: double.infinity,
              height: isSelectable
                  ? (MediaQuery.of(context).size.height / 3) * 0.5
                  : (MediaQuery.of(context).size.height / 3) * 0.7,
              child: album.memories.isNotEmpty
                  ? Image(
                      image: getImageProvider(album.memories.first.url),
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return ImageLoadingWidgets().photoLoadingIndicator(
                            loadingProgress: loadingProgress, photoSize: FCStyle.blockSizeHorizontal*10);
                      },
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return ImageLoadingWidgets()
                            .photoLoadingError(photoSize: FCStyle.blockSizeHorizontal*10);
                      },
                    )
                  : Icon(
                      Icons.image,
                      color: ColorPallet.bellIconColor1,
                      size: 130,
                    ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              height: (MediaQuery.of(context).size.height / 3) * 0.3,
              child: Center(
                child: Text(
                  album.title ?? '',
                  style: FCStyle.textStyle.copyWith(
                    overflow: TextOverflow.ellipsis,
                    fontSize: FCStyle.mediumFontSize,
                  ),
                ),
              ),
            ),
          ),
          isSelectable
              ? Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 48,
                    height: 48,
                    margin: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: album.isSelected
                          ? ColorPallet.kBrightGreen
                          : ColorPallet.kLightBackGround,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: album.isSelected
                            ? ColorPallet.kBrightGreen
                            : ColorPallet.kBlack,
                        width: 2,
                      ),
                    ),
                    child: album.isSelected
                        ? Icon(
                            Icons.check_rounded,
                            color: ColorPallet.kLightBackGround,
                            size: 32,
                          )
                        : SizedBox.shrink(),
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
