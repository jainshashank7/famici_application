import 'package:flutter/material.dart';
import 'package:famici/utils/config/color_pallet.dart';

import 'barrel.dart';

class ConcaveCard extends StatelessWidget {
  const ConcaveCard({
    Key? key,
    this.child,
    double? radius,
    this.borderRadius,
    this.inverse,
    this.depth,
  })  : radius = radius ?? 32.0,
        super(key: key);

  final Widget? child;
  final double radius;
  final BorderRadius? borderRadius;
  final bool? inverse;
  final double? depth;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFD8DADC), width: 2),
            color: Colors.white,
            borderRadius: borderRadius ?? BorderRadius.circular(radius),
          ),
          child: Opacity(
            child: child,
            opacity: 0,
          ),
        ),
        Container(
          decoration: ConcaveDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(radius),
              ),
              depth: depth ?? 12,
              colors: [ColorPallet.kCardInnerShadowColor, Colors.black],
              isDark: Theme.of(context).brightness == Brightness.dark,
              inverse: inverse ?? false),
          child: child,
        )
      ],
    );
  }
}
