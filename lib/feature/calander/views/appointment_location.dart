import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/feature/calander/blocs/manage_appointment/manage_appointment_bloc.dart';
import 'package:famici/feature/calander/views/appointment_location_map.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/fc_calendar/fc_calendar_screen.dart';
import 'package:famici/shared/fc_popup_input/fc_popup_input_screen.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/strings/appointment_strings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppointmentLocationScreen extends StatefulWidget {
  const AppointmentLocationScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AppointmentLocationScreenState createState() =>
      _AppointmentLocationScreenState();
}

class _AppointmentLocationScreenState extends State<AppointmentLocationScreen> {
  final TextEditingController _locationController = TextEditingController();
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
          _locationController.text = context
                      .read<ManageAppointmentBloc>()
                      .state
                      .location
                      .formattedAddress !=
                  "none"
              ? context
                  .read<ManageAppointmentBloc>()
                  .state
                  .location
                  .formattedAddress
              : "";

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(left: 32, right: 16),
                      child: Text(
                        AppointmentStrings.addLocation.tr(),
                        style: TextStyle(
                          color: ColorPallet.kPrimaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: FCStyle.largeFontSize,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Image(
                      image: AssetImage(
                        AssetIconPath.locationIcon,
                      ),
                      height: FCStyle.xLargeFontSize * 1.7,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Material(
                        borderRadius: BorderRadius.circular(16.0),
                        child: FCTextFormField(
                          onTap: () {
                            fcRouter.pushWidget(AppointmentLocationMapScreen(
                                appointmentBloc: _manageAppointment));
                          },
                          textEditingController: _locationController,
                          maxLines: 1,
                          readOnly: true,
                          hintText: AppointmentStrings.location.tr(),
                          hintFontSize: FCStyle.largeFontSize,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                          child: Image(
                            image: AssetImage(
                              AssetIconPath.mapIcon,
                            ),
                            height: FCStyle.xLargeFontSize * 1.7,
                          ),
                          onTap: () {
                            fcRouter.pushWidget(AppointmentLocationMapScreen(
                                appointmentBloc: _manageAppointment));
                          }))
                ],
              ),
              SizedBox(height: 64.0),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 32, right: 16),
                      child: Text(
                        AppointmentStrings.notes.tr(),
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
                          height: 260.h,
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
                                  style: BorderStyle.solid)),
                          child: Text(
                            state.notes,
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
                              title: AppointmentStrings.notes.tr(),
                              text: state.notes,
                              maxLength: 100,
                            );
                          },
                        ).then((value) {
                          if (value != null && value != "") {
                            _manageAppointment
                                .add(AppointmentNotesChange(value));
                          }
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
