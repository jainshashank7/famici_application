import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

class FCSliderButton extends StatefulWidget {
  const FCSliderButton({
    Key? key,
    double? width,
    double? height,
    double? borderRadius,
    this.leftChild,
    this.rightChild,
    this.onLeftTap,
    this.onRightTap,
    this.initialLeftSelected,
  })  : height = height ?? 60,
        width = width ?? 300,
        borderRadius = borderRadius ?? 16,
        super(key: key);
  final double height;
  final double width;
  final double borderRadius;

  final Widget? leftChild;
  final Widget? rightChild;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;

  final bool? initialLeftSelected;

  @override
  _FCSliderButtonState createState() => _FCSliderButtonState();
}

class _FCSliderButtonState extends State<FCSliderButton> {
  bool get sliderOnLeft => widget.initialLeftSelected ?? true;

  double get height => widget.height;
  double get width => widget.width;
  double get borderRadius => widget.borderRadius;

  Widget? get leftChild => widget.leftChild;
  Widget? get rightChild => widget.rightChild;
  VoidCallback? get onLeftTap => widget.onLeftTap;
  VoidCallback? get onRightTap => widget.onRightTap;

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
            depth: 1,
            inverse: true,
            radius: borderRadius,
            child: SizedBox(
              width: width,
              height: height,
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            left: sliderOnLeft ? 0 : width / 2,
            child: FCGradientButton(
              onPressed: () {},
              child: SizedBox(
                width: width / 2,
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
                InkWell(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(borderRadius),
                  onTap: () {
                    if (!sliderOnLeft) {
                      onLeftTap?.call();
                    }
                  },
                  child: Container(
                    width: width / 2,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 4.0),
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: TextStyle(
                          color: sliderOnLeft
                              ? ColorPallet.kPrimaryText
                              : Color(0xFF8F92A1),
                          fontSize: (26 * FCStyle.fem),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'poppins'),
                      child: leftChild ?? SizedBox.shrink(),
                    ),
                  ),
                ),
                Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(borderRadius),
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    if (sliderOnLeft) {
                      onRightTap?.call();
                    }
                  },
                  child: Container(
                    width: width / 2,
                    alignment: Alignment.center,
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: TextStyle(
                          color: !sliderOnLeft
                              ? ColorPallet.kPrimaryText
                              : Color(0xFF8F92A1),
                          fontSize: (26 * FCStyle.fem),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'poppins'),
                      child: rightChild ?? SizedBox.shrink(),
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
