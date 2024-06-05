part of 'barrel.dart';

class RememberToWidget extends StatelessWidget {
  const RememberToWidget({
    Key? key,
  }) : super(key: key);

  Widget getDate(DateTime appointmentDate, bool showTopDate) {
    String _formatted = DateFormat().add_MMMd().format(appointmentDate);
    if (!showTopDate) {
      return SizedBox(height: 16.0);
    }
    {
      return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: state.isDark ? ColorPallet.kWhite : ColorPallet.kPrimaryTextColor,
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
                  color: state.isDark ? ColorPallet.kWhite : ColorPallet.kPrimaryTextColor,
                  height: 3.0,
                ),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              HomeStrings.rememberTo.tr(),
              style: TextStyle(
                color: state.isDark
                    ? ColorPallet.kWhite
                    : ColorPallet.kPrimaryTextColor,
                fontSize: FCStyle.mediumFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            LayoutBuilder(builder: (context, cons) {
              return ConcaveCard(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  height: FCStyle.largeFontSize * 6,
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
                      builder: (context, calendarState) {
                        if (calendarState.isLoadingThisWeekAppointments) {
                          return LoadingScreen(
                            height: FCStyle.xLargeFontSize * 2,
                            width: FCStyle.xLargeFontSize * 2,
                          );
                        }
                        if (calendarState.appointmentsThisWeek.isEmpty) {
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
                            reverse: false,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                calendarState.appointmentsThisWeek.length,
                            padding: EdgeInsets.symmetric(
                              horizontal: FCStyle.defaultFontSize,
                              vertical: FCStyle.mediumFontSize,
                            ),
                            itemBuilder: (context, index) {
                              Appointment _appointment =
                                  calendarState.appointmentsThisWeek[index];

                              DateTime _date = _appointment.appointmentDate;
                              DateTime _prvDate = DateTime.now();
                              if (index > 0) {
                                _prvDate = calendarState
                                    .appointmentsThisWeek[index - 1]
                                    .appointmentDate;
                              }

                              bool showTopDate =
                                  index == 0 || _date.compareTo(_prvDate) > 0;

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (showTopDate)
                                    getDate(
                                      _appointment.appointmentDate,
                                      showTopDate,
                                    ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        DateFormat('hh:mm')
                                            .format(_appointment.startTime),
                                        style: FCStyle.textStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: FCStyle.mediumFontSize,
                                        ),
                                      ),
                                      SizedBox(width: 8.0),
                                      Text(
                                        DateFormat('a')
                                            .format(_appointment.startTime),
                                        style: FCStyle.textStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: FCStyle.smallFontSize,
                                        ),
                                      ),
                                      SizedBox(width: 16.0),
                                      Flexible(
                                        child: Text(
                                          _appointment.appointmentName,
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
            }),
            // Icon(Icons.arr),
          ],
        ),
      );
    });
  }
}
