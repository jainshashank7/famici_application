// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// import '../../../core/router/router_delegate.dart';
// import '../../../shared/close_icon_button.dart';
// import '../../../shared/concave_card.dart';
// import '../../../shared/fc_primary_button.dart';
// import '../../../shared/popup_scaffold.dart';
// import '../../../utils/config/color_pallet.dart';
// import '../../../utils/config/famici.theme.dart';
// import '../../../utils/constants/assets_paths.dart';
// import '../../../utils/strings/common_strings.dart';
// import '../../../utils/strings/medication_strings.dart';
// import '../blocs/vital_history_bloc/vital_history_bloc.dart';
// import '../widgets/calendar_get_vital_date_range.dart';

// class SetVitalDateRange extends StatefulWidget {
//   const SetVitalDateRange({Key? key}) : super(key: key);

//   @override
//   State<SetVitalDateRange> createState() => _SetVitalDateRangeState();
// }

// class _SetVitalDateRangeState extends State<SetVitalDateRange> {
//   String _selectedDate = '';
//   String _dateCount = '';
//   String _range = '';
//   String _rangeCount = '';
//   DateTime _startDate = DateTime.now(), _endDate = DateTime.now();

//   /// The method for [DateRangePickerSelectionChanged] callback, which will be
//   /// called whenever a selection changed on the date picker widget.
//   void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
//     /// The argument value will return the changed date as [DateTime] when the
//     /// widget [SfDateRangeSelectionMode] set as single.
//     ///
//     /// The argument value will return the changed dates as [List<DateTime>]
//     /// when the widget [SfDateRangeSelectionMode] set as multiple.
//     ///
//     /// The argument value will return the changed range as [PickerDateRange]
//     /// when the widget [SfDateRangeSelectionMode] set as range.
//     ///
//     /// The argument value will return the changed ranges as
//     /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
//     /// multi range.
//     setState(() {
//       if (args.value is PickerDateRange) {
//         _startDate = args.value.startDate;
//         _endDate = args.value.endDate ?? args.value.startDate;
//         _range = '${DateFormat('MMMM d, y').format(args.value.startDate)} -'
//             // ignore: lines_longer_than_80_chars
//             ' ${DateFormat('MMMM d, y').format(args.value.endDate ?? args.value.startDate)}';
//       } else if (args.value is DateTime) {
//         _selectedDate = args.value.toString();
//       } else if (args.value is List<DateTime>) {
//         _dateCount = args.value.length.toString();
//       } else {
//         _rangeCount = args.value.length.toString();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<VitalHistoryBloc, VitalHistoryState>(
//       builder: (context, state) {
//         return PopupScaffold(
//             backgroundColor: Color.fromARGB(135, 0, 0, 0),
//             bodyColor: Colors.transparent,
//             child: Stack(
//               children: [
//                 FCCalendarSetVitalDateRange(
//                     vitalHistoryBloc: context.read<VitalHistoryBloc>()),
//                 Align(
//                   alignment: Alignment.bottomRight,
//                   child: Padding(
//                     padding: EdgeInsets.only(
//                         right: FCStyle.blockSizeVertical * 2,
//                         bottom: FCStyle.blockSizeVertical * 2),
//                     child: FCPrimaryButton(
//                       defaultSize: false,
//                       width: FCStyle.blockSizeHorizontal * 7,
//                       height: FCStyle.blockSizeVertical * 4,
//                       padding: EdgeInsets.symmetric(
//                           vertical: 15.0, horizontal: 25.0),
//                       onPressed: () {
//                         context.read<VitalHistoryBloc>().add(SyncSelectedDate(
//                             state.startDate, state.endDate,
//                             shouldRefresh: true, mergeTempToSelected: true));
//                         Navigator.pop(context);
//                       },
//                       // color: state.tempStartDate.year == state.tempEndDate.year && state.tempStartDate.month == state.tempEndDate.month && state.tempStartDate.day == state.tempEndDate.day
//                       //     ? ColorPallet.kFadedGrey
//                       //     : ColorPallet.kGreen,
//                       color: ColorPallet.kGreen,
//                       // labelColor:
//                       // state.tempStartDate.year == state.tempEndDate.year && state.tempStartDate.month == state.tempEndDate.month && state.tempStartDate.day == state.tempEndDate.day
//                       //     ?ColorPallet.kGrey.withOpacity(0.4)
//                       //     : ColorPallet.kBackButtonTextColor,
//                       labelColor: ColorPallet.kBackButtonTextColor,
//                       fontSize: FCStyle.mediumFontSize,
//                       fontWeight: FontWeight.bold,
//                       label: CommonStrings.done.tr(),
//                     ),
//                   ),
//                 ),
//               ],
//             ));
//         //    Stack(
//         //     alignment: Alignment.center,
//         //     // children: [
//         //     //   SingleChildScrollView(
//         //     //     physics: NeverScrollableScrollPhysics(),
//         //     //     child: Padding(
//         //     //       padding: const EdgeInsets.only(top: 20),
//         //     //       child: Row(
//         //     //         children: [
//         //     //           SizedBox(
//         //     //             width: 100,
//         //     //           ),
//         //     //           Flexible(
//         //     //               flex: 2,
//         //     //               child: Container(
//         //     //                   child: FCCalendarSetVitalDateRange(
//         //     //                       vitalHistoryBloc:
//         //     //                           context.read<VitalHistoryBloc>()))),
//         //     //           SizedBox(
//         //     //             width: FCStyle.blockSizeHorizontal * 5,
//         //     //           ),
//         //     //           Flexible(
//         //     //               flex: 1,
//         //     //               child: Column(
//         //     //                 crossAxisAlignment: CrossAxisAlignment.start,
//         //     //                 children: [
//         //     //                   Text(
//         //     //                     MedicationStrings.startDate.tr(),
//         //     //                     style: TextStyle(
//         //     //                       color: ColorPallet.kPrimaryTextColor,
//         //     //                       fontSize: FCStyle.mediumFontSize,
//         //     //                     ),
//         //     //                   ),
//         //     //                   ConcaveCard(
//         //     //                     radius: 20,
//         //     //                     child: Padding(
//         //     //                       padding: const EdgeInsets.only(
//         //     //                           left: 30, right: 30, bottom: 20, top: 20),
//         //     //                       child: Text(
//         //     //                         ((state.tempStartDate.year ==
//         //     //                                             DateTime.now().year &&
//         //     //                                         state.tempStartDate.month ==
//         //     //                                             DateTime.now().month &&
//         //     //                                         state.tempStartDate.day ==
//         //     //                                             DateTime.now().day) &&
//         //     //                                     (state.tempEndDate.year ==
//         //     //                                             DateTime.now().year &&
//         //     //                                         state.tempEndDate.month ==
//         //     //                                             DateTime.now().month &&
//         //     //                                         state.tempEndDate.day ==
//         //     //                                             DateTime.now().day)) ||
//         //     //                                 (state.tempStartDate ==
//         //     //                                     state.tempEndDate)
//         //     //                             ? "--"
//         //     //                             : DateFormat.MMMd()
//         //     //                                 .format(state.tempStartDate),
//         //     //                         style: TextStyle(
//         //     //                             color: ColorPallet.kPrimaryTextColor,
//         //     //                             fontSize: FCStyle.mediumFontSize,
//         //     //                             fontWeight: FontWeight.bold),
//         //     //                       ),
//         //     //                     ),
//         //     //                   ),
//         //     //                   SizedBox(
//         //     //                     height: 20,
//         //     //                   ),
//         //     //                   Text(
//         //     //                     MedicationStrings.endDate.tr(),
//         //     //                     style: TextStyle(
//         //     //                       color: ColorPallet.kPrimaryTextColor,
//         //     //                       fontSize: FCStyle.mediumFontSize,
//         //     //                     ),
//         //     //                   ),
//         //     //                   ConcaveCard(
//         //     //                     radius: 20,
//         //     //                     child: Padding(
//         //     //                       padding: const EdgeInsets.only(
//         //     //                           left: 30, right: 30, bottom: 20, top: 20),
//         //     //                       child: Text(
//         //     //                         ((state.tempStartDate.year ==
//         //     //                                             DateTime.now().year &&
//         //     //                                         state.tempStartDate.month ==
//         //     //                                             DateTime.now().month &&
//         //     //                                         state.tempStartDate.day ==
//         //     //                                             DateTime.now().day) &&
//         //     //                                     (state.tempEndDate.year ==
//         //     //                                             DateTime.now().year &&
//         //     //                                         state.tempEndDate.month ==
//         //     //                                             DateTime.now().month &&
//         //     //                                         state.tempEndDate.day ==
//         //     //                                             DateTime.now().day)) ||
//         //     //                                 (state.tempStartDate ==
//         //     //                                     state.tempEndDate)
//         //     //                             ? "--"
//         //     //                             : DateFormat.MMMd()
//         //     //                                 .format(state.tempEndDate),
//         //     //                         style: TextStyle(
//         //     //                             color: ColorPallet.kPrimaryTextColor,
//         //     //                             fontSize: FCStyle.mediumFontSize,
//         //     //                             fontWeight: FontWeight.bold),
//         //     //                       ),
//         //     //                     ),
//         //     //                   ),
//         //     //                   SizedBox(
//         //     //                     height: 20,
//         //     //                   ),
//         //     //                   Text(
//         //     //                     MedicationStrings.totalDays.tr(),
//         //     //                     style: TextStyle(
//         //     //                       color: ColorPallet.kPrimaryTextColor,
//         //     //                       fontSize: FCStyle.mediumFontSize,
//         //     //                     ),
//         //     //                   ),
//         //     //                   ConcaveCard(
//         //     //                     radius: 20,
//         //     //                     child: Padding(
//         //     //                       padding: const EdgeInsets.only(
//         //     //                           left: 30, right: 30, bottom: 20, top: 20),
//         //     //                       child: Text(
//         //     //                         getDifferenceOfStartAndEnd(
//         //     //                             state.tempStartDate, state.tempEndDate),
//         //     //                         style: TextStyle(
//         //     //                             color: ColorPallet.kPrimaryTextColor,
//         //     //                             fontSize: FCStyle.mediumFontSize,
//         //     //                             fontWeight: FontWeight.bold),
//         //     //                       ),
//         //     //                     ),
//         //     //                   ),
//         //     //                 ],
//         //     //               )),
//         //     //           SizedBox(
//         //     //             width: FCStyle.blockSizeHorizontal * 5,
//         //     //           ),
//         //     //         ],
//         //     //       ),
//         //     //     ),
//         //     //   ),
//         //     //   Align(
//         //     //     alignment: Alignment.topRight,
//         //     //     child: CloseIconButton(
//         //     //       size: FCStyle.largeFontSize * 2,
//         //     //     ),
//         //     //   ),
//         //     //   Align(
//         //     //     alignment: Alignment.bottomRight,
//         //     //     child: Padding(
//         //     //       padding: EdgeInsets.only(
//         //     //           right: FCStyle.blockSizeVertical * 2,
//         //     //           bottom: FCStyle.blockSizeVertical * 2),
//         //     //       child: FCPrimaryButton(
//         //     //         defaultSize: false,
//         //     //         width: FCStyle.blockSizeHorizontal * 7,
//         //     //         height: FCStyle.blockSizeVertical * 4,
//         //     //         padding:
//         //     //             EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
//         //     //         onPressed: () {
//         //     //           context.read<VitalHistoryBloc>().add(SyncSelectedDate(
//         //     //               state.tempStartDate, state.tempEndDate,
//         //     //               shouldRefresh: true, mergeTempToSelected: true));
//         //     //           Navigator.pop(context);
//         //     //         },
//         //     //         // color: state.tempStartDate.year == state.tempEndDate.year && state.tempStartDate.month == state.tempEndDate.month && state.tempStartDate.day == state.tempEndDate.day
//         //     //         //     ? ColorPallet.kFadedGrey
//         //     //         //     : ColorPallet.kGreen,
//         //     //         color: ColorPallet.kGreen,
//         //     //         // labelColor:
//         //     //         // state.tempStartDate.year == state.tempEndDate.year && state.tempStartDate.month == state.tempEndDate.month && state.tempStartDate.day == state.tempEndDate.day
//         //     //         //     ?ColorPallet.kGrey.withOpacity(0.4)
//         //     //         //     : ColorPallet.kBackButtonTextColor,
//         //     //         labelColor: ColorPallet.kBackButtonTextColor,
//         //     //         fontSize: FCStyle.mediumFontSize,
//         //     //         fontWeight: FontWeight.bold,
//         //     //         label: CommonStrings.done.tr(),
//         //     //       ),
//         //     //     ),
//         //     //   )
//         //     // ],

