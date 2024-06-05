import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:famici/shared/popup_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/helpers/widget_key.dart';
import 'package:famici/utils/strings/medication_strings.dart';
import 'package:shimmer/shimmer.dart';

class AddMedicationSuccessPopup extends StatelessWidget {
  const AddMedicationSuccessPopup({Key? key}) : super(key: key);

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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                MedicationStrings.success.tr()+"!",
                style: TextStyle(
                  color: ColorPallet.kPrimaryTextColor,
                  fontSize: FCStyle.largeFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: FCStyle.blockSizeVertical*5,
              ),
              Text(
                MedicationStrings.youCreatedANewMedication.tr(),
                style: TextStyle(
                  color: ColorPallet.kPrimaryTextColor,
                  fontSize: FCStyle.largeFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: FCStyle.blockSizeVertical*5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NeumorphicButton(
                    key: FCElementID.yesButton,
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
            ],
          ),
        ],
      ),
    );
  }
}
