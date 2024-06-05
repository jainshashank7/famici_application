import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

class FCSliderMultipleButton extends StatefulWidget {
  const FCSliderMultipleButton({
    Key? key,
    double? width,
    double? height,
    double? borderRadius,
    required this.children,
    num? initialSelected,
  })  : height = height ?? 60,
        width = width ?? 300,
        borderRadius = borderRadius ?? 16,
        _initialSelected = initialSelected ?? 0,
        super(key: key);
  final double height;
  final double width;
  final double borderRadius;
  final List<Map<Widget, VoidCallback>> children;
  final num? _initialSelected;

  @override
  _FCSliderMultipleButtonState createState() => _FCSliderMultipleButtonState();
}

class _FCSliderMultipleButtonState extends State<FCSliderMultipleButton> {
  double get height => widget.height;
  double get width => widget.width;
  double get borderRadius => widget.borderRadius;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          ConcaveCard(
            radius: borderRadius,
            child: SizedBox(
              width: width,
              height: height,
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            left: width * (widget._initialSelected!) / widget.children.length,
            child: FCGradientButton(
              onPressed: () {},
              child: SizedBox(
                width: width / widget.children.length,
                height: height,
              ),
              padding: EdgeInsets.zero,
              borderRadius: borderRadius,
            ),
          ),
          SizedBox(
            width: width,
            height: height,
            child: Row(
              children: [
                for (int i = 0; i < widget.children.length; i++)
                  InkWell(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(borderRadius),
                    onTap: () {
                      widget.children[i].values.first.call();
                    },
                    child: Container(
                      width: width / widget.children.length,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 4.0),
                      child: AnimatedDefaultTextStyle(
                        duration: Duration(milliseconds: 300),
                        style: TextStyle(
                          color: widget._initialSelected == i
                              ? ColorPallet.kLightBackGround
                              : ColorPallet.kPrimaryTextColor.withOpacity(0.6),
                          fontSize: FCStyle.mediumFontSize,
                        ),
                        child: widget.children[i].keys.first,
                      ),
                    ),
                  ),

                // InkWell(
                //   splashColor: Colors.transparent,
                //   hoverColor: Colors.transparent,
                //   highlightColor: Colors.transparent,
                //   borderRadius: BorderRadius.circular(borderRadius),
                //   onTap: () {
                //     if (!sliderOnLeft) {
                //       onLeftTap?.call();
                //     }
                //   },
                //   child: Container(
                //     width: width / 2,
                //     alignment: Alignment.center,
                //     padding: EdgeInsets.only(left: 4.0),
                //     child: AnimatedDefaultTextStyle(
                //       duration: Duration(milliseconds: 300),
                //       style: TextStyle(
                //         color: sliderOnLeft
                //             ? ColorPallet.kLightBackGround
                //             : ColorPallet.kPrimaryTextColor.withOpacity(0.6),
                //         fontSize: FCStyle.mediumFontSize,
                //       ),
                //       child: leftChild ?? SizedBox.shrink(),
                //     ),
                //   ),
                // ),
                // Spacer(),
                // InkWell(
                //   borderRadius: BorderRadius.circular(borderRadius),
                //   splashColor: Colors.transparent,
                //   hoverColor: Colors.transparent,
                //   highlightColor: Colors.transparent,
                //   onTap: () {
                //     if (sliderOnLeft) {
                //       onRightTap?.call();
                //     }
                //   },
                //   child: Container(
                //     width: width / 2,
                //     alignment: Alignment.center,
                //     child: AnimatedDefaultTextStyle(
                //       duration: Duration(milliseconds: 300),
                //       style: TextStyle(
                //         color: !sliderOnLeft
                //             ? ColorPallet.kLightBackGround
                //             : ColorPallet.kPrimaryTextColor.withOpacity(0.6),
                //         fontSize: FCStyle.mediumFontSize,
                //       ),
                //       child: rightChild ?? SizedBox.shrink(),
                //     ),
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
