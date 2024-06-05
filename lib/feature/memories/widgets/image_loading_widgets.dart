import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/config/famici.theme.dart';

class ImageLoadingWidgets {
  Widget photoLoadingIndicator(
      {required ImageChunkEvent loadingProgress, double? photoSize}) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Container(
            color: ColorPallet.kSecondaryGrey,
            child: Shimmer.fromColors(
                child: Container(
                  child: Icon(
                    Icons.photo,
                    size: photoSize ?? FCStyle.blockSizeHorizontal*10,
                  ),
                ),
                baseColor: ColorPallet.kWhite,
                highlightColor: ColorPallet.kPrimaryGrey),
          ),
          Align(
            child: SizedBox(
              width: FCStyle.blockSizeHorizontal*5,
              height: FCStyle.blockSizeHorizontal*5,
              child: CircularProgressIndicator(
                strokeWidth: 8,
                color: ColorPallet.kPrimaryTextColor.withOpacity(0.5),
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget photoLoadingError({double? photoSize}) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Container(
            color: ColorPallet.kSecondaryGrey,
            child: Container(
              child: Icon(
                Icons.broken_image,
                color: ColorPallet.kPrimaryGrey,
                size: photoSize ?? FCStyle.blockSizeHorizontal*10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
