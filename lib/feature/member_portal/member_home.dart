import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famici/feature/member_portal/widgets/appointment_widget.dart';
import 'package:famici/utils/barrel.dart';

import '../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../../core/screens/home_screen/widgets/logout_button.dart';
import '../../shared/fc_back_button.dart';
import '../../shared/fc_bottom_status_bar.dart';
import '../../shared/famici_scaffold.dart';
import '../calander/blocs/calendar/calendar_bloc.dart';
import '../calander/entities/appointments_entity.dart';

class MemberHomeScreen extends StatefulWidget {
  const MemberHomeScreen({Key? key}) : super(key: key);

  @override
  State<MemberHomeScreen> createState() => _MemberHomeScreenState();
}

class _MemberHomeScreenState extends State<MemberHomeScreen> {
  @override
  void initState() {
    context.read<CalendarBloc>().add(FetchMonthAppointments());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
      builder: (context, stateM) {
        return FamiciScaffold(
          bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
          toolbarHeight: 140.h,
          title: Center(
            child: Text(
              'Upcoming Appointments',
              style: FCStyle.textStyle
                  .copyWith(fontSize: 50.sp, fontWeight: FontWeight.w700),
            ),
          ),
          // trailing: _MemoriesTrailingButton(),
          topRight: LogoutButton(),
          leading: FCBackButton(),
          child: Container(
            height: FCStyle.screenHeight * 0.9,
            margin: const EdgeInsets.only(
                right: 20, left: 20, top: 0, bottom: 12),
            decoration: BoxDecoration(
                color: const Color.fromARGB(229, 255, 255, 255),
                borderRadius: BorderRadius.circular(10)),
            child: BlocBuilder<CalendarBloc, CalendarState>(
              buildWhen: (prv, curr) => prv.currentView != curr.currentView,
              builder: (context, state) {
                List<Appointment> appointments = [];
                for (var appointment in state.appointmentsThisWeek) {
                  if (isMeetingDate(appointment)) {
                    appointments.add(appointment);
                  }
                }
                if (appointments.isEmpty) {
                  return Center(
                    child: Text(
                      "You don't have any upcoming appointments!!",
                      style: TextStyle(
                          fontSize: 40 * FCStyle.ffem,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2 * FCStyle.ffem),
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AppointmentWidget(
                        appointment: appointments[index],
                      );
                    });
              },
            ),
          ),
        );
      },
    );
  }

  bool isMeetingDate(Appointment appointment) {
    DateTime apptDate = DateTime.parse(
        DateFormat('yyyy-MM-dd').format(appointment.appointmentDate));

    DateTime endTime = apptDate.add(Duration(
        hours: appointment.endTime.hour,
        minutes: appointment.endTime.minute,
        seconds: appointment.endTime.second,
        milliseconds: appointment.endTime.millisecond));
    DateTime current = DateTime.now();

    if (endTime.isAfter(current)) {
      return true;
    }
    return false;
  }
}