//         //     children: [
//         //       // Align(
//         //       //   alignment: Alignment.topRight,
//         //       //   child: CloseIconButton(
//         //       //     size: FCStyle.largeFontSize * 2,
//         //       //   ),
//         //       // ),
//         //       Positioned(
//         //         left: 0,
//         //         right: 0,
//         //         top: 0,
//         //         height: 70,
//         //         child: Container(
//         //           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//         //           color: ColorPallet.kPrimary.withOpacity(0.1),
//         //           child: Row(
//         //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //             children: [
//         //               // Column(
//         //               // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         //               // mainAxisSize: MainAxisSize.min,
//         //               // crossAxisAlignment: CrossAxisAlignment.start,
//         //               // children: <Widget>[
//         //               // Text('Selected date: $_selectedDate'),
//         //               // Text('Selected date count: $_dateCount'),
//         //               // Text('Selected range: $_range'),
//         //               // Text('Selected ranges count: $_rangeCount')
//         //               Text(
//         //                 'Calendar',
//         //                 style: TextStyle(
//         //                   fontSize: 45 * FCStyle.ffem,
//         //                   fontWeight: FontWeight.w600,
//         //                   height: 1 * FCStyle.ffem / FCStyle.fem,
//         //                   color: Color(0xff000000),
//         //                 ),
//         //               ),
//         //               //   ],
//         //               // ),
//         //               Container(
//         //                 margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
//         //                     0 * FCStyle.fem, 0 * FCStyle.fem, 1 * FCStyle.fem),
//         //                 child: TextButton(
//         //                   onPressed: () {
//         //                     fcRouter.pop();
//         //                   },
//         //                   style: TextButton.styleFrom(
//         //                     padding: EdgeInsets.zero,
//         //                   ),
//         //                   child: CircleAvatar(
//         //                     backgroundColor: const Color(0xFFAC2734),
//         //                     radius: 35 * FCStyle.fem,
//         //                     child: SvgPicture.asset(
//         //                       AssetIconPath.closeIcon,
//         //                       width: 35 * FCStyle.fem,
//         //                       height: 35 * FCStyle.fem,
//         //                     ),
//         //                   ),
//         //                 ),
//         //               ),
//         //             ],
//         //           ),
//         //         ),
//         //       ),
//         //       Container(
//         //         child: SfDateRangePicker(
//         //           onCancel: () {
//         //             context.read<VitalHistoryBloc>().add(SyncSelectedDate(
//         //                 _startDate ?? DateTime.now(),
//         //                 _endDate ?? DateTime.now(),
//         //                 shouldRefresh: false));
//         //           },
//         //           onSubmit: (p0) {
//         //             context<VitalHistoryBloc>().add(SyncSelectedDate(
//         //                 _startDate ?? DateTime.now(),
//         //                 _endDate ?? DateTime.now(),
//         //                 shouldRefresh: false));
//         //           }
//         //           // context.read<VitalHistoryBloc>().add(SyncSelectedDate(
//         //           //     _startDate, _endDate,
//         //           //     shouldRefresh: true, mergeTempToSelected: true));
//         //           ,
//         //           headerHeight: 50,
//         //           showNavigationArrow: true,
//         //           showActionButtons: true,
//         //           todayHighlightColor: Color.fromARGB(255, 89, 91, 196),
//         //           headerStyle: DateRangePickerHeaderStyle(
//         //               backgroundColor: Color.fromARGB(142, 241, 247, 255),
//         //               textAlign: TextAlign.center,
//         //               textStyle: TextStyle(
//         //                   fontSize: 30 * FCStyle.fem,
//         //                   fontWeight: FontWeight.bold,
//         //                   color: Color.fromARGB(255, 116, 116, 116))),
//         //           backgroundColor: Colors.white,
//         //           startRangeSelectionColor: Color.fromARGB(255, 89, 91, 196),
//         //           endRangeSelectionColor: Color.fromARGB(255, 89, 91, 196),
//         //           rangeSelectionColor: Color.fromARGB(255, 238, 239, 255),
//         //           rangeTextStyle: TextStyle(
//         //               color: Color.fromARGB(255, 89, 91, 196),
//         //               fontWeight: FontWeight.bold),
//         //           selectionTextStyle: TextStyle(
//         //               color: Color.fromARGB(255, 255, 255, 255),
//         //               fontWeight: FontWeight.bold),
//         //           view: DateRangePickerView.month,
//         //           onSelectionChanged: _onSelectionChanged,
//         //           selectionMode: DateRangePickerSelectionMode.range,
//         //           // initialSelectedRange: PickerDateRange(
//         //           //     DateTime.now().subtract(const Duration(days: 4)),
//         //           //     DateTime.now().add(const Duration(days: 3))),
//         //         ),
//         //       ),
//         //       Container(
//         //           child: _range != ''
//         //               ? Positioned(
//         //                   bottom: 10,
//         //                   left: 10,
//         //                   child: Row(
//         //                       crossAxisAlignment: CrossAxisAlignment.start,
//         //                       children: <Widget>[
//         //                         Text(
//         //                           'Selected range:',
//         //                           style: TextStyle(
//         //                               fontWeight: FontWeight.bold,
//         //                               color: Color.fromARGB(255, 131, 131, 131),
//         //                               fontSize: 22 * FCStyle.fem),
//         //                         ),
//         //                         Text(
//         //                           ' $_range',
//         //                           style: TextStyle(
//         //                               fontWeight: FontWeight.bold,
//         //                               color: Color.fromARGB(255, 131, 131, 131),
//         //                               fontSize: 22 * FCStyle.fem),
//         //                         ),
//         //                       ]))
//         //               : Text(''))
//         //     ],
//         //   ),
//         // );
//       },
//     );
//   }

