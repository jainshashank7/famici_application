import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/shared/fc_text_form_field.dart';
import 'package:famici/utils/barrel.dart';

class FCNumSelector extends StatelessWidget {
  const FCNumSelector(
      {Key? key, required this.value, this.onIncrement, this.onDecrement})
      : super(key: key);

  final String value;
  final Function? onIncrement;
  final Function? onDecrement;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NeumorphicButton(
          minDistance: 4,
          style: FCStyle.buttonCardStyle.copyWith(
              shadowLightColor: ColorPallet.kCardShadowColor.withOpacity(0.4),
              boxShape: NeumorphicBoxShape.circle(),
              lightSource: LightSource.top),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            curve: Curves.easeIn,
            height: 54,
            width: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorPallet.kGreen,
            ),
            child: Icon(
              Icons.add,
              size: FCStyle.xLargeFontSize,
              color: ColorPallet.kLightBackGround,
            ),
          ),
          onPressed: () {
            onIncrement!();
          },
        ),
        SizedBox(height: 32),
        SizedBox(
            height: 74,
            width: 74,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorPallet.kTimePickerBorder,
                    width: 4.0,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  color: ColorPallet.kTimePickerBackground),
              child: Text(
                value,
                style: TextStyle(
                    color: ColorPallet.kPrimaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: FCStyle.largeFontSize),
              ),
            )),
        SizedBox(height: 32),
        NeumorphicButton(
          minDistance: 4,
          style: FCStyle.buttonCardStyle.copyWith(
              shadowLightColor: ColorPallet.kCardShadowColor.withOpacity(0.4),
              boxShape: NeumorphicBoxShape.circle(),
              lightSource: LightSource.top),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            curve: Curves.easeIn,
            height: 54,
            width: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorPallet.kGreen,
            ),
            child: Icon(
              Icons.remove,
              size: FCStyle.xLargeFontSize,
              color: ColorPallet.kLightBackGround,
            ),
          ),
          onPressed: () {
            onDecrement!();
          },
        ),
      ],
    );
  }
}
