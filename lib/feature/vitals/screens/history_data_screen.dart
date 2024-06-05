import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/core/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/blocs/vitals_and_wellness_bloc.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/entity/vital.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/sliverDelegateWithFixedHeight.dart';
import 'package:famici/feature/vitals/blocs/vital_history_bloc/vital_history_bloc.dart';
import 'package:famici/feature/vitals/screens/set_vital_date_range.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:uuid/uuid.dart';

import '../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../../../core/screens/home_screen/widgets/logout_button.dart';
import '../../../shared/fc_back_button.dart';
import '../../../utils/helpers/events_track.dart';
import '../../health_and_wellness/vitals_and_wellness/widgets/device_type_icon.dart';

var uuid = Uuid();

class HistoryDataScreen extends StatefulWidget {
  const HistoryDataScreen({Key? key}) : super(key: key);

  @override
  State<HistoryDataScreen> createState() => _HistoryDataScreenState();
}

class _HistoryDataScreenState extends State<HistoryDataScreen> {
  final List<DateTime> dates = [DateTime.now()];
  int vitalRows = 0;
  final ScrollController _scrollController = ScrollController();
  VitalHistoryBloc? _historyBloc;
  final currDate = DateTime.now();

  @override
  void initState() {
    _historyBloc = context.read<VitalHistoryBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _historyBloc?.add(SyncSelectedDate(
      DateTime.now(),
      DateTime.now(),
      shouldRefresh: false,
      mergeTempToSelected: true,
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<bool> isSelected = [false, false, true];
    String DateRange = DateFormat('MMMM d, y').format(DateTime.now());

    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
  builder: (context, stateM) {
    return BlocBuilder<VitalHistoryBloc, VitalHistoryState>(
          builder: (context, vitalHistoryState) {
            List<Vital> vitalList = vitalHistoryState.vitals;
            vitalList.removeWhere((element) =>
                element.vitalType == vitalHistoryState.selectedVital.vitalType);
            vitalList.insert(0, vitalHistoryState.selectedVital);
            return FamiciScaffold(
              appbarBackground: !state.hasInternet ||
                      vitalHistoryState.status == Status.loading
                  ? ColorPallet.kBackground.withOpacity(0.9)
                  : null,
              leading: FCBackButton(),
              topRight: LogoutButton(),
              title: BlocBuilder<VitalsAndWellnessBloc, VitalsAndWellnessState>(
                  builder: (context, VitalState) {
                return FCSliderButton(
                  borderRadius: (8 * FCStyle.fem),
                  height: (60 * FCStyle.fem),
                  width: (700 * FCStyle.fem),
                  // initialLeftSelected: state.showingVitals,
                  leftChild: Text('All Vitals Readings'),
                  rightChild: Text('All Wellness Readings'),
                  initialLeftSelected: VitalState.showingVitals,
                  onLeftTap: () {
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
                    TrackEvents().trackEvents(
                        'Historic Data - All Vitals Readings Clicked',
                        properties);
                    context.read<VitalHistoryBloc>().add(
                          SyncSelectedVital(VitalState.vitalList[0].vitalType,
                              isRefreshed: false),
                        );
                    context
                        .read<VitalsAndWellnessBloc>()
                        .add(ToggleShowVitals());
                  },
                  onRightTap: () {
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
                    TrackEvents().trackEvents(
                        'Historic Data - All Wellness Readings Clicked',
                        properties);
                    context.read<VitalHistoryBloc>().add(
                          SyncSelectedVital(
                              VitalState.wellnessList[0].vitalType,
                              isRefreshed: false),
                        );
                    context
                        .read<VitalsAndWellnessBloc>()
                        .add(ToggleShowVitals());
                  },
                );
              }),

              //  Center(
              // child:
              // vitalHistoryState.vitals.isEmpty
              //     ? SizedBox.shrink()
              //     :
              //     Text(
              //         'Historic Data',
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //           overflow: TextOverflow.ellipsis,
              //           color: ColorPallet.kPrimaryTextColor,
              //           fontWeight: FontWeight.w600,
              //           fontSize: 40 * FCStyle.fem,
              //         ),
              //       ),

              //  CustomDropdown<VitalType>(
              //     child: Text(
              //       vitalHistoryState.selectedVital.name ?? '',
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         overflow: TextOverflow.ellipsis,
              //         color: ColorPallet.kPrimaryTextColor,
              //         fontWeight: FontWeight.w400,
              //         fontSize: 36.sp,
              //       ),
              //     ),
              //     dropdownButtonStyle: DropdownButtonStyle(
              //         height: 100.h,
              //         width: 380.w,
              //         elevation: 8,
              //         backgroundColor: ColorPallet.kCardBackground,
              //         primaryColor: ColorPallet.kPrimaryTextColor,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(15.0),
              //         )),
              //     dropdownStyle: DropdownStyle(
              //       borderRadius: BorderRadius.circular(10),
              //       color: ColorPallet.kCardBackground,
              //       elevation: 6,
              //       padding: EdgeInsets.symmetric(
              //         horizontal: 20,
              //         vertical: 8.0,
              //       ),
              //     ),
              //     onChange: (VitalType? newValue, int id) {
              //       context.read<VitalHistoryBloc>().add(
              //             SyncSelectedVital(newValue!),
              //           );
              //     },
              //     items: vitalHistoryState.vitals
              //         .map<DropdownItem<VitalType>>(
              //       (Vital value) {
              //         return DropdownItem<VitalType>(
              //           value: value.vitalType,
              //           child: Padding(
              //             padding: EdgeInsets.symmetric(vertical: 8.0),
              //             child: Text(
              //               value.name ?? '',
              //               style: FCStyle.textStyle,
              //             ),
              //           ),
              //         );
              //       },
              //     ).toList(),
              //   ),
              // ),
              bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
              child: BlocBuilder<VitalsAndWellnessBloc, VitalsAndWellnessState>(
                  builder: (context, VitalState) {
                return Container(
                  margin:
                      EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 16),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(229, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.only(
                    top: 8 * FCStyle.fem,
                    left: 26 * FCStyle.fem,
                  ),
                  child: VitalState.showingVitals
                      ? HistoricData(vitalHistoryState, context, state,
                          VitalState.vitalList, true)
                      : HistoricData(vitalHistoryState, context, state,
                          VitalState.wellnessList, false),
                );
              }),
            );
          },
        );
  },
);
      },
    );
  }

  Stack HistoricData(VitalHistoryState vitalHistoryState, BuildContext context,
      ConnectivityState state, List<Vital> VitalState, bool isVital) {
    // List<Map<String, int>> fallLogs = [
    //   {'time': 1682533343793, 'reading': 1},
    //   {'time': 1682533313793, 'reading': 1},
    //   {'time': 1682533334213, 'reading': 1},
    // ];

    // List<Map<String, int>> fallLogs = [
    //   {'time': 1682533800000, 'reading': 3},
    //   {'time': 1682361000000, 'reading': 1},
    //   {'time': 1682101800000, 'reading': 2},
    // ];
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                flex: 1,
                child: Column(
                  children: [
                    isVital
                        ? IconButton(
                            padding: EdgeInsets.all(0),
                            focusColor: Colors.black,
                            onPressed: () {
                              _scrollController.animateTo(
                                  _scrollController.position.pixels - 70,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn);
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_up,
                              size: 44,
                              color: Color.fromARGB(255, 184, 185, 186),
                            ),
                          )
                        : SizedBox(
                            height: 70,
                          ),
                    Container(
                      height: 355,
                      child: GridView.builder(
                          controller: _scrollController,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                  height: isVital
                                      ? 92 * FCStyle.fem
                                      : 140 * FCStyle.fem,
                                  crossAxisCount: 1,
                                  mainAxisSpacing: 8),
                          itemCount: VitalState.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  var properties = TrackEvents().setProperties(
                                      fromDate: '',
                                      toDate: '',
                                      reading: '',
                                      readingDateTime: '',
                                      vital: VitalState[index].name,
                                      appointmentDate: '',
                                      appointmentTime: '',
                                      appointmentCounselors: '',
                                      appointmentType: '',
                                      callDuration: '',
                                      readingType: '');
                                  TrackEvents().trackEvents(
                                      'Historic Data Clicked', properties);
                                  context.read<VitalHistoryBloc>().add(
                                      SyncSelectedVital(
                                          VitalState[index].vitalType));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: vitalHistoryState
                                                  .selectedVital.vitalType ==
                                              VitalState[index].vitalType
                                          ? ColorPallet.kPrimary
                                          : ColorPallet.kPrimary
                                              .withOpacity(0.3)),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 3),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        DeviceTypeIcon(
                                            type: VitalState[index].vitalType,
                                            size: 30 * FCStyle.fem,
                                            color: vitalHistoryState
                                                        .selectedVital
                                                        .vitalType ==
                                                    VitalState[index].vitalType
                                                ? ColorPallet.kPrimaryText
                                                : ColorPallet.kPrimary),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          VitalState[index].name!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20 * FCStyle.fem,
                                              color: vitalHistoryState
                                                          .selectedVital
                                                          .vitalType ==
                                                      VitalState[index]
                                                          .vitalType
                                                  ? ColorPallet.kPrimaryText
                                                  : ColorPallet.kPrimary),
                                        )
                                      ]),
                                ));
                          }),
                    ),
                    isVital
                        ? IconButton(
                            padding: EdgeInsets.all(0),
                            focusColor: Colors.black,
                            onPressed: () {
                              _scrollController.animateTo(
                                  _scrollController.position.pixels + 70,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn);
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              size: 44,
                              color: Color.fromARGB(255, 184, 185, 186),
                            ),
                          )
                        : SizedBox.shrink()
                  ],
                )),

            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 26 * FCStyle.fem,
                    top: 26 * FCStyle.fem,
                    right: 35 * FCStyle.fem,
                    bottom: 42 * FCStyle.fem),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            vitalHistoryState.selectedVital.name ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorPallet.kPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 35 * FCStyle.fem,
                            ),
                          ),
                          ToggleButtonBar(
                              vitalHistoryBloc:
                                  context.read<VitalHistoryBloc>(),
                              vitalHistoryState: vitalHistoryState)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<VitalHistoryBloc, VitalHistoryState>(
                        builder: (context, state) {
                          // if (vitalHistoryState.selectedVital.vitalType ==
                          //     VitalType.fallDetection) {
                          //   return Expanded(
                          //     child: Container(
                          //         decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             borderRadius: BorderRadius.circular(
                          //                 15 * FCStyle.fem)),
                          //         padding: EdgeInsets.only(
                          //             top: 30 * FCStyle.fem,
                          //             bottom: 26 * FCStyle.fem,
                          //             left: 30 * FCStyle.fem,
                          //             right: 30 * FCStyle.fem),
                          //         child: Column(
                          //           children: [
                          //             Row(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.spaceEvenly,
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.center,
                          //                 children: [
                          //                   Text(
                          //                     'Vital taken date',
                          //                     style: TextStyle(
                          //                         fontWeight: FontWeight.w700,
                          //                         fontSize: 27 * FCStyle.fem),
                          //                   ),
                          //                   SizedBox(
                          //                     width: 50,
                          //                   ),
                          //                   Text('Time',
                          //                       style: TextStyle(
                          //                           fontWeight: FontWeight.w700,
                          //                           fontSize:
                          //                               27 * FCStyle.fem)),
                          //                   SizedBox(
                          //                     width: 50,
                          //                   ),
                          //                   Text('Vital Reading/Measure',
                          //                       style: TextStyle(
                          //                           fontWeight: FontWeight.w700,
                          //                           fontSize: 27 * FCStyle.fem))
                          //                 ]),
                          //             SizedBox(
                          //               height: 20 * FCStyle.fem,
                          //             ),
                          //             Container(
                          //               height: 270,
                          //               child: ListView.builder(
                          //                   itemCount: fallLogs.length,
                          //                   itemBuilder: ((context, index) {
                          //                     return VitalLogs(
                          //                         date: fallLogs[index]
                          //                             ['time']!,
                          //                         reading: fallLogs[index]
                          //                                 ['reading']
                          //                             .toString(),
                          //                         unit: '');
                          //                   })),
                          //             ),
                          //           ],
                          //         )),
                          //   );
                          // } else
                          if (vitalHistoryState.history.readings.isEmpty) {
                            return Expanded(
                              child: Center(
                                child: Text(
                                  "No information available to view.",
                                  style: FCStyle.textStyle,
                                ),
                              ),
                            );
                          } else {
                            return Expanded(
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          15 * FCStyle.fem)),
                                  padding: EdgeInsets.only(
                                      top: 30 * FCStyle.fem,
                                      bottom: 26 * FCStyle.fem,
                                      left: 30 * FCStyle.fem,
                                      right: 30 * FCStyle.fem),
                                  child: Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Vital taken date',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 27 * FCStyle.fem),
                                            ),
                                            SizedBox(
                                              width: 50,
                                            ),
                                            Text('Time',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        27 * FCStyle.fem)),
                                            SizedBox(
                                              width: 50,
                                            ),
                                            Text('Vital Reading/Measure',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 27 * FCStyle.fem))
                                          ]),
                                      SizedBox(
                                        height: 20 * FCStyle.fem,
                                      ),
                                      Container(
                                        height: 270,
                                        child: ListView.builder(
                                            itemCount:
                                                state.history.readings.length,
                                            itemBuilder: ((context, index) {
                                              return VitalLogs(
                                                  date: state.history
                                                      .readings[index].readAt,
                                                  reading: (VitalLogsHelper
                                                          .getVitalReading(
                                                              state.history
                                                                      .readings[
                                                                  index],
                                                              state
                                                                  .selectedVital
                                                                  .vitalType)
                                                      .toString()),
                                                  unit: state.selectedVital
                                                              .measureUnit !=
                                                          null
                                                      ? state.selectedVital
                                                          .measureUnit!
                                                      : '');
                                            })),
                                      ),
                                    ],
                                  )),
                            );
                          }
                        },
                      )
                    ]),
              ),
            ),

            // BlocBuilder<VitalHistoryBloc, VitalHistoryState>(
            //   builder: (context, state) {
            //     if (state.selectedVital.vitalType ==
            //         VitalType.fallDetection) {
            //       return Column(
            //         // mainAxisSize: MainAxisSize.min,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           SizedBox(
            //             height: FCStyle.screenHeight *
            //                 2 /
            //                 3 *
            //                 1 /
            //                 5,
            //           ),
            //           Text(
            //             'Fall Detection Engaged',
            //             style: FCStyle.textStyle.copyWith(
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           SizedBox(height: 16.0),
            //           BlocBuilder<VitalsAndWellnessBloc,
            //               VitalsAndWellnessState>(
            //             builder: (context, state) {
            //               bool engaged = state.vitalList
            //                   .firstWhere(
            //                     (e) =>
            //                         e.vitalType ==
            //                         VitalType.fallDetection,
            //                   )
            //                   .connected;

            //               return Row(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   Text(
            //                     CommonStrings.yes.tr(),
            //                     style: FCStyle.textStyle,
            //                   ),
            //                   SizedBox(
            //                       width:
            //                           FCStyle.defaultFontSize),
            //                   IgnorePointer(
            //                     child: FCRadioButton(
            //                       value: true,
            //                       groupValue: engaged,
            //                     ),
            //                   ),
            //                   SizedBox(
            //                     width: FCStyle.defaultFontSize,
            //                   ),
            //                   IgnorePointer(
            //                     child: FCRadioButton(
            //                       value: false,
            //                       groupValue: engaged,
            //                     ),
            //                   ),
            //                   SizedBox(
            //                       width:
            //                           FCStyle.defaultFontSize),
            //                   Text(
            //                     CommonStrings.no.tr(),
            //                     style: FCStyle.textStyle,
            //                   ),
            //                 ],
            //               );
            //             },
            //           )
            //         ],
            //       );
            //     }
            //     return MeasurementSummary(
            //       lowest: double.tryParse(
            //               state.history.min.value) ??
            //           0,
            //       lowestDate:
            //           DateTime.fromMillisecondsSinceEpoch(
            //         state.history.min.readAt,
            //       ),
            //       highest: double.tryParse(
            //               state.history.max.value) ??
            //           0,
            //       highestDate:
            //           DateTime.fromMillisecondsSinceEpoch(
            //         state.history.max.readAt,
            //       ),
            //       unit: state.selectedVital.measureUnit,
            //       average:
            //           double.tryParse(state.history.avg) ?? 0,
            //       numberOfDaysForAvg: 7,
            //     );
            //   },
            // ),
          ],
        ),
        vitalHistoryState.history.readings.length != 0
            ? Positioned(
                bottom: 10,
                right: 30,
                child: Row(
                  children: [
                    Text(
                      'Total Number of Records : ',
                      style:
                          TextStyle(color: Color.fromARGB(255, 101, 101, 101)),
                    ),
                    Text(
                      vitalHistoryState.history.readings.length.toString(),
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ))
            : SizedBox.shrink(),
        vitalHistoryState.status == Status.loading
            ? Container(
                color: ColorPallet.kBackground.withOpacity(0.9),
                child: LoadingScreen(),
              )
            : SizedBox.shrink(),
        !state.hasInternet
            ? Container(
                color: ColorPallet.kBackground.withOpacity(0.9),
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Text(
                    'History Data require an internet connection!',
                    style: FCStyle.textStyle,
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

// class DateSelectCalendar extends StatefulWidget {
//   const DateSelectCalendar({
//     Key? key,
//     this.selected,
//   }) : super(key: key);

//   final DateTime? selected;

//   @override
//   State<DateSelectCalendar> createState() => _DateSelectCalendarState();
// }

// class _DateSelectCalendarState extends State<DateSelectCalendar> {
//   PageController? _pageController;

//   late DateTime focusedDay;
//   DateTime? selected;

//   @override
//   void initState() {
//     focusedDay = widget.selected ?? DateTime.now();
//     selected = widget.selected ?? DateTime.now();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopupScaffold(
//       child: Stack(
//         children: [
//           Padding(
//             padding:
//                 EdgeInsets.symmetric(horizontal: FCStyle.xLargeFontSize * 2),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: FCStyle.largeFontSize,
//                     vertical: 16.0,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ArrowIconButton(
//                         icon: Icons.arrow_back_ios_rounded,
//                         onPressed: () {
//                           _pageController?.previousPage(
//                             duration: Duration(milliseconds: 300),
//                             curve: Curves.easeInToLinear,
//                           );
//                         },
//                       ),
//                       Text(
//                         DateFormat().add_MMM().add_y().format(focusedDay),
//                         style: FCStyle.textStyle.copyWith(
//                           fontSize: FCStyle.largeFontSize,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       ArrowIconButton(
//                         icon: Icons.arrow_forward_ios,
//                         onPressed: () {
//                           _pageController?.nextPage(
//                             duration: Duration(milliseconds: 300),
//                             curve: Curves.easeOutSine,
//                           );
//                         },
//                       )
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 16.0),
//                 TableCalendar(
//                   firstDay: DateTime.now().subtract(Duration(days: 365)),
//                   lastDay: DateTime.now(),
//                   focusedDay: focusedDay,
//                   currentDay: selected,
//                   headerVisible: false,
//                   shouldFillViewport: true,
//                   startingDayOfWeek: StartingDayOfWeek.monday,
//                   calendarFormat: CalendarFormat.month,
//                   onCalendarCreated: (controller) =>
//                       _pageController = controller,
//                   onPageChanged: (date1) {
//                     setState(() {
//                       focusedDay = date1;
//                     });
//                   },
//                   daysOfWeekHeight: 42.h,
//                   onDaySelected: (date1, date2) {
//                     setState(() {
//                       focusedDay = date2;
//                       selected = date2;
//                     });
//                     Navigator.pop(context, selected);
//                   },
//                   calendarBuilders: CalendarBuilders(
//                     dowBuilder: (context, day) {
//                       return Center(
//                         child: Text(
//                           DateFormat.E().format(day),
//                           style: FCStyle.textStyle,
//                         ),
//                       );
//                     },
//                     todayBuilder: (context, day, date) {
//                       return Container(
//                         width: FCStyle.xLargeFontSize,
//                         height: FCStyle.xLargeFontSize,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: ColorPallet.kInverseBackground,
//                         ),
//                         child: Center(
//                           child: Text(
//                             DateFormat.d().format(day),
//                             style: TextStyle(
//                                 color: ColorPallet.kBackground,
//                                 fontSize: FCStyle.mediumFontSize,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       );
//                     },
//                     defaultBuilder: (context, day, date) {
//                       return Container(
//                         padding: EdgeInsets.all(7),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                         ),
//                         child: Text(
//                           DateFormat.d().format(day),
//                           style: TextStyle(
//                               color: ColorPallet.kPrimaryTextColor,
//                               fontSize: FCStyle.mediumFontSize,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       );
//                     },
//                     selectedBuilder: (context, day, date) {
//                       return Container(
//                         padding: EdgeInsets.all(7),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: ColorPallet.kInverseBackground,
//                         ),
//                         child: Text(
//                           DateFormat.d().format(day),
//                           style: TextStyle(
//                               color: Colors.purple,
//                               fontSize: FCStyle.mediumFontSize,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       );
//                     },
//                     disabledBuilder: (context, day, date) {
//                       return Container(
//                         padding: EdgeInsets.all(7),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                         ),
//                         child: Text(
//                           DateFormat.d().format(day),
//                           style: TextStyle(
//                               color: ColorPallet.kPrimaryTextColor,
//                               fontSize: FCStyle.mediumFontSize,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       );
//                     },
//                     outsideBuilder: (context, day, date) {
//                       return SizedBox.shrink();
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.topRight,
//             child: CloseIconButton(
//               size: FCStyle.largeFontSize * 2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ArrowIconButton extends StatelessWidget {
//   const ArrowIconButton({
//     Key? key,
//     this.icon,
//     this.onPressed,
//   }) : super(key: key);

//   final VoidCallback? onPressed;
//   final IconData? icon;

//   @override
//   Widget build(BuildContext context) {
//     return NeumorphicButton(
//       minDistance: 3,
//       style: FCStyle.buttonCardStyle.copyWith(
//         boxShape: NeumorphicBoxShape.circle(),
//       ),
//       padding: EdgeInsets.all(6.0),
//       margin: EdgeInsets.zero,
//       child: Container(
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: ColorPallet.kGreen,
//         ),
//         padding: EdgeInsets.all(8.0),
//         child: Icon(
//           icon ?? Icons.add_rounded,
//           color: ColorPallet.kWhite,
//           size: FCStyle.xLargeFontSize,
//         ),
//       ),
//       onPressed: onPressed,
//     );
//   }
// }

class ToggleButtonBar extends StatefulWidget {
  final VitalHistoryBloc vitalHistoryBloc;
  final VitalHistoryState vitalHistoryState;

  const ToggleButtonBar(
      {super.key,
      required this.vitalHistoryBloc,
      required this.vitalHistoryState});

  @override
  _ToggleButtonBarState createState() => _ToggleButtonBarState();
}

class _ToggleButtonBarState extends State<ToggleButtonBar> {
  List<bool> isSelected = [false, false, true];
  String DateRange = DateFormat('MMMM d, y').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final currDate = DateTime.now();
    return ToggleButtons(
      textStyle: TextStyle(fontSize: 21 * FCStyle.fem, fontFamily: 'roboto'),
      fillColor: ColorPallet.kTertiary.withOpacity(0.06),
      borderColor: Color.fromARGB(254, 216, 218, 220),
      color: Colors.black,
      selectedColor: ColorPallet.kTertiary,
      renderBorder: true,
      selectedBorderColor: ColorPallet.kTertiary,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8 * FCStyle.fem),
          bottomLeft: Radius.circular(8 * FCStyle.fem),
          topRight: Radius.circular(8 * FCStyle.fem),
          bottomRight: Radius.circular(8 * FCStyle.fem)),
      isSelected: isSelected,
      onPressed: (int newIndex) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            if (i == newIndex) {
              if (newIndex == 2) {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return SetVitalDateRange();
                    }));
              } else if (newIndex == 0) {
                setState(() {
                  context.read<VitalHistoryBloc>().add(SyncSelectedDate(
                      DateTime(currDate.year, currDate.month, currDate.day - 6),
                      DateTime.now(),
                      shouldRefresh: true));
                });
              } else if (newIndex == 1) {
                setState(() {
                  context.read<VitalHistoryBloc>().add(SyncSelectedDate(
                      // _rangeStart ?? DateTime.now(),
                      // _rangeEnd ?? _rangeStart ?? DateTime.now(),

                      DateTime(
                          currDate.year, currDate.month, currDate.day - 30),
                      DateTime.now(),
                      shouldRefresh: true));

                  // widget.vitalHistoryBloc.add(SyncSelectedDate(
                  //     // _rangeStart ?? DateTime.now(),
                  //     // _rangeEnd ?? _rangeStart ?? DateTime.now(),
                  //     DateTime(2023, 4, 1),
                  //     DateTime.now(),
                  //     shouldRefresh: true));
                });
              }
              isSelected[i] = true;
            } else {
              isSelected[i] = false;
            }
          }
        });
      },
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: Text('Last 7 Days'),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: Text('Last 30 Days'),
        ),
        Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            child: Row(
              children: [
                Text(
                  (((widget.vitalHistoryState.startDate.day !=
                              widget.vitalHistoryState.endDate.day) ||
                          (widget.vitalHistoryState.startDate.month !=
                              widget.vitalHistoryState.endDate.month) ||
                          (widget.vitalHistoryState.startDate.year !=
                              widget.vitalHistoryState.endDate.year))
                      ? ' ${DateFormat('MMMM d, y').format(widget.vitalHistoryState.startDate)} to  ${DateFormat('MMMM d, y').format(widget.vitalHistoryState.endDate)}'
                      : DateFormat('MMMM d, y')
                          .format(widget.vitalHistoryState.endDate)),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 19,
                )
              ],
            )),
      ],
    );
  }
}

