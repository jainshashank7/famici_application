import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/utils/barrel.dart';

import '../core/router/router_delegate.dart';
import 'barrel.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({
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
      onPressed: onPressed ??
          () async {
            fcRouter.pop();
          },
      color: ColorPallet.kRed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8.0),
        child: SizedBox(
          width: size?.width ?? FCStyle.xLargeFontSize * 2,
          height: size?.height,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconData != null)
                Icon(iconData ?? Icons.arrow_back_ios_rounded),
              if (iconData != null) SizedBox(width: 8.0),
              Text(
                label ?? CommonStrings.cancel.tr(),
                style: FCStyle.textStyle.copyWith(
                  color: ColorPallet.kLightBackGround,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
