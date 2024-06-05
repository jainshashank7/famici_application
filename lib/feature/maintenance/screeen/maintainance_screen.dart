import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rive/rive.dart';
import 'package:famici/shared/famici_scaffold.dart';

import '../../../utils/barrel.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FamiciScaffold(
      toolbarHeight: 0,
      leading: const SizedBox.shrink(),
      appbarBackground: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: FCStyle.blockSizeVertical * 3),
              child: Image.asset(
                AssetImagePath.fcLogoDark,
                height: FCStyle.blockSizeVertical * 17,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 200.h,
              width: 200.h,
              padding: EdgeInsets.all(24.sp),
              child: const RiveAnimation.asset(AnimationPath.underMaintenance),
            ),
            Container(
              padding: EdgeInsets.all(16.sp),
              child: Text(
                CommonStrings.underMaintenance.tr(),
                style: FCStyle.textHeaderStyle,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.sp),
              child: SizedBox(
                width: 900.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        CommonStrings.underMaintenanceDescription.tr(),
                        style: FCStyle.textStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
