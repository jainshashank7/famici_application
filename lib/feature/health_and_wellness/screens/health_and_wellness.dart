import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famici/core/screens/home_screen/widgets/logout_button.dart';
import 'package:famici/feature/app_info/app_info_bloc/app_info_cubit.dart';
import 'package:famici/feature/health_and_wellness/healthy_habits/blocs/healthy_habits_bloc.dart';
import 'package:famici/feature/health_and_wellness/widgets/helth_and_wellness_widgets.dart';
import 'package:famici/shared/fc_back_button.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/strings/medication_strings.dart';

class HealthAndWellnessScreen extends StatefulWidget {
  const HealthAndWellnessScreen({Key? key}) : super(key: key);

  @override
  _HealthAndWellnessScreenState createState() =>
      _HealthAndWellnessScreenState();
}

class _HealthAndWellnessScreenState extends State<HealthAndWellnessScreen> {
  @override
  void initState() {
    context.read<HealthyHabitsBloc>().add(FetchCategoriesEvent());
    context.read<AppInfoCubit>().fetchAppInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FamiciScaffold(
        toolbarHeight: 140.h,
        title: Center(
          child: Text(
            MedicationStrings.healthAndMedications.tr(),
            style: TextStyle(
              color: ColorPallet.kPrimaryTextColor,
              fontSize: FCStyle.xLargeFontSize,
            ),
          ),
        ),
        leading: FCBackButton(
          label: CommonStrings.menu.tr(),
        ),
        topRight: const LogoutButton(),
        //trailing: context.howDoYouFeelTodayButton(onPressed: () {}),
        child: Padding(
          padding: EdgeInsets.only(
            right: FCStyle.defaultFontSize,
            top: FCStyle.mediumFontSize,
            bottom: FCStyle.xLargeFontSize,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(flex: 3, child: context.yourVitals()),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    context.myAppointments(),
                    context.connectedDevicesButton()
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    context.myMedicineButton(),
                    context.healthyHabitsButton(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
