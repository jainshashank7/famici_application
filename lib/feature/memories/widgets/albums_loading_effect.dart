import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/config/famici.theme.dart';
import 'package:shimmer/shimmer.dart';

class AlbumsLoadingEffect extends StatelessWidget {
  const AlbumsLoadingEffect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 32.0,
          crossAxisSpacing: 32.0,
          childAspectRatio: 6 / 5,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 24.0,
          horizontal: 96.0,
        ),
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          return NeumorphicButton(
            minDistance: 4,
            padding: EdgeInsets.zero,
            style: FCStyle.buttonCardStyle.copyWith(
                border: NeumorphicBorder.none(),
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(25.0),
                )),
            onPressed: () {},
            child: Stack(
              children: [
                PhysicalModel(
                  color: Colors.black,
                  elevation: 4,
                  child: Container(
                    color: ColorPallet.kGreen,
                    width: double.infinity,
                    height: (MediaQuery.of(context).size.height / 3) * 0.65,
                    child: Container(
                      color: ColorPallet.kSecondaryGrey,
                      child: Shimmer.fromColors(
                          child: Container(
                            child: Icon(
                              Icons.photo,
                              size: FCStyle.blockSizeHorizontal*13,
                            ),
                          ),
                          baseColor: ColorPallet.kPrimaryGrey,
                          highlightColor: ColorPallet.kSecondaryGrey),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: Shimmer.fromColors(
                          child: Container(
                            color: ColorPallet.kLoadingColor,
                            margin: EdgeInsets.only(bottom: 30),
                            width: FCStyle.blockSizeHorizontal*15,
                            height: 20,
                          ),
                          baseColor: ColorPallet.kPrimaryGrey,
                          highlightColor: ColorPallet.kSecondaryGrey),
                    )),
              ],
            ),
          );
        });
  }
}
