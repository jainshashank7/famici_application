import 'package:flutter/cupertino.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/helpers/widget_key.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:famici/utils/strings/appointment_strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarButtons {}

extension CalendarScreenButtons on BuildContext {
  Widget createAppointmentButton({VoidCallback? onPressed}) {
    return FCMaterialButton(
      key: FCElementID.calendarCreateAppointmentButton,
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                AppointmentStrings.createAppointment.tr(),
                textAlign: TextAlign.left,
                style: FCStyle.textStyle.copyWith(fontSize: 30.sp),
              ),
            )
          ],
        ),
      ),
    );
  }
}