class VitalLogs extends StatelessWidget {
  const VitalLogs(
      {super.key,
      required this.date,
      required this.reading,
      required this.unit});

  final int date;
  final String reading, unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    DateFormat('MM/dd/yyyy')
                        .format(
                            DateTime.fromMicrosecondsSinceEpoch(date * 1000))
                        .toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 24 * FCStyle.fem)
                    // DateFormat('MMMM d, h:mm a')
                    //     .format(DateTime.fromMicrosecondsSinceEpoch(date * 1000))
                    //     .toString(),
                    ),
                SizedBox(
                  width: 30,
                ),
                Text(
                    DateFormat('h:mm a')
                        .format(
                            DateTime.fromMicrosecondsSinceEpoch(date * 1000))
                        .replaceAll('am', 'AM')
                        .replaceAll('pm', 'PM')
                        .toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 24 * FCStyle.fem)),
                SizedBox(
                  width: 30,
                ),
                Container(
                    alignment: Alignment.center,
                    width: 140,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: ColorPallet.kPrimary, width: 1),
                        borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                        color: ColorPallet.kPrimary.withOpacity(0.1)),
                    child: Text(
                      reading + ' ' + unit,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 21 * FCStyle.fem),
                    ))
              ],
            ),
          ),
          Divider(
            height: 10,
            indent: 10,
            endIndent: 20,
            color: Color.fromARGB(62, 210, 206, 201),
          )
        ],
      ),
    );
  }
}
