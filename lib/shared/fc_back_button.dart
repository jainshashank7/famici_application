import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famici/core/router/router_delegate.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

class FCBackButton extends StatelessWidget {
  const FCBackButton({
    Key? key,
    this.label,
    this.iconData,
    this.onPressed,
    this.size,
  }) : super(key: key);

  final String? label;
  final IconData? iconData;
  final VoidCallback? onPressed;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return FCMaterialButton(
      elevation: 0,
      color: Colors.white,
      isBorder: true,
      borderColor: ColorPallet.kPrimary,
      defaultSize: true,
      borderRadius: BorderRadius.circular(8),
      onPressed: onPressed ??
          () {
            fcRouter.pop();
          },
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData ?? Icons.arrow_back_ios_rounded,
              color: ColorPallet.kPrimary,
              size: 36.h,
            ),
            SizedBox(width: 2.0),
            Text(
              label ?? CommonStrings.back.tr(),
              style: FCStyle.textStyle.copyWith(
                color: ColorPallet.kPrimary,
                fontSize: 30 * FCStyle.fem,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
