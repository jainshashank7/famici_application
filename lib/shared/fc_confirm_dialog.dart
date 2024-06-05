import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/constants/assets_paths.dart';
import 'package:famici/utils/strings/barrel.dart';
import 'package:timer_count_down/timer_count_down.dart';

class FCConfirmDialog extends StatelessWidget {
  FCConfirmDialog(
      {Key? key,
      // this.onSubmit,
      // this.onCancel,
      this.message,
      this.submitText,
      this.cancelText,
      this.isLoading = false,
      this.height,
      this.icon,
      this.subText,
      this.isThirdButton = false,
      this.thirdButtonText,
      this.width,
      this.countDown
      })
      : super(key: key);

  // final VoidCallback? onCancel;
  // final VoidCallback? onSubmit;
  final String? message;
  final String? cancelText;
  final String? submitText;
  final String? subText;
  final bool isLoading;
  final bool isThirdButton;
  final String? thirdButtonText;
  double? height;
  double? width;
  String? icon;
  int? countDown;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, ThemeState themeState) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Center(
                child: Neumorphic(
                  style: FCStyle.popupBackground,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0.0,
                      vertical: 4.0,
                    ),
                    width: width != null
                        ? width
                        : MediaQuery.of(context).size.width * 3 / 4,
                    height: height != null
                        ? height
                        : MediaQuery.of(context).size.height * 3 / 4,
                    constraints: BoxConstraints(
                        // minHeight: 500,
                        // minWidth: 600,
                        ),
                    child: Column(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              icon != null
                                  ? Container(
                                      margin:
                                          EdgeInsets.only(top: 30, bottom: 20),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(10),
                                      height: 140 * FCStyle.fem,
                                      width: 140 * FCStyle.fem,
                                      child: SvgPicture.asset(
                                        icon!,
                                        color: ColorPallet.kPrimary,
                                      ),
                                    )
                                  : Container(
                                      margin:
                                          EdgeInsets.only(top: 30, bottom: 20),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(10),
                                      height: 140 * FCStyle.fem,
                                      width: 140 * FCStyle.fem,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                  color: ColorPallet.kPrimary,
                                                )),
                                          ),
                                          Icon(
                                            Icons.edit,
                                            size: 40,
                                            color: ColorPallet.kPrimary,
                                          )
                                        ],
                                      ),
                                    ),
                              Container(
                                width: width != 0
                                    ? width
                                    : MediaQuery.of(context).size.width * 3 / 4,
                                alignment: Alignment.center,
                                child: Text(
                                  message ??
                                      CommonStrings.cancelConfirmationMessage
                                          .tr(),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                    color: ColorPallet.kPrimaryTextColor,
                                    fontSize: countDown == null ? FCStyle.largeFontSize : FCStyle.largeFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              countDown != null ? Container(
                                width: width != 0
                                    ? width
                                    : MediaQuery.of(context).size.width * 3 / 4,
                                alignment: Alignment.center,
                                child: Countdown(
                                    seconds: countDown ?? 15,
                                    interval: const Duration(milliseconds: 1000),
                                    build: (context , time) {
                                      return Text(
                                        "Time Left: ${time.toInt()} Seconds",
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(
                                          color: ColorPallet.kPrimaryTextColor,
                                          fontSize: FCStyle.mediumFontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  )
                              ) : const SizedBox.shrink(),
                              subText != null
                                  ? SizedBox(
                                      height: 16,
                                    )
                                  : SizedBox.shrink(),
                              subText != null
                                  ? Text(
                                      subText ??
                                          CommonStrings
                                              .cancelConfirmationMessage
                                              .tr(),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: ColorPallet.kPrimaryTextColor,
                                        fontSize: 30 * FCStyle.fem,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              SizedBox(height: countDown == null ? 55.0: 30.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FCMaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    defaultSize: false,
                                    color: ColorPallet.kPrimary,
                                    child: SizedBox(
                                      width: FCStyle.largeFontSize * 4,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Center(
                                          child: Text(
                                            submitText ??
                                                CommonStrings.yes.tr(),
                                            style: FCStyle.textStyle.copyWith(
                                              color: ColorPallet.kPrimaryText,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: FCStyle.xLargeFontSize * 0.5),
                                  isThirdButton
                                      ? FCMaterialButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          defaultSize: false,
                                          color: ColorPallet.kTertiary,
                                          child: SizedBox(
                                            width: FCStyle.largeFontSize * 4,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Center(
                                                child: Text(
                                                  thirdButtonText ??
                                                      CommonStrings.yes.tr(),
                                                  style: FCStyle.textStyle
                                                      .copyWith(
                                                    color: ColorPallet
                                                        .kTertiaryText,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                  SizedBox(width: FCStyle.xLargeFontSize * 0.5),
                                  FCMaterialButton(
                                    elevation: 0,
                                    onPressed: () {
                                      SystemChrome.setPreferredOrientations([
                                        DeviceOrientation.landscapeRight,
                                        DeviceOrientation.landscapeLeft,
                                      ]);
                                      Navigator.pop(context);
                                    },
                                    isBorder: true,
                                    borderColor:
                                        Color.fromARGB(255, 172, 39, 52),
                                    defaultSize: false,
                                    color: Colors.transparent,
                                    child: SizedBox(
                                      width: FCStyle.largeFontSize * 4,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Center(
                                          child: Text(
                                            cancelText ?? CommonStrings.no.tr(),
                                            style: FCStyle.textStyle.copyWith(
                                              color: Color.fromARGB(
                                                  255, 172, 39, 52),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              isLoading
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: ColorPallet.kDarkBackGround.withOpacity(0.6),
                      child: Center(child: CupertinoActivityIndicator()))
                  : SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}
