part of 'barrel.dart';

class AppointmentsWidget extends StatefulWidget {
  const AppointmentsWidget({Key? key}) : super(key: key);

  @override
  State<AppointmentsWidget> createState() => _AppointmentsWidgetState();
}

class _AppointmentsWidgetState extends State<AppointmentsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          0 * FCStyle.fem, 0 * FCStyle.fem, 0 * FCStyle.fem, 16 * FCStyle.fem),
      padding: EdgeInsets.fromLTRB(23.26 * FCStyle.fem, 25 * FCStyle.fem,
          21 * FCStyle.fem, 3 * FCStyle.fem),
      width: 375 * FCStyle.fem,
      // height: 470 * FCStyle.fem,

      decoration: BoxDecoration(
        color: const Color(0xe5ffffff),
        borderRadius: BorderRadius.circular(10 * FCStyle.fem),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0 * FCStyle.fem, 0 * FCStyle.fem,
                  90 * FCStyle.fem, 14.15 * FCStyle.fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                        0 * FCStyle.fem, 16.74 * FCStyle.fem, 0 * FCStyle.fem),
                    width: 35 * FCStyle.fem,
                    height: 36.85 * FCStyle.fem,
                    child: SvgPicture.asset(AssetIconPath.appointmentIcon,
                        width: 35 * FCStyle.fem,
                        height: 36.85 * FCStyle.fem,
                        color: ColorPallet.kBlack),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                        0 * FCStyle.fem, 0 * FCStyle.fem, 0.85 * FCStyle.fem),
                    child: Text(
                      'Appointments',
                      style: TextStyle(
                        fontSize: 30 * FCStyle.ffem,
                        fontWeight: FontWeight.w700,
                        height: 1 * FCStyle.ffem / FCStyle.fem,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: 330 * FCStyle.fem,
                child: BlocBuilder<CalendarBloc, CalendarState>(
                  buildWhen: (prev, cur) =>
                      prev.appointmentsThisWeek.length !=
                          cur.appointmentsThisWeek.length ||
                      prev.isLoadingThisWeekAppointments !=
                          cur.isLoadingThisWeekAppointments ||
                      prev.remindersThisWeek != cur.remindersThisWeek ||
                      prev.activityReminderThisWeek !=
                          cur.activityReminderThisWeek,
                  builder: (context, calendarState) {
                    if (calendarState.isLoadingThisWeekAppointments) {
                      return LoadingScreen(
                        height: FCStyle.xLargeFontSize * 2,
                        width: FCStyle.xLargeFontSize * 2,
                      );
                    }
                    if (calendarState.appointmentsThisWeek.isEmpty &&
                        calendarState.remindersThisWeek.isEmpty &&
                        calendarState.activityReminderThisWeek.isEmpty) {
                      return Center(
                        child: Text(
                          "No appointments for today",
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
                    List<CalendarItem> combinedList = [];

                    combinedList.addAll(
                        calendarState.appointmentsThisWeek.map((appointment) {
                      return CalendarItem(
                          DateTime(
                            appointment.appointmentDate.year,
                            appointment.appointmentDate.month,
                            appointment.appointmentDate.day,
                            appointment.startTime.hour,
                            appointment.startTime.minute,
                          ),
                          buildAppointmentWidget(appointment));
                    }));

                    combinedList
                        .addAll(calendarState.remindersThisWeek.map((reminder) {
                      return CalendarItem(
                          reminder.startTime, buildReminderWidget(reminder));
                    }));

                    combinedList.addAll(calendarState.activityReminderThisWeek
                        .map((activityReminder) {
                      return CalendarItem(activityReminder.reminderDateTime,
                          buildActivityReminderWidget(activityReminder));
                    }));
                    combinedList.sort((a, b) => a.time.compareTo(b.time));
                    return ListView(
                      children: [
                        ListView.builder(
                            reverse: false,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: combinedList.length,
                            itemBuilder: (context, index) {
                              CalendarItem calendarItem = combinedList[index];
                              return calendarItem.content;
                            }),
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              height: 41 * FCStyle.fem,
              margin: EdgeInsets.fromLTRB(106.74 * FCStyle.fem,
                  10 * FCStyle.fem, 90 * FCStyle.fem, 10 * FCStyle.fem),
              child: TextButton(
                onPressed: () {
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

                  TrackEvents().trackEvents('Calendar Clicked', properties);
                  fcRouter.navigate(const CalenderRoute());
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      22.5 * FCStyle.fem,
                      5.5 * FCStyle.fem,
                      22.88 * FCStyle.fem,
                      5.5 * FCStyle.fem),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorPallet.kWhite,
                    borderRadius: BorderRadius.circular(100 * FCStyle.fem),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x28000000),
                        offset: Offset(0 * FCStyle.fem, 4 * FCStyle.fem),
                        blurRadius: 2 * FCStyle.fem,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * FCStyle.fem,
                              0 * FCStyle.fem,
                              5.63 * FCStyle.fem,
                              0 * FCStyle.fem),
                          child: Text(
                            'View More',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16 * FCStyle.ffem,
                              fontWeight: FontWeight.w500,
                              height: 1.1725 * FCStyle.ffem / FCStyle.fem,
                              color: ColorPallet.kBlack,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0 * FCStyle.fem,
                            0 * FCStyle.fem,
                            0 * FCStyle.fem,
                            1.25 * FCStyle.fem),
                        width: 6 * FCStyle.fem,
                        height: 13.5 * FCStyle.fem,
                        child: SvgPicture.asset(
                          AssetIconPath.rightArrowIcon,
                          width: 6 * FCStyle.fem,
                          height: 13.5 * FCStyle.fem,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppointmentWidget(Appointment _appointment) {
    return Container(
      color: ColorPallet.kWhite,
      margin: EdgeInsets.fromLTRB(0.74 * FCStyle.fem, 0 * FCStyle.fem,
          0 * FCStyle.fem, 10 * FCStyle.fem),
      child: TextButton(
        onPressed: () {
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

          TrackEvents().trackEvents('Appointment Clicked', properties);
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) {
                return CalendarAppointmentScreen(
                  appointment: _appointment,
                );
              }));
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: SizedBox(
          width: 330 * FCStyle.fem,
          height: 75 * FCStyle.fem,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 4 * FCStyle.fem,
                height: 65 * FCStyle.fem,
                child: Container(color: _appointment.color),
              ),
              Container(
                margin: EdgeInsets.only(left: 10 * FCStyle.fem),
                width: 270 * FCStyle.fem,
                height: 50 * FCStyle.fem,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _appointment.appointmentName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20 * FCStyle.ffem,
                        fontWeight: FontWeight.w600,
                        height: 1.3157894737 * FCStyle.ffem / FCStyle.fem,
                        color: Color(0xff000000),
                      ),
                    ),
                    Text(
                      '${DateFormat('MMM d, y').format(_appointment.appointmentDate).replaceAll('am', 'AM').replaceAll('pm', 'PM')} at ${DateFormat('hh:mm a').format(_appointment.startTime).replaceAll('am', 'AM').replaceAll('pm', 'PM')}',
                      style: TextStyle(
                        fontSize: 17 * FCStyle.ffem,
                        fontWeight: FontWeight.w600,
                        height: 1.3157894737 * FCStyle.ffem / FCStyle.fem,
                        color: Color.fromARGB(215, 50, 50, 50),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 16 * FCStyle.fem,
                height: 18.41 * FCStyle.fem,
                child: SvgPicture.asset(
                  AssetIconPath.upArrowIcon,
                  width: 16 * FCStyle.fem,
                  height: 18.41 * FCStyle.fem,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReminderWidget(Reminders _appointment) {
    return Container(
      color: ColorPallet.kWhite,
      margin: EdgeInsets.fromLTRB(0.74 * FCStyle.fem, 0 * FCStyle.fem,
          0 * FCStyle.fem, 10 * FCStyle.fem),
      child: TextButton(
        onPressed: () {
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

          TrackEvents().trackEvents('Appointment Clicked', properties);
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) {
                return CalendarAppointmentScreen(
                  rem: _appointment,
                );
              }));
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: SizedBox(
          width: 330 * FCStyle.fem,
          height: 75 * FCStyle.fem,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 4 * FCStyle.fem,
                height: 65 * FCStyle.fem,
                child: Container(
                  color: _appointment.itemType.name.toString() ==
                          ClientReminderType.EVENT.name.toString()
                      ? ColorPallet.kPrimary
                      : ColorPallet.kTertiary,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10 * FCStyle.fem),
                width: 270 * FCStyle.fem,
                height: 50 * FCStyle.fem,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _appointment.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20 * FCStyle.ffem,
                        fontWeight: FontWeight.w600,
                        height: 1.3157894737 * FCStyle.ffem / FCStyle.fem,
                        color: Color(0xff000000),
                      ),
                    ),
                    Text(
                      '${DateFormat('MMM d, y').format(_appointment.startTime).replaceAll('am', 'AM').replaceAll('pm', 'PM')} at ${DateFormat('hh:mm a').format(_appointment.startTime).replaceAll('am', 'AM').replaceAll('pm', 'PM')}',
                      style: TextStyle(
                        fontSize: 17 * FCStyle.ffem,
                        fontWeight: FontWeight.w600,
                        height: 1.3157894737 * FCStyle.ffem / FCStyle.fem,
                        color: Color.fromARGB(215, 50, 50, 50),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 16 * FCStyle.fem,
                height: 18.41 * FCStyle.fem,
                child: SvgPicture.asset(
                  AssetIconPath.upArrowIcon,
                  width: 16 * FCStyle.fem,
                  height: 18.41 * FCStyle.fem,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActivityReminderWidget(ActivityReminder activityRem) {
    return Container(
      color: ColorPallet.kWhite,
      margin: EdgeInsets.fromLTRB(0.74 * FCStyle.fem, 0 * FCStyle.fem,
          0 * FCStyle.fem, 10 * FCStyle.fem),
      child: TextButton(
        onPressed: () {
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

          TrackEvents().trackEvents('Activity Reminder Clicked', properties);
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) {
                print("Hellooooo");
                return CalendarAppointmentScreen(
                  activityReminder: activityRem,
                );
              }));
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: SizedBox(
          width: 330 * FCStyle.fem,
          height: 75 * FCStyle.fem,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 4 * FCStyle.fem,
                height: 65 * FCStyle.fem,
                child: Container(
                  color: Colors.redAccent,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10 * FCStyle.fem),
                width: 270 * FCStyle.fem,
                height: 60 * FCStyle.fem,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activityRem.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20 * FCStyle.ffem,
                        fontWeight: FontWeight.w600,
                        height: 1.3157894737 * FCStyle.ffem / FCStyle.fem,
                        color: Color(0xff000000),
                      ),
                    ),
                    Text(
                      '${DateFormat('MMM d, y').format(activityRem.reminderDateTime).replaceAll('am', 'AM').replaceAll('pm', 'PM')} at ${DateFormat('hh:mm a').format(activityRem.reminderDateTime).replaceAll('am', 'AM').replaceAll('pm', 'PM')}',
                      style: TextStyle(
                        fontSize: 17 * FCStyle.ffem,
                        fontWeight: FontWeight.w600,
                        height: 1.3157894737 * FCStyle.ffem / FCStyle.fem,
                        color: Color.fromARGB(215, 50, 50, 50),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 16 * FCStyle.fem,
                height: 18.41 * FCStyle.fem,
                child: SvgPicture.asset(
                  AssetIconPath.upArrowIcon,
                  width: 16 * FCStyle.fem,
                  height: 18.41 * FCStyle.fem,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalendarItem {
  final DateTime time;
  final Widget content;
  CalendarItem(this.time, this.content);
}
