import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famici/feature/calander/blocs/manage_appointment/manage_appointment_bloc.dart';
import 'package:famici/feature/calander/entities/appointments_entity.dart';
import 'package:famici/feature/vitals/screens/manual_entry_screen.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/fc_popup_input/fc_popup_input_screen.dart';
import 'package:famici/shared/fc_select_button.dart';
import 'package:famici/utils/barrel.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:famici/utils/strings/appointment_strings.dart';

class NewAppointmentScreen extends StatefulWidget {
  const NewAppointmentScreen({Key? key, required this.appointmentBloc})
      : super(key: key);

  final ManageAppointmentBloc appointmentBloc;
  @override
  _NewAppointmentScreenState createState() => _NewAppointmentScreenState();
}

class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
  final TextEditingController _controller = TextEditingController();

  ManageAppointmentBloc get _manageAppointment => widget.appointmentBloc;
  @override
  void initState() {
    _controller.text = _manageAppointment.state.appointmentName;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageAppointmentBloc, ManageAppointmentState>(
      bloc: _manageAppointment,
      buildWhen: (
        ManageAppointmentState previous,
        ManageAppointmentState current,
      ) {
        return previous.appointmentType != current.appointmentType ||
            previous.appointmentName != current.appointmentName ||
            previous.appointmentNameError != current.appointmentNameError;
      },
      builder: (context, state) {
        return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(
            state.isEditing
                ? AppointmentStrings.appointmentType.tr()
                : AppointmentStrings.selectAType.tr(),
            style: FCStyle.textHeaderStyle,
          ),
          SizedBox(height: 24.r),
          TypeSelection(),
          SizedBox(height: 64.0),
          Text(
            AppointmentStrings.addAName.tr(),
            style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontWeight: FontWeight.bold,
                fontSize: FCStyle.largeFontSize),
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 64),
                          child: GestureDetector(
                            child: Container(
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
                                  state.appointmentName,
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
                                    title: AppointmentStrings.addAName.tr(),
                                    text: state.appointmentName,
                                    maxLength: 30,
                                    errorMessage: AppointmentStrings
                                        .appointmentNameError
                                        .tr(),
                                  );
                                },
                              ).then((value) {
                                _manageAppointment
                                    .add(AppointmentNameChange(value));
                              })
                            },
                          )),
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 64),
                          child: Text(
                            state.appointmentNameError
                                ? AppointmentStrings.appointmentNameError.tr()
                                : "",
                            style: FCStyle.textStyle.copyWith(
                                color: ColorPallet.kRed,
                                fontSize: FCStyle.defaultFontSize),
                          ))
                    ]),
              )
            ],
          )
        ]);
      },
    );
  }
}

class TypeSelection extends StatelessWidget {
  const TypeSelection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageAppointmentBloc, ManageAppointmentState>(
        builder: (context, state) {
      //   if (state.isEditing) {
      //     return Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         FCSelectButton(
      //           value: state.appointmentType,
      //           groupValue: state.appointmentType,
      //           onChanged: (value) {
      //             context
      //                 .read<ManageAppointmentBloc>()
      //                 .add(AppointmentTypeChange(value));
      //           },
      //           child: Text(
      //             state.appointmentType.name.capitalize(),
      //           ),
      //         ),
      //       ],
      //     );
      //   }

      //   return Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       FCSelectButton(
      //         value: AppointmentType.event,
      //         groupValue: state.appointmentType,
      //         onChanged: (value) {
      //           context
      //               .read<ManageAppointmentBloc>()
      //               .add(AppointmentTypeChange(value));
      //         },
      //         child: Text(
      //           AppointmentStrings.event.tr(),
      //         ),
      //       ),
      //       SizedBox(width: 32.w),
      //       FCSelectButton(
      //         value: AppointmentType.reminder,
      //         groupValue: state.appointmentType,
      //         onChanged: (value) {
      //           context
      //               .read<ManageAppointmentBloc>()
      //               .add(AppointmentTypeChange(value));
      //         },
      //         child: Text(
      //           AppointmentStrings.reminder.tr(),
      //         ),
      //       ),
      //       SizedBox(width: 32.w),
      //       FCSelectButton(
      //         value: AppointmentType.task,
      //         groupValue: state.appointmentType,
      //         onChanged: (value) {
      //           context
      //               .read<ManageAppointmentBloc>()
      //               .add(AppointmentTypeChange(value));
      //         },
      //         child: Text(
      //           AppointmentStrings.task.tr(),
      //         ),
      //       ),
      //     ],
      //   );
      // },
      return Container();
    });
  }
}
