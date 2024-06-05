import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famici/feature/calander/blocs/manage_appointment/manage_appointment_bloc.dart';
import 'package:famici/feature/calander/blocs/calendar/calendar_bloc.dart';
import 'package:famici/feature/calander/entities/appointments_entity.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

class ThisWeekAppointments extends StatelessWidget {
  const ThisWeekAppointments({Key? key, VoidCallback? onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConcaveCard(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        height: 380.h,
        width: 500.w,
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
              stops: [0.0, 0.2, 0.8, 1.0],
            ).createShader(rect);
          },
          blendMode: BlendMode.dstOut,
          child: BlocBuilder<CalendarBloc, CalendarState>(
            buildWhen: (
                CalendarState previous,
                CalendarState current,
                ) {
              return previous.appointmentsThisWeek !=
                  current.appointmentsThisWeek ||
                  previous.appointmentsThisWeek != current.appointmentsThisWeek;
            },
            builder: (context, state) {
              if (state.appointmentsThisWeek.isEmpty) {
                return Center(
                  child: Text(
                    "No appointments for this week.",
                    style: FCStyle.textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: FCStyle.mediumFontSize,
                    ),
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: state.appointmentsThisWeek.length,
                  padding: EdgeInsets.symmetric(
                    horizontal: FCStyle.defaultFontSize,
                    vertical: FCStyle.mediumFontSize,
                  ),
                  itemBuilder: (context, index) {
                    DateTime _date =
                        state.appointmentsThisWeek[index].appointmentDate;
                    DateTime _prvDate = DateTime.now();
                    if (index > 0) {
                      _prvDate =
                          state.appointmentsThisWeek[index - 1].appointmentDate;
                    }

                    bool showTopDate =
                        index == 0 || _date.compareTo(_prvDate) > 0;

                    Widget _getDate =
                    getDate(state.appointmentsThisWeek[index], showTopDate);

                    DateTime _time = DateTime(
                      state.appointmentsThisWeek[index].appointmentDate.year,
                      state.appointmentsThisWeek[index].appointmentDate.month,
                      state.appointmentsThisWeek[index].appointmentDate.day,
                      state.appointmentsThisWeek[index].startTime.hour,
                      state.appointmentsThisWeek[index].startTime.minute,
                      state.appointmentsThisWeek[index].startTime.second,
                    );
                    return Column(
                      children: [
                        _getDate,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Icon(
                              Icons.circle,
                              size: FCStyle.smallFontSize,
                              color: state.appointmentsThisWeek[index].color,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              DateFormat("h:mm").format(_time),
                              style: FCStyle.textStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: FCStyle.mediumFontSize,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              DateFormat('a').format(_time),
                              style: FCStyle.textStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: FCStyle.smallFontSize,
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Flexible(
                              child: Text(
                                state
                                    .appointmentsThisWeek[index].appointmentName
                                    .toString(),
                                style: FCStyle.textStyle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}

Widget getDate(Appointment appointment, bool showTopDate) {
  DateTime _date = DateTime.parse(
    appointment.appointmentDate.toString(),
  );

  String _formatted = DateFormat().add_MMMd().format(_date);
  if (!showTopDate) {
    return SizedBox(height: 16.0);
  }
  {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: ColorPallet.kPrimaryTextColor,
              height: 3.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              _formatted,
              style: FCStyle.textStyle,
            ),
          ),
          Expanded(
            child: Container(
              color: ColorPallet.kPrimaryTextColor,
              height: 3.0,
            ),
          ),
        ],
      ),
    );
  }
}
