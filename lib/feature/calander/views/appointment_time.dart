import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famici/feature/calander/blocs/manage_appointment/manage_appointment_bloc.dart';
import 'package:famici/shared/fc_calendar/fc_calendar_screen.dart';
import 'package:famici/shared/fc_calendar/fc_time_picker.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/strings/appointment_strings.dart';
import 'package:easy_localization/src/public_ext.dart';

class AppointmentTimeScreen extends StatefulWidget {
  const AppointmentTimeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AppointmentTimeScreenState createState() => _AppointmentTimeScreenState();
}

class _AppointmentTimeScreenState extends State<AppointmentTimeScreen> {
  late ManageAppointmentBloc _manageAppointment;

  @override
  void initState() {
    _manageAppointment = context.read<ManageAppointmentBloc>();
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageAppointmentBloc, ManageAppointmentState>(
        bloc: _manageAppointment,
        builder: (context, state) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 32, right: 16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppointmentStrings.addStartTime.tr(),
                              style: TextStyle(
                                  color: ColorPallet.kPrimaryTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: FCStyle.largeFontSize),
                            ),
                            SizedBox(height: 16.0),
                            FCTimePicker(
                              dateTime: state.appointmentStartTime,
                              onChange: (date) => _manageAppointment
                                  .add(AppointmentStartTimeChange(date)),
                            )
                          ]),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 32),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppointmentStrings.addEndTime.tr(),
                              style: TextStyle(
                                  color: ColorPallet.kPrimaryTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: FCStyle.largeFontSize),
                            ),
                            SizedBox(height: 16.0),
                            FCTimePicker(
                              dateTime: state.appointmentEndTime,
                              onChange: (date) => _manageAppointment
                                  .add(AppointmentEndTimeChange(date)),
                            )
                          ]),
                    ),
                    flex: 1,
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 32),
                child: Center(
                  child: Text(
                    state.appointmentTimeError
                        ? AppointmentStrings.appointmentTimeErrorMessage.tr()
                        : "",
                    style: FCStyle.textStyle.copyWith(color: ColorPallet.kRed),
                  ),
                ),
              )
            ],
          );
        });
  }
}
