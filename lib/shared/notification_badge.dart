import 'package:flutter/material.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/config/famici.theme.dart';

class NotificationBadge extends StatelessWidget {
  NotificationBadge({
    Key? key,
    double? height,
    double? width,
    int? count,
    bool? hasShadow,
    this.icon,
    this.color,
  })  : height = height ?? FCStyle.xLargeFontSize,
        width = width ?? FCStyle.xLargeFontSize,
        count = count ?? 0,
        hasShadow = hasShadow ?? false,
        super(key: key);

  final double height;
  final double width;
  final int count;
  final bool hasShadow;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.black,
      elevation: 6,
      shape: BoxShape.circle,
      child: Container(
        // padding: EdgeInsets.all(icon == null ? 12.0 : 8.0),
        constraints: BoxConstraints(
          maxWidth: 40,
          maxHeight: 40,
        ),
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color ?? ColorPallet.kRed,
        ),
        child: icon != null
            ? Icon(
                icon,
                color: Colors.white,
                size: FCStyle.mediumFontSize,
              )
            : Center(
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: FCStyle.mediumFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}
