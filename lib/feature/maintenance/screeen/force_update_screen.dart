import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famici/shared/barrel.dart';

import 'package:famici/shared/famici_scaffold.dart';

import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../../utils/constants/assets_paths.dart';
import '../../../utils/strings/common_strings.dart';
import '../bloc/maintenance_bloc.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FamiciScaffold(
      toolbarHeight: 0,
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
            Text(
              CommonStrings.updateRequired.tr(),
              style: FCStyle.textHeaderStyle,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: SizedBox(
                width: 900.w,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        CommonStrings.updateRequiredDescription.tr(),
                        style: FCStyle.textStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FCMaterialButton(
              color: ColorPallet.kGreen,
              onPressed: () {
                context
                    .read<MaintenanceBloc>()
                    .add(GoToUpdateFromStoreMaintenanceEvent());
              },
              child: SizedBox(
                height: 60.h,
                width: 200.w,
                child: Center(
                  child: Text(
                    CommonStrings.update.tr(),
                    style: FCStyle.textStyle.copyWith(
                      fontWeight: FontWeight.w900,
                      color: ColorPallet.kWhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
