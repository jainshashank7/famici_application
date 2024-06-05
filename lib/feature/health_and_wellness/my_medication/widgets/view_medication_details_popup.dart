import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/src/provider.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/core/router/router_delegate.dart';
import 'package:famici/feature/health_and_wellness/my_medication/blocs/medication_bloc.dart';
import 'package:famici/shared/popup_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/helpers/widget_key.dart';
import 'package:famici/utils/strings/medication_strings.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/blocs/auth_bloc/auth_bloc.dart';
import '../entity/medication.dart';

class MedicationDetailsPopup extends StatefulWidget {
  const MedicationDetailsPopup(
      {Key? key, required this.medication,
      })
      : super(key: key);

  final Medication medication;

  @override
  State<MedicationDetailsPopup> createState() => _MedicationDetailsPopupState();
}

class _MedicationDetailsPopupState extends State<MedicationDetailsPopup> {
  late Timer _timer;
  late DateTime _now = DateTime.now();

  void changeDateTime() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }
  @override
  void initState() {
    changeDateTime();
    super.initState();
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return PopupScaffold(
      height:MediaQuery.of(context).size.height-100,
      width: MediaQuery.of(context).size.width-100,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 60, right: 20, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ShaderMask(
                    //   shaderCallback: (bounds) {
                    //     return RadialGradient(
                    //       center: Alignment.centerLeft,
                    //       radius: 1,
                    //       colors: [ColorPallet.bellIconColor1,ColorPallet.bellIconColor2,ColorPallet.bellIconColor3],
                    //       tileMode: TileMode.mirror,
                    //     ).createShader(bounds);
                    //   },
                    //   child: Image.asset(
                    //     AssetIconPath.bellIcon,
                    //     height: 120,
                    //     width: 120,
                    //   ),
                    // ),
                    Image.asset(
                      AssetIconPath.bellIcon,
                      fit: BoxFit.fitHeight,
                      height: FCStyle.blockSizeVertical*12,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('hh:mm a').format(_now),
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorPallet.kPrimaryTextColor,
                              fontSize: FCStyle.largeFontSize,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          DateFormat.yMMMd().format(_now),
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorPallet.kPrimaryTextColor,
                              fontSize: FCStyle.mediumFontSize,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  key: FCElementID.closeIconButton,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close,
                      color: ColorPallet.kPrimaryTextColor,
                      size: FCStyle.blockSizeVertical*10),
                ),
              ],
            ),
          ),
          CachedNetworkImage(
            height: FCStyle.blockSizeVertical*15,
            fit: BoxFit.fitHeight,
            imageUrl: widget.medication.imgUrl??"",
            //httpHeaders: {"Authorization": "Bearer $token}"},
            placeholder: (context, url) => Container(
              child: Shimmer.fromColors(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.photo,
                          size: FCStyle.blockSizeVertical*15,
                        ),
                      ),
                    ],
                  ),
                  baseColor: ColorPallet.kWhite,
                  highlightColor: ColorPallet.kPrimaryGrey),
            ),
            errorWidget: (context, url, error) => Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.broken_image,
                      size: FCStyle.blockSizeVertical*15,
                      color: ColorPallet.kWhite,
                    ),
                  ),
                ],
              ),
            ),
            fadeInCurve: Curves.easeIn,
            fadeInDuration: const Duration(milliseconds: 100),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.medication.medicationName??"",
            maxLines: 2,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontSize: FCStyle.largeFontSize,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            // MedicationStrings.takeNPillsAtNTime.tr(
            //   args: [
            //     widget.medication.nextDosage?.quantity.value??"",
            //     widget.medication.nextDosage?.time??"",
            //   ],
            // ),
            widget.medication.nextDosage?.popUpLabel??"",
            maxLines: 2,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontSize: FCStyle.largeFontSize+5,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.medication.nextDosage?.detail??"",
            maxLines: 2,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontSize: FCStyle.largeFontSize,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 50,
          ),
          NeumorphicButton(
            style: FCStyle.primaryButtonStyle,
            onPressed: () {
              Navigator.of(context).pop();
              fcRouter.navigate(MedicationDetailsRoute());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: FCStyle.blockSizeHorizontal*25,
                  height: FCStyle.blockSizeVertical*8,
                  child: Center(
                    child: Text(
                      MedicationStrings.viewMedicationDetails.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorPallet.kPrimaryTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: FCStyle.mediumFontSize,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