//   String getDifferenceOfStartAndEnd(DateTime startDate, DateTime endDate) {
//     if (startDate ==
//             DateTime(DateTime.now().year, DateTime.now().month,
//                 DateTime.now().day) &&
//         endDate ==
//             DateTime(DateTime.now().year, DateTime.now().month,
//                 DateTime.now().day)) {
//       return "--";
//     } else if ((startDate.year == endDate.year &&
//         startDate.month == endDate.month &&
//         startDate.day == endDate.day)) {
//       return "--";
//     } else {
//       String differece = endDate.difference(startDate).inDays.toString();
//       if (differece.contains("-")) {
//         return "--";
//       } else {
//         return (int.parse(differece) + 1).toString() +
//             " " +
//             MedicationStrings.days.tr();
//       }
//     }
//   }
// }
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/router/router_delegate.dart';
import '../../../shared/close_icon_button.dart';
import '../../../shared/concave_card.dart';
import '../../../shared/fc_primary_button.dart';
import '../../../shared/popup_scaffold.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../../utils/constants/assets_paths.dart';
import '../../../utils/strings/common_strings.dart';
import '../../../utils/strings/medication_strings.dart';
import '../blocs/vital_history_bloc/vital_history_bloc.dart';
import '../widgets/calendar_get_vital_date_range.dart';

