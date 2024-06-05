import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/config/famici.theme.dart';
import 'package:shimmer/shimmer.dart';

class MedicationTypesLoading extends StatelessWidget {
  const MedicationTypesLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.9, crossAxisCount: 2),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: 8,
      itemBuilder: (BuildContext context, int index) {
        return loadingCard();
      },
    );
  }

  static Widget loadingCard() => Padding(
        padding: EdgeInsets.only(bottom: 15, top: 15, right: 15, left: 15),
        child: NeumorphicButton(
          style: FCStyle.buttonCardStyleWithBorderRadius(borderRadius: 20),
          onPressed: null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: FCStyle.blockSizeVertical * 13,
                child: Shimmer.fromColors(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.photo,
                            size: FCStyle.blockSizeVertical * 13,
                          ),
                        ),
                      ],
                    ),
                    baseColor: ColorPallet.kPrimaryGrey,
                    highlightColor: ColorPallet.kBottomStatusBarColor),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: FCStyle.blockSizeHorizontal * 12,
                height: FCStyle.blockSizeVertical * 4,
                color: ColorPallet.kLoadingColor,
              ),
            ],
          ),
        ),
      );
}
