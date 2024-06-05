import 'package:badges/badges.dart' as app;
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/core/router/router_delegate.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/blocs/vitals_and_wellness_bloc.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/device_type_icon.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/vital_reading.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/concave_card.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/config/famici.theme.dart';
import 'package:famici/utils/constants/assets_paths.dart';
import 'package:famici/utils/helpers/widget_key.dart';
import 'package:famici/utils/strings/medication_strings.dart';

import '../../notification/blocs/notification_bloc/notification_bloc.dart';
import '../vitals_and_wellness/entity/vital.dart';

extension HealthAndWellnessWidgetsExt on BuildContext {
  Widget yourVitals() {
    return GestureDetector(
      onTap: () {
        fcRouter.navigate(VitalsAndWellnessRoute());
      },
      child: Column(
        children: [
          Text(
            MedicationStrings.yourVitals.tr(),
            style: FCStyle.textStyle,
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: ConcaveCard(
              radius: 30,
              child: BlocBuilder<VitalsAndWellnessBloc, VitalsAndWellnessState>(
                builder: (context, state) {
                  return SizedBox(
                    height: double.infinity,
                    width: FCStyle.screenWidth / 3 + FCStyle.mediumFontSize,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: FCStyle.mediumFontSize,
                        horizontal: FCStyle.largeFontSize,
                      ),
                      child: ShaderMask(
                        shaderCallback: (Rect rect) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              ColorPallet.kBackground,
                              Colors.transparent,
                              Colors.transparent,
                              ColorPallet.kBackground,
                            ],
                            stops: [0.0, 0.1, 0.9, 1.0],
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstOut,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: state.vitalList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, int idx) {
                            return context.yourVitalItem(
                              vital: state.vitalList[idx],
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget yourVitalItem({required Vital vital}) {
    return Container(
      width: FCStyle.screenWidth / 3 + FCStyle.xLargeFontSize,
      height: FCStyle.largeFontSize * 4 + 8,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                vital.name!,
                style: FCStyle.textStyle.copyWith(
                  fontSize: FCStyle.largeFontSize,
                ),
              ),
              Text(
                HomeStrings.dataAsOf.tr(args: [
                  DateFormat()
                      .add_Md()
                      .format(
                        DateTime.fromMillisecondsSinceEpoch(
                          vital.reading.readAt,
                        ),
                      )
                      .toString()
                ]),
                style: FCStyle.textStyle.copyWith(
                  fontSize: FCStyle.defaultFontSize,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  VitalReadingWithoutUnit(
                    vital: vital,
                    forceSingleLine: true,
                    textStyle: FCStyle.textStyle.copyWith(
                      fontSize: FCStyle.xLargeFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    vital.measureUnit!,
                    style: FCStyle.textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          DeviceTypeIcon(
            type: vital.vitalType,
            size: FCStyle.largeFontSize * 2,
          )
        ],
      ),
    );
  }

  Widget myAppointments() {
    return Column(
      children: [
        Text(
          "Appointments",
          style: FCStyle.textStyle,
        ),
        SizedBox(height: 8.0),
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, notification) {
            int count = notification.appointments.length;
            return app.Badge(
              showBadge: count > 0,
              badgeContent: SizedBox(
                width: 50.r,
                height: 50.r,
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                        count > 99
                            ? "99+"
                            : NumberFormat.compact().format(
                                count,
                              ),
                        style: FCStyle.textStyle.copyWith(
                          color: Colors.white,
                          fontSize: 30.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              elevation: 6,
              padding: EdgeInsets.all(4.0),
              child: SizedBox(
                width: FCStyle.xLargeFontSize * 5,
                height: FCStyle.xLargeFontSize * 5,
                child: FCMaterialButton(
                  key: FCElementID.myMedicineButton,
                  borderRadius: BorderRadius.circular(FCStyle.largeFontSize),
                  onPressed: () {
                    fcRouter.navigate(CalenderRoute());
                  },
                  child: Image.asset(AssetIconPath.appointmentsIcon),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget myMedicineButton() {
    return Column(
      children: [
        Text(
          MedicationStrings.myMedicine.tr(),
          style: FCStyle.textStyle,
        ),
        SizedBox(height: 8.0),
        SizedBox(
          width: FCStyle.xLargeFontSize * 5,
          height: FCStyle.xLargeFontSize * 5,
          child: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, notification) {
              int count = notification.medications.length;
              return app.Badge(
                showBadge: count > 0,
                badgeContent: SizedBox(
                  width: 50.r,
                  height: 50.r,
                  child: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          count > 99
                              ? "99+"
                              : NumberFormat.compact().format(count),
                          style: FCStyle.textStyle.copyWith(
                            color: Colors.white,
                            fontSize: 30.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                elevation: 6,
                padding: EdgeInsets.all(4.0),
                child: FCMaterialButton(
                  key: FCElementID.myMedicineButton,
                  borderRadius: BorderRadius.circular(FCStyle.largeFontSize),
                  onPressed: () {
                    fcRouter.navigate(MyMedicineRoute());
                  },
                  child: Image.asset(AssetIconPath.myMedicine),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget connectedDevicesButton() {
    return SizedBox(
      width: FCStyle.largeFontSize * 8 + FCStyle.mediumFontSize,
      height: FCStyle.xLargeFontSize * 4,
      child: FCMaterialButton(
        key: FCElementID.myMedicineButton,
        borderRadius: BorderRadius.circular(FCStyle.largeFontSize),
        onPressed: () {
          fcRouter.navigate(VitalsAndWellnessRoute());
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetIconPath.connectedDevices,
              height: FCStyle.mediumFontSize * 4,
            ),
            SizedBox(
              width: 12.0,
            ),
            Text(
              MedicationStrings.connectedDevices.tr(),
              style:
                  FCStyle.textStyle.copyWith(fontSize: FCStyle.largeFontSize),
            ),
          ],
        ),
      ),
    );
  }

  Widget healthyHabitsButton() {
    return SizedBox(
      width: FCStyle.largeFontSize * 8 + FCStyle.mediumFontSize,
      height: FCStyle.xLargeFontSize * 4,
      child: FCMaterialButton(
        key: FCElementID.myMedicineButton,
        borderRadius: BorderRadius.circular(FCStyle.largeFontSize),
        onPressed: () {
          fcRouter.navigate(HealthyHabitsRoute());
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetIconPath.healthyHabits,
              height: FCStyle.mediumFontSize * 4,
            ),
            SizedBox(
              width: 12.0,
            ),
            Text(
              MedicationStrings.healthyHabits.tr(),
              style:
                  FCStyle.textStyle.copyWith(fontSize: FCStyle.largeFontSize),
            ),
          ],
        ),
      ),
    );
  }
}
