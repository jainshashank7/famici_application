import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famici/feature/calander/blocs/manage_appointment/manage_appointment_bloc.dart';
import 'package:famici/feature/calander/entities/appointments_entity.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:famici/utils/strings/appointment_strings.dart';
import 'dart:math' as math;

class AppointmentRecurrenceScreen extends StatefulWidget {
  const AppointmentRecurrenceScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AppointmentRecurrenceScreenState createState() =>
      _AppointmentRecurrenceScreenState();
}

class _AppointmentRecurrenceScreenState
    extends State<AppointmentRecurrenceScreen> {
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
              Text(
                AppointmentStrings.recurrence.tr(),
                style: TextStyle(
                    color: ColorPallet.kPrimaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: FCStyle.largeFontSize),
              ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.black26),
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 0,
                        blurRadius: 16,
                        offset: Offset(0, 0),
                      ),
                    ],
                    color: ColorPallet.kCardBackground,
                    borderRadius: BorderRadius.circular(16)),
                child: DropdownButton<RecurrenceType>(
                  value: state.recurrence,
                  dropdownColor: ColorPallet.kCardBackground,
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Transform.rotate(
                      angle: math.pi / 2,
                      child: Icon(
                        Icons.play_arrow,
                        size: FCStyle.mediumFontSize,
                      ),
                    ),
                  ),
                  elevation: 3,
                  alignment: Alignment.center,
                  focusColor: Colors.transparent,
                  isDense: false,
                  borderRadius: BorderRadius.circular(16),
                  style: FCStyle.textStyle,
                  underline: SizedBox.shrink(),
                  onChanged: (RecurrenceType? value) {
                    if (value != null) {
                      _manageAppointment.add(
                        AppointmentRecurrenceChange(value),
                      );
                    }
                  },
                  items: RecurrenceType.values
                      .map<DropdownMenuItem<RecurrenceType>>(
                    (RecurrenceType value) {
                      return DropdownMenuItem<RecurrenceType>(
                        value: value,
                        child: Text(
                          value.name.toCamelCase(),
                          style: FCStyle.textStyle,
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              SizedBox(height: 64.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FCRadioButton(
                    value: state.allDay,
                    groupValue: true,
                    onChanged: (value) {
                      _manageAppointment.add(AppointmentAllDayToggle());
                    },
                  ),
                  SizedBox(width: 32.0),
                  Text(
                    AppointmentStrings.allDay.tr(),
                    style: TextStyle(
                        color: ColorPallet.kPrimaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: FCStyle.largeFontSize),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
