import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

class PopupScaffold extends StatelessWidget {
  const PopupScaffold(
      {Key? key,
      this.child,
      this.backgroundColor,
      this.resizeToAvoidBottomInset,
      this.width,
      this.height,
      this.isLoading = false,
      this.bodyColor,
      this.onTapOutside,
      this.constrained = true})
      : super(key: key);
  final Widget? child;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final double? width;
  final double? height;
  final bool isLoading;
  final Color? bodyColor;
  final Function()? onTapOutside;
  final bool constrained;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? ColorPallet.kDarkBackGround,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? false,
      body: Stack(
        children: [
          Positioned.fill(
              child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10 * FCStyle.fem)),
            child: GestureDetector(
              onTap: onTapOutside,
            ),
          )),
          Center(
            child: Neumorphic(
              style: FCStyle.popupBackground,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0.0,
                  vertical: 0.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                  color: bodyColor ?? ColorPallet.kBackground,
                ),
                width: width ?? MediaQuery.of(context).size.width * 3 / 4,
                height: height ?? MediaQuery.of(context).size.height * 3 / 4,
                constraints: constrained
                    ? const BoxConstraints(
                        minHeight: 500,
                        minWidth: 600,
                      )
                    : null,
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                        gradient: bodyColor != null
                            ? null
                            : LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  ColorPallet.kBackGroundGradientColor1,
                                  ColorPallet.kBackGroundGradientColor2
                                ],
                              ),
                      ),
                    )),
                    Align(
                      alignment: Alignment.center,
                      child: child ?? SizedBox.shrink(),
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
                  child: Center(child: CupertinoActivityIndicator()),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
