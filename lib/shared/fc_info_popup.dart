import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

enum InfoPopupTypes { success, error }

class FCInfoPopup extends StatelessWidget {
  const FCInfoPopup(
      {Key? key,
        required this.type,
        required this.message,
        required this.buttonText})
      : super(key: key);

  final InfoPopupTypes type;
  final String message;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return PopupScaffold(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.close,
                    color: ColorPallet.kPrimaryTextColor, size: 70),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: type == InfoPopupTypes.success
                        ? ColorPallet.kBrightGreen
                        : ColorPallet.kRed,
                  ),
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    type == InfoPopupTypes.success ? Icons.check : Icons.close,
                    color: ColorPallet.kLightBackGround,
                    size: 64,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 48.0),
                  width: MediaQuery.of(context).size.width * 2 / 5,
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: FCStyle.textStyle.copyWith(
                      fontSize: FCStyle.mediumFontSize,
                    ),
                  ),
                ),
                NeumorphicButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: FCStyle.greenButtonStyle,
                  child: Container(
                    width: 120,
                    height: 48.0,
                    alignment: Alignment.center,
                    child: Text(
                      CommonStrings.ok.tr(),
                      style: TextStyle(
                        color: ColorPallet.kBackButtonTextColor,
                        fontSize: FCStyle.mediumFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
