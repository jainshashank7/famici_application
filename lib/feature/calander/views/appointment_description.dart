import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:famici/feature/calander/blocs/manage_appointment/manage_appointment_bloc.dart';
import 'package:famici/feature/calander/views/appointment_location_map.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/fc_calendar/fc_calendar_screen.dart';
import 'package:famici/shared/fc_popup_input/fc_popup_input_screen.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/strings/appointment_strings.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppointmentDescriptionScreen extends StatefulWidget {
  const AppointmentDescriptionScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AppointmentDescriptionScreenState createState() =>
      _AppointmentDescriptionScreenState();
}

class _AppointmentDescriptionScreenState
    extends State<AppointmentDescriptionScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  late ManageAppointmentBloc _manageAppointment;

  @override
  void initState() {
    _manageAppointment = context.read<ManageAppointmentBloc>();
    _descriptionController.text =
        context.read<ManageAppointmentBloc>().state.description;
    super.initState();
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
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(left: 32, right: 16),
                      child: Text(
                        AppointmentStrings.taskDescription.tr(),
                        style: TextStyle(
                            color: ColorPallet.kPrimaryTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: FCStyle.largeFontSize),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: GestureDetector(
                      child: Container(
                          height: 200,
                          padding: EdgeInsets.symmetric(
                            vertical: FCStyle.blockSizeVertical * 3.3,
                            horizontal: FCStyle.blockSizeHorizontal * 2,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              border: Border.all(
                                width: 4,
                                color: ColorPallet.kGrey,
                                style: BorderStyle.solid,
                              )),
                          child: Text(
                            state.description,
                            style: TextStyle(
                              fontSize: FCStyle.mediumFontSize,
                              color: ColorPallet.kPrimaryColor,
                            ),
                          )),
                      onTap: () => {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return FCPopupInput(
                              title: AppointmentStrings.taskDescription.tr(),
                              text: state.description,
                              maxLength: 100,
                            );
                          },
                        ).then((value) {
                          _manageAppointment
                              .add(AppointmentDescriptionChange(value));
                        })
                      },
                    ),
                  ))
                ],
              ),
            ],
          );
        });
  }
}
