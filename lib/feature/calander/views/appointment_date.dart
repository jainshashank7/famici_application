import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famici/feature/calander/blocs/manage_appointment/manage_appointment_bloc.dart';
import 'package:famici/shared/fc_calendar/fc_calendar_screen.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/strings/appointment_strings.dart';
import 'package:easy_localization/src/public_ext.dart';

class AppointmentDateScreen extends StatefulWidget {
  const AppointmentDateScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AppointmentDateScreenState createState() => _AppointmentDateScreenState();
}

class _AppointmentDateScreenState extends State<AppointmentDateScreen> {
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
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 32, right: 16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppointmentStrings.selectADate.tr(),
                          style: TextStyle(
                              color: ColorPallet.kPrimaryTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: FCStyle.largeFontSize),
                        ),
                        SizedBox(height: 16.0),
                        FCCalendar(
                          previousDatesDisable: true,
                          dateTime: state.appointmentDate,
                          onChange: (date) => _manageAppointment
                              .add(AppointmentDateChange(date)),
                        )
                      ]),
                ),
                flex: 3,
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
            ],
          );
        });
  }
}