class SetVitalDateRange extends StatefulWidget {
  const SetVitalDateRange({Key? key}) : super(key: key);

  @override
  State<SetVitalDateRange> createState() => _SetVitalDateRangeState();
}

class _SetVitalDateRangeState extends State<SetVitalDateRange> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  DateTime _startDate = DateTime.now(), _endDate = DateTime.now();

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  // void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  /// The argument value will return the changed date as [DateTime] when the
  /// widget [SfDateRangeSelectionMode] set as single.
  ///
  /// The argument value will return the changed dates as [List<DateTime>]
  /// when the widget [SfDateRangeSelectionMode] set as multiple.
  ///
  /// The argument value will return the changed range as [PickerDateRange]
  /// when the widget [SfDateRangeSelectionMode] set as range.
  ///
  /// The argument value will return the changed ranges as
  /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
  /// multi range.
  // setState(() {
  //   if (args.value is PickerDateRange) {
  //     _startDate = args.value.startDate;
  //     _endDate = args.value.endDate ?? args.value.startDate;
  //     _range = '${DateFormat('MMMM d, y').format(args.value.startDate)} -'
  //         // ignore: lines_longer_than_80_chars
  //         ' ${DateFormat('MMMM d, y').format(args.value.endDate ?? args.value.startDate)}';
  //   } else if (args.value is DateTime) {
  //     _selectedDate = args.value.toString();
  //   } else if (args.value is List<DateTime>) {
  //     _dateCount = args.value.length.toString();
  //   } else {
  //     _rangeCount = args.value.length.toString();
  //   }
  // });
  //}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VitalHistoryBloc, VitalHistoryState>(
      builder: (context, state) {
        return PopupScaffold(
            height: 400,
            constrained: false,
            bodyColor: Colors.transparent,
            backgroundColor: Color.fromARGB(135, 0, 0, 0),
            child: Stack(
              children: [
                FCCalendarSetVitalDateRange(
                    vitalHistoryBloc: context.read<VitalHistoryBloc>()),
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: Padding(
                //     padding: EdgeInsets.only(
                //         right: FCStyle.blockSizeVertical * 2,
                //         bottom: FCStyle.blockSizeVertical * 2),
                //     child: FCPrimaryButton(
                //       defaultSize: false,
                //       width: FCStyle.blockSizeHorizontal * 7,
                //       height: FCStyle.blockSizeVertical * 4,
                //       padding: EdgeInsets.symmetric(
                //           vertical: 15.0, horizontal: 25.0),
                //       onPressed: () {
                //         context.read<VitalHistoryBloc>().add(SyncSelectedDate(
                //             state.startDate, state.endDate,
                //             shouldRefresh: true, mergeTempToSelected: true));
                //         Navigator.pop(context);
                //       },
                //       // color: state.tempStartDate.year == state.tempEndDate.year && state.tempStartDate.month == state.tempEndDate.month && state.tempStartDate.day == state.tempEndDate.day
                //       //     ? ColorPallet.kFadedGrey
                //       //     : ColorPallet.kGreen,
                //       color: ColorPallet.kGreen,
                //       // labelColor:
                //       // state.tempStartDate.year == state.tempEndDate.year && state.tempStartDate.month == state.tempEndDate.month && state.tempStartDate.day == state.tempEndDate.day
                //       //     ?ColorPallet.kGrey.withOpacity(0.4)
                //       //     : ColorPallet.kBackButtonTextColor,
                //       labelColor: ColorPallet.kBackButtonTextColor,
                //       fontSize: FCStyle.mediumFontSize,
                //       fontWeight: FontWeight.bold,
                //       label: CommonStrings.done.tr(),
                //     ),
                //   ),
                // ),
              ],
            ));
        //    Stack(
        //     alignment: Alignment.center,
        //     // children: [
        //     //   SingleChildScrollView(
        //     //     physics: NeverScrollableScrollPhysics(),
        //     //     child: Padding(
        //     //       padding: const EdgeInsets.only(top: 20),
        //     //       child: Row(
        //     //         children: [
        //     //           SizedBox(
        //     //             width: 100,
        //     //           ),
        //     //           Flexible(
        //     //               flex: 2,
        //     //               child: Container(
        //     //                   child: FCCalendarSetVitalDateRange(
        //     //                       vitalHistoryBloc:
        //     //                           context.read<VitalHistoryBloc>()))),
        //     //           SizedBox(
        //     //             width: FCStyle.blockSizeHorizontal * 5,
        //     //           ),
        //     //           Flexible(
        //     //               flex: 1,
        //     //               child: Column(
        //     //                 crossAxisAlignment: CrossAxisAlignment.start,
        //     //                 children: [
        //     //                   Text(
        //     //                     MedicationStrings.startDate.tr(),
        //     //                     style: TextStyle(
        //     //                       color: ColorPallet.kPrimaryTextColor,
        //     //                       fontSize: FCStyle.mediumFontSize,
        //     //                     ),
        //     //                   ),
        //     //                   ConcaveCard(
        //     //                     radius: 20,
        //     //                     child: Padding(
        //     //                       padding: const EdgeInsets.only(
        //     //                           left: 30, right: 30, bottom: 20, top: 20),
        //     //                       child: Text(
        //     //                         ((state.tempStartDate.year ==
        //     //                                             DateTime.now().year &&
        //     //                                         state.tempStartDate.month ==
        //     //                                             DateTime.now().month &&
        //     //                                         state.tempStartDate.day ==
        //     //                                             DateTime.now().day) &&
        //     //                                     (state.tempEndDate.year ==
        //     //                                             DateTime.now().year &&
        //     //                                         state.tempEndDate.month ==
        //     //                                             DateTime.now().month &&
        //     //                                         state.tempEndDate.day ==
        //     //                                             DateTime.now().day)) ||
        //     //                                 (state.tempStartDate ==
        //     //                                     state.tempEndDate)
        //     //                             ? "--"
        //     //                             : DateFormat.MMMd()
        //     //                                 .format(state.tempStartDate),
        //     //                         style: TextStyle(
        //     //                             color: ColorPallet.kPrimaryTextColor,
        //     //                             fontSize: FCStyle.mediumFontSize,
        //     //                             fontWeight: FontWeight.bold),
        //     //                       ),
        //     //                     ),
        //     //                   ),
        //     //                   SizedBox(
        //     //                     height: 20,
        //     //                   ),
        //     //                   Text(
        //     //                     MedicationStrings.endDate.tr(),
        //     //                     style: TextStyle(
        //     //                       color: ColorPallet.kPrimaryTextColor,
        //     //                       fontSize: FCStyle.mediumFontSize,
        //     //                     ),
        //     //                   ),
        //     //                   ConcaveCard(
        //     //                     radius: 20,
        //     //                     child: Padding(
        //     //                       padding: const EdgeInsets.only(
        //     //                           left: 30, right: 30, bottom: 20, top: 20),
        //     //                       child: Text(
        //     //                         ((state.tempStartDate.year ==
        //     //                                             DateTime.now().year &&
        //     //                                         state.tempStartDate.month ==
        //     //                                             DateTime.now().month &&
        //     //                                         state.tempStartDate.day ==
        //     //                                             DateTime.now().day) &&
        //     //                                     (state.tempEndDate.year ==
        //     //                                             DateTime.now().year &&
        //     //                                         state.tempEndDate.month ==
        //     //                                             DateTime.now().month &&
        //     //                                         state.tempEndDate.day ==
        //     //                                             DateTime.now().day)) ||
        //     //                                 (state.tempStartDate ==
        //     //                                     state.tempEndDate)
        //     //                             ? "--"
        //     //                             : DateFormat.MMMd()
        //     //                                 .format(state.tempEndDate),
        //     //                         style: TextStyle(
        //     //                             color: ColorPallet.kPrimaryTextColor,
        //     //                             fontSize: FCStyle.mediumFontSize,
        //     //                             fontWeight: FontWeight.bold),
        //     //                       ),
        //     //                     ),
        //     //                   ),
        //     //                   SizedBox(
        //     //                     height: 20,
        //     //                   ),
        //     //                   Text(
        //     //                     MedicationStrings.totalDays.tr(),
        //     //                     style: TextStyle(
        //     //                       color: ColorPallet.kPrimaryTextColor,
        //     //                       fontSize: FCStyle.mediumFontSize,
        //     //                     ),
        //     //                   ),
        //     //                   ConcaveCard(
        //     //                     radius: 20,
        //     //                     child: Padding(
        //     //                       padding: const EdgeInsets.only(
        //     //                           left: 30, right: 30, bottom: 20, top: 20),
        //     //                       child: Text(
        //     //                         getDifferenceOfStartAndEnd(
        //     //                             state.tempStartDate, state.tempEndDate),
        //     //                         style: TextStyle(
        //     //                             color: ColorPallet.kPrimaryTextColor,
        //     //                             fontSize: FCStyle.mediumFontSize,
        //     //                             fontWeight: FontWeight.bold),
        //     //                       ),
        //     //                     ),
        //     //                   ),
        //     //                 ],
        //     //               )),
        //     //           SizedBox(
        //     //             width: FCStyle.blockSizeHorizontal * 5,
        //     //           ),
        //     //         ],
        //     //       ),
        //     //     ),
        //     //   ),
        //     //   Align(
        //     //     alignment: Alignment.topRight,
        //     //     child: CloseIconButton(
        //     //       size: FCStyle.largeFontSize * 2,
        //     //     ),
        //     //   ),
        //     //   Align(
        //     //     alignment: Alignment.bottomRight,
        //     //     child: Padding(
        //     //       padding: EdgeInsets.only(
        //     //           right: FCStyle.blockSizeVertical * 2,
        //     //           bottom: FCStyle.blockSizeVertical * 2),
        //     //       child: FCPrimaryButton(
        //     //         defaultSize: false,
        //     //         width: FCStyle.blockSizeHorizontal * 7,
        //     //         height: FCStyle.blockSizeVertical * 4,
        //     //         padding:
        //     //             EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
        //     //         onPressed: () {
        //     //           context.read<VitalHistoryBloc>().add(SyncSelectedDate(
        //     //               state.tempStartDate, state.tempEndDate,
        //     //               shouldRefresh: true, mergeTempToSelected: true));
        //     //           Navigator.pop(context);
        //     //         },
        //     //         // color: state.tempStartDate.year == state.tempEndDate.year && state.tempStartDate.month == state.tempEndDate.month && state.tempStartDate.day == state.tempEndDate.day
        //     //         //     ? ColorPallet.kFadedGrey
        //     //         //     : ColorPallet.kGreen,
        //     //         color: ColorPallet.kGreen,
        //     //         // labelColor:
        //     //         // state.tempStartDate.year == state.tempEndDate.year && state.tempStartDate.month == state.tempEndDate.month && state.tempStartDate.day == state.tempEndDate.day
        //     //         //     ?ColorPallet.kGrey.withOpacity(0.4)
        //     //         //     : ColorPallet.kBackButtonTextColor,
        //     //         labelColor: ColorPallet.kBackButtonTextColor,
        //     //         fontSize: FCStyle.mediumFontSize,
        //     //         fontWeight: FontWeight.bold,
        //     //         label: CommonStrings.done.tr(),
        //     //       ),
        //     //     ),
        //     //   )
        //     // ],

        //     children: [
        //       // Align(
        //       //   alignment: Alignment.topRight,
        //       //   child: CloseIconButton(
        //       //     size: FCStyle.largeFontSize * 2,
        //       //   ),
        //       // ),
        //       Positioned(
        //         left: 0,
        //         right: 0,
        //         top: 0,
        //         height: 70,
        //         child: Container(
        //           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        //           color: ColorPallet.kPrimary.withOpacity(0.1),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               // Column(
        //               // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //               // mainAxisSize: MainAxisSize.min,
        //               // crossAxisAlignment: CrossAxisAlignment.start,
        //               // children: <Widget>[
        //               // Text('Selected date: $_selectedDate'),
        //               // Text('Selected date count: $_dateCount'),
        //               // Text('Selected range: $_range'),
        //               // Text('Selected ranges count: $_rangeCount')
        //               Text(
        //                 'Calendar',
        //                 style: TextStyle(
        //                   fontSize: 45 * FCStyle.ffem,
        //                   fontWeight: FontWeight.w600,
        //                   height: 1 * FCStyle.ffem / FCStyle.fem,
        //                   color: Color(0xff000000),
        //                 ),
        //               ),
        //               //   ],
        //               // ),
        //               Container(
        //                 margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
        //                     0 * FCStyle.fem, 0 * FCStyle.fem, 1 * FCStyle.fem),
        //                 child: TextButton(
        //                   onPressed: () {
        //                     fcRouter.pop();
        //                   },
        //                   style: TextButton.styleFrom(
        //                     padding: EdgeInsets.zero,
        //                   ),
        //                   child: CircleAvatar(
        //                     backgroundColor: const Color(0xFFAC2734),
        //                     radius: 35 * FCStyle.fem,
        //                     child: SvgPicture.asset(
        //                       AssetIconPath.closeIcon,
        //                       width: 35 * FCStyle.fem,
        //                       height: 35 * FCStyle.fem,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //       Container(
        //         child: SfDateRangePicker(
        //           onCancel: () {
        //             context.read<VitalHistoryBloc>().add(SyncSelectedDate(
        //                 _startDate ?? DateTime.now(),
        //                 _endDate ?? DateTime.now(),
        //                 shouldRefresh: false));
        //           },
        //           onSubmit: (p0) {
        //             context<VitalHistoryBloc>().add(SyncSelectedDate(
        //                 _startDate ?? DateTime.now(),
        //                 _endDate ?? DateTime.now(),
        //                 shouldRefresh: false));
        //           }
        //           // context.read<VitalHistoryBloc>().add(SyncSelectedDate(
        //           //     _startDate, _endDate,
        //           //     shouldRefresh: true, mergeTempToSelected: true));
        //           ,
        //           headerHeight: 50,
        //           showNavigationArrow: true,
        //           showActionButtons: true,
        //           todayHighlightColor: Color.fromARGB(255, 89, 91, 196),
        //           headerStyle: DateRangePickerHeaderStyle(
        //               backgroundColor: Color.fromARGB(142, 241, 247, 255),
        //               textAlign: TextAlign.center,
        //               textStyle: TextStyle(
        //                   fontSize: 30 * FCStyle.fem,
        //                   fontWeight: FontWeight.bold,
        //                   color: Color.fromARGB(255, 116, 116, 116))),
        //           backgroundColor: Colors.white,
        //           startRangeSelectionColor: Color.fromARGB(255, 89, 91, 196),
        //           endRangeSelectionColor: Color.fromARGB(255, 89, 91, 196),
        //           rangeSelectionColor: Color.fromARGB(255, 238, 239, 255),
        //           rangeTextStyle: TextStyle(
        //               color: Color.fromARGB(255, 89, 91, 196),
        //               fontWeight: FontWeight.bold),
        //           selectionTextStyle: TextStyle(
        //               color: Color.fromARGB(255, 255, 255, 255),
        //               fontWeight: FontWeight.bold),
        //           view: DateRangePickerView.month,
        //           onSelectionChanged: _onSelectionChanged,
        //           selectionMode: DateRangePickerSelectionMode.range,
        //           // initialSelectedRange: PickerDateRange(
        //           //     DateTime.now().subtract(const Duration(days: 4)),
        //           //     DateTime.now().add(const Duration(days: 3))),
        //         ),
        //       ),
        //       Container(
        //           child: _range != ''
        //               ? Positioned(
        //                   bottom: 10,
        //                   left: 10,
        //                   child: Row(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: <Widget>[
        //                         Text(
        //                           'Selected range:',
        //                           style: TextStyle(
        //                               fontWeight: FontWeight.bold,
        //                               color: Color.fromARGB(255, 131, 131, 131),
        //                               fontSize: 22 * FCStyle.fem),
        //                         ),
        //                         Text(
        //                           ' $_range',
        //                           style: TextStyle(
        //                               fontWeight: FontWeight.bold,
        //                               color: Color.fromARGB(255, 131, 131, 131),
        //                               fontSize: 22 * FCStyle.fem),
        //                         ),
        //                       ]))
        //               : Text(''))
        //     ],
        //   ),
        // );
      },
    );
  }

  String getDifferenceOfStartAndEnd(DateTime startDate, DateTime endDate) {
    if (startDate ==
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day) &&
        endDate ==
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day)) {
      return "--";
    } else if ((startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day)) {
      return "--";
    } else {
      String differece = endDate.difference(startDate).inDays.toString();
      if (differece.contains("-")) {
        return "--";
      } else {
        return (int.parse(differece) + 1).toString() +
            " " +
            MedicationStrings.days.tr();
      }
    }
  }
}
