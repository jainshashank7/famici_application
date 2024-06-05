import 'package:flutter/material.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:shimmer/shimmer.dart';

class PhotosLoadingEffect extends StatelessWidget {
  const PhotosLoadingEffect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 16),
      // padding: EdgeInsets.only(
      //     right: 53 * FCStyle.fem,
      //     left: 0,
      //     top: 35 * FCStyle.fem,
      //     bottom: 43 * FCStyle.fem),

      decoration: BoxDecoration(
          color: Color.fromARGB(224, 255, 255, 255),
          borderRadius: BorderRadius.circular(10)),
      child: GridView.builder(
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 3 / 2),
          padding: EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: 96.0,
          ),
          itemBuilder: (
            BuildContext context,
            int index,
          ) {
            return Container(
              color: ColorPallet.kSecondaryGrey,
              child: Shimmer.fromColors(
                  child: Container(
                    child: Icon(
                      Icons.photo,
                      size: 150,
                    ),
                  ),
                  baseColor: ColorPallet.kWhite,
                  highlightColor: ColorPallet.kPrimaryGrey),
            );
          }),
    );
  }
}
