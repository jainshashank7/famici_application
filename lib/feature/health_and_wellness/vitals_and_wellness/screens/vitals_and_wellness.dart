import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famici/core/screens/home_screen/widgets/logout_button.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/blocs/vitals_and_wellness_bloc.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/vitals_and_wellness_widgets.dart';
import 'package:famici/shared/fc_slider_button.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/strings/vitals_and_wellness_strings.dart';

import 'package:famici/shared/fc_back_button.dart';
import '../../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../../../../shared/fc_bottom_status_bar.dart';
import '../../../../utils/config/famici.theme.dart';
import '../../../../utils/helpers/events_track.dart';
import 'vitals.dart';
import 'wellness.dart';

class VitalsAndWellnessScreen extends StatefulWidget {
  const VitalsAndWellnessScreen({Key? key}) : super(key: key);

  @override
  _VitalsAndWellnessScreenState createState() =>
      _VitalsAndWellnessScreenState();
}

class _VitalsAndWellnessScreenState extends State<VitalsAndWellnessScreen> {
  @override
  void initState() {
    context.read<VitalsAndWellnessBloc>().add(FetchVitals());
    context.read<VitalsAndWellnessBloc>().add(FetchWellness());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
  builder: (context, stateM) {
    return BlocBuilder<VitalsAndWellnessBloc, VitalsAndWellnessState>(
      builder: (context, state) {
        return FamiciScaffold(
          trailing: context.myDevicesButton(),
          topRight: LogoutButton(),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FCSliderButton(
                borderRadius: (8 * FCStyle.fem),
                height: (60 * FCStyle.fem),
                width: (350 * FCStyle.fem),
                initialLeftSelected: state.showingVitals,
                leftChild: Text(VitalsAndWellnessStrings.vitals.tr()),
                rightChild: Text(VitalsAndWellnessStrings.wellness.tr()),
                onRightTap: () {
                  var properties = TrackEvents().setProperties(
                      fromDate: '',
                      toDate: '',
                      reading: '',
                      readingDateTime: '',
                      vital: '',
                      appointmentDate: '',
                      appointmentTime: '',
                      appointmentCounselors: '',
                      appointmentType: '',
                      callDuration: '',
                      readingType: '');

                  TrackEvents()
                      .trackEvents('Wellness Toggle Clicked', properties);
                  context.read<VitalsAndWellnessBloc>().add(ToggleShowVitals());
                },
                onLeftTap: () {
                  var properties = TrackEvents().setProperties(
                      fromDate: '',
                      toDate: '',
                      reading: '',
                      readingDateTime: '',
                      vital: '',
                      appointmentDate: '',
                      appointmentTime: '',
                      appointmentCounselors: '',
                      appointmentType: '',
                      callDuration: '',
                      readingType: '');

                  TrackEvents()
                      .trackEvents('Vitals Toggle Clicked', properties);
                  context.read<VitalsAndWellnessBloc>().add(ToggleShowVitals());
                },
              ),
            ],
          ),
          bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
          child: Container(
            margin: EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 16),
            decoration: BoxDecoration(
                color: Color.fromARGB(229, 255, 255, 255),
                borderRadius: BorderRadius.circular(10)),
            child: state.showingVitals ? VitalsSection() : WellnessSection(),
          ),
        );
      },
    );
  },
);
  }
}
