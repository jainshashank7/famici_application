//  BlocBuilder<ManageHistoryBloc, ManageHistoryState>(
//                     builder: (context, state) {
//                       List<CallHistoryElement> appointments = state.log;

//                       return Container(
//                           height: FCStyle.screenHeight * 0.9,
//                           margin: const EdgeInsets.only(
//                               right: 20, left: 20, top: 0, bottom: 12),
//                           decoration: BoxDecoration(
//                               color: const Color.fromARGB(229, 255, 255, 255),
//                               borderRadius: BorderRadius.circular(10)),
//                           child: Stack(
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 40, horizontal: 50),
//                                 child: (appointments.isEmpty)
//                                     ? Center(
//                                         child: Text(
//                                           "No prior calls.",
//                                           style: TextStyle(
//                                               fontSize: 40 * FCStyle.ffem,
//                                               fontWeight: FontWeight.w500,
//                                               letterSpacing: 2 * FCStyle.ffem),
//                                         ),
//                                       )
//                                     : RawScrollbar(
//                                         trackVisibility: true,
//                                         radius: Radius.circular(10),
//                                         thumbColor: ColorPallet.kPrimary,
//                                         thickness: 5,
//                                         thumbVisibility: true,
//                                         child: ListView.builder(
//                                             itemCount: appointments.length,
//                                             itemBuilder: (BuildContext context,
//                                                 int index) {
//                                               return Container(
//                                                   margin: EdgeInsets.only(
//                                                       bottom: 1),
//                                                   color: Colors.white,
//                                                   width: double.infinity,
//                                                   height: 75,
//                                                   padding: EdgeInsets.only(
//                                                       left: 20, right: 40),
//                                                   child: Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         Row(
//                                                           children: [
//                                                             SvgPicture.asset(
//                                                               AssetIconPath
//                                                                   .telehealthIcon,
//                                                               width: 40 *
//                                                                   FCStyle.fem,
//                                                               color:
//                                                                   Colors.black,
//                                                             ),
//                                                             SizedBox(
//                                                               width: 14,
//                                                             ),
//                                                             Container(
//                                                               width: 150,
//                                                               child: Text(
//                                                                 appointments[
//                                                                         index]
//                                                                     .appointmentName,
//                                                                 overflow:
//                                                                     TextOverflow
//                                                                         .ellipsis,
//                                                                 style: TextStyle(
//                                                                     fontSize: 26 *
//                                                                         FCStyle
//                                                                             .fem,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w700),
//                                                               ),
//                                                             )
//                                                           ],
//                                                         ),
//                                                         Container(
//                                                           width: 90,
//                                                           child: Text(
//                                                             formatDuration(
//                                                               appointments[
//                                                                       index]
//                                                                   .latestCapturedTime
//                                                                   .difference(appointments[
//                                                                           index]
//                                                                       .actualStartTime),
//                                                             ),
//                                                             style: TextStyle(
//                                                                 fontSize: 20 *
//                                                                     FCStyle.fem,
//                                                                 color: Color
//                                                                     .fromARGB(
//                                                                         255,
//                                                                         148,
//                                                                         148,
//                                                                         148),
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600),
//                                                           ),
//                                                         ),
//                                                         Container(
//                                                           width: 100,
//                                                           child: Text(
//                                                             DateFormat(
//                                                                     'MMM d, h:mm a')
//                                                                 .format(appointments[
//                                                                         index]
//                                                                     .actualStartTime)
//                                                                 .replaceAll(
//                                                                     'am', 'AM')
//                                                                 .replaceAll(
//                                                                     'pm', 'PM'),
//                                                             style: TextStyle(
//                                                                 fontSize: 20 *
//                                                                     FCStyle.fem,
//                                                                 color: Color
//                                                                     .fromARGB(
//                                                                         255,
//                                                                         148,
//                                                                         148,
//                                                                         148),
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600),
//                                                           ),
//                                                         ),
//                                                         Container(
//                                                           width: 90,
//                                                           child: Text(
//                                                             appointments[index]
//                                                                 .apponitmentType
//                                                                 .name
//                                                                 .capitalize(),
//                                                             style: TextStyle(
//                                                                 fontSize: 20 *
//                                                                     FCStyle.fem,
//                                                                 color: Color
//                                                                     .fromARGB(
//                                                                         255,
//                                                                         148,
//                                                                         148,
//                                                                         148),
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600),
//                                                           ),
//                                                         )
//                                                       ]));
//                                             }),
//                                       ),
//                               ),
//                               state.log.length != 0
//                                   ? Positioned(
//                                       bottom: 10,
//                                       right: 50,
//                                       child: Row(
//                                         children: [
//                                           Text(
//                                             'Total Number of Records : ',
//                                             style: TextStyle(
//                                                 color: Color.fromARGB(
//                                                     255, 101, 101, 101)),
//                                           ),
//                                           Text(
//                                             state.log.length.toString(),
//                                             style:
//                                                 TextStyle(color: Colors.black),
//                                           )
//                                         ],
//                                       ))
//                                   : SizedBox.shrink(),
//                             ],
//                           ));
//                     },
//                   ),

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/feature/calander/blocs/calendar/calendar_bloc.dart';
import 'package:famici/shared/famici_scaffold.dart';

import '../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../core/router/router_delegate.dart';
import '../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../../../core/screens/home_screen/widgets/logout_button.dart';
import '../../../shared/fc_bottom_status_bar.dart';
import '../../../shared/fc_confirm_dialog.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../../utils/constants/assets_paths.dart';
import '../../chat/blocs/call_history_bloc/history_bloc.dart';

class IcalListScreen extends StatefulWidget {
  const IcalListScreen({super.key});

  @override
  State<IcalListScreen> createState() => _IcalListScreenState();
}

class _IcalListScreenState extends State<IcalListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
  builder: (context, stateM) {
    return FamiciScaffold(
      topRight: LogoutButton(),
      title: Center(
        child: Text(
          'Calendar List',
          style: FCStyle.textStyle
              .copyWith(fontSize: 50.sp, fontWeight: FontWeight.w700),
        ),
      ),
      bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
      child: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          List<ICalURL> appointments = state.icalLinks;

          return Container(
              height: FCStyle.screenHeight * 0.9,
              margin: const EdgeInsets.only(
                  right: 20, left: 20, top: 0, bottom: 12),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(229, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10)),
              child: Stack(
                children: [
                  state.icalLinks.length != 0
                      ? Positioned(
                          top: 10,
                          left: 50,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 150,
                                    )
                                  ],
                                ),
                                Container(
                                  width: 500,
                                ),
                                Container(
                                  width: 90,
                                )
                              ]))
                      : SizedBox.shrink(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 50),
                    child: (appointments.isEmpty)
                        ? Center(
                            child: Text(
                              "No Calendar Added.",
                              style: TextStyle(
                                  fontSize: 40 * FCStyle.ffem,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 2 * FCStyle.ffem),
                            ),
                          )
                        : RawScrollbar(
                            trackVisibility: true,
                            radius: Radius.circular(10),
                            thumbColor: ColorPallet.kPrimary,
                            thickness: 5,
                            thumbVisibility: true,
                            child: ListView.builder(
                                itemCount: appointments.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      margin: EdgeInsets.only(bottom: 1),
                                      color: Colors.white,
                                      width: double.infinity,
                                      height: 75,
                                      padding:
                                          EdgeInsets.only(left: 20, right: 40),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 150,
                                                  child: Text(
                                                    appointments[index].name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize:
                                                            26 * FCStyle.fem,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Container(
                                              width: 500,
                                              child: Text(
                                                appointments[index].url,
                                                style: TextStyle(
                                                    fontSize: 20 * FCStyle.fem,
                                                    color: Color.fromARGB(
                                                        255, 148, 148, 148),
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Container(
                                                width: 90,
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        fcRouter.navigate(
                                                            CreateAppointmentRoute(
                                                                isICalBool:
                                                                    true,
                                                                ical:
                                                                    appointments[
                                                                        index]));
                                                      },
                                                      child: Container(
                                                        width: 40,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            border: Border.all(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        190,
                                                                        190,
                                                                        190))),
                                                        child: Icon(
                                                          Icons.edit_document,
                                                          color: ColorPallet
                                                              .kPrimary,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    BlocBuilder<CalendarBloc,
                                                            CalendarState>(
                                                        builder:
                                                            (context, state) {
                                                      return GestureDetector(
                                                          onTap: () async {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return FCConfirmDialog(
                                                                    height: 430,
                                                                    isThirdButton:
                                                                        false,
                                                                    width: 800,
                                                                    submitText:
                                                                        'Delete',
                                                                    cancelText:
                                                                        'Cancel',
                                                                    icon: VitalIcons
                                                                        .deleteIcon,
                                                                    message:
                                                                        "Are you sure you want to delete this Calendar?",
                                                                  );
                                                                }).then((value) async {
                                                              if (value) {
                                                                context
                                                                    .read<
                                                                        CalendarBloc>()
                                                                    .add(deleteICal(
                                                                        appointments[index]
                                                                            .id));
                                                                // fcRouter.pop();
                                                                // context.read<ManageRemindersBloc>().add(
                                                                //     DeleteEventsAndRemindersForByRecurrenceRule(
                                                                //         recurrence_id: rem!.recurrenceId,
                                                                //         isEvent: rem!.itemType.name ==
                                                                //                 ClientReminderType
                                                                //                     .EVENT.name
                                                                //                     .toString()
                                                                //             ? true
                                                                //             : false));
                                                                // context.read<CalendarBloc>().add(
                                                                //     FetchCalendarDetailsEvent(
                                                                //         state.startDate, state.endDate));
                                                                // context.read<CalendarBloc>().add(
                                                                //     FetchThisWeekAppointmentsCalendarEvent());
                                                                // await AwesomeNotifications()
                                                                //     .cancelSchedulesByGroupKey(
                                                                //         rem!.reminderId.toString());
                                                              }
                                                              if (!value) {
                                                                // context.read<ManageRemindersBloc>().add(
                                                                //     DeleteEventsAndRemindersData(
                                                                //         reminder_id: rem!.reminderId,
                                                                //         isEvent: rem!.itemType.name ==
                                                                //                 ClientTypeEnum
                                                                //                     .ClientReminderType
                                                                //                     .EVENT
                                                                //                     .name
                                                                //                     .toString()
                                                                //             ? true
                                                                //             : false));
                                                                // context
                                                                //     .read<
                                                                //         CalendarBloc>()
                                                                //     .add(FetchCalendarDetailsEvent(
                                                                //         state
                                                                //             .startDate,
                                                                //         state
                                                                //             .endDate));
                                                                // context.read<CalendarBloc>().add(
                                                                //     FetchThisWeekAppointmentsCalendarEvent());
                                                                // await AwesomeNotifications()
                                                                //     .cancelSchedulesByGroupKey(
                                                                //         rem!.reminderId.toString());
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            width: 40,
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                border: Border.all(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            190,
                                                                            190,
                                                                            190))),
                                                            child: Icon(
                                                                Icons.delete,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        150,
                                                                        49,
                                                                        9)),
                                                          ));
                                                    }),
                                                  ],
                                                ))
                                          ]));
                                }),
                          ),
                  ),
                  state.icalLinks.length != 0
                      ? Positioned(
                          bottom: 10,
                          right: 50,
                          child: Row(
                            children: [
                              Text(
                                'Total Number of Records : ',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 101, 101, 101)),
                              ),
                              Text(
                                state.icalLinks.length.toString(),
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ))
                      : SizedBox.shrink(),
                ],
              ));
        },
      ),
    );
  },
);
  }
}
