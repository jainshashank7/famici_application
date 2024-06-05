import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/blocs/add_medication/add_medication_bloc.dart';
import 'package:famici/feature/vitals/blocs/vital_history_bloc/vital_history_bloc.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/helpers/widget_key.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/router/router_delegate.dart';
import '../../../shared/fc_material_button.dart';
import 'calendar_utils.dart';

class FCCalendarSetVitalDateRange extends StatefulWidget {
  const FCCalendarSetVitalDateRange({Key? key, required this.vitalHistoryBloc})
      : super(key: key);

  final VitalHistoryBloc vitalHistoryBloc;

  @override
  _FCCalendarSetVitalDateRangeState createState() =>
      _FCCalendarSetVitalDateRangeState();
}

class _FCCalendarSetVitalDateRangeState
    extends State<FCCalendarSetVitalDateRange> {
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
  //   setState(() {
  //     if (args.value is PickerDateRange) {
  //       print('hello ishameme ' + args.value.startDate.toString());
  //       print('hello ishameme ' + args.value.endDate.toString());
  //       _startDate = args.value.startDate;
  //       _endDate = (args.value.endDate ?? args.value.startDate);
  //       _range = '${DateFormat('MMMM d, y').format(args.value.startDate)} -'
  //           // ignore: lines_longer_than_80_chars
  //           ' ${DateFormat('MMMM d, y').format(args.value.endDate ?? args.value.startDate)}';
  //     } else if (args.value is DateTime) {
  //       _selectedDate = args.value.toString();
  //     } else if (args.value is List<DateTime>) {
  //       _dateCount = args.value.length.toString();
  //     } else {
  //       _rangeCount = args.value.length.toString();
  //     }
  //   });
  // }

  // late final PageController _pageController;
  // final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  // final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
  //   equals: isSameDay,
  //   hashCode: getHashCode,
  // );
  // CalendarFormat _calendarFormat = CalendarFormat.month;
  // RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  // DateTime? _rangeStart;
  // DateTime? _rangeEnd;
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  String? errorStartDateText = '';
  String? errorEndDateText = '';
  // String _StartDateString = '';
  // String _EndDateString = '';
  // void setSelectedRange() {
  //   setState(() {
  //     _rangeSelectionMode = RangeSelectionMode.toggledOn;
  //     _rangeStart = widget.vitalHistoryBloc.state.startDate;
  //     _rangeEnd = widget.vitalHistoryBloc.state.startDate;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // _selectedDays.add(_focusedDay.value);
    // setSelectedRange();
  }

  @override
  void dispose() {
    // _focusedDay.dispose();
    super.dispose();
  }

  // bool get canClearSelection =>
  //     _selectedDays.isNotEmpty || _rangeStart != null || _rangeEnd != null;

  // void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
  //   setState(() {
  //     if (_selectedDays.contains(selectedDay)) {
  //       _selectedDays.remove(selectedDay);
  //     } else {
  //       _selectedDays.add(selectedDay);
  //     }

  //     _focusedDay.value = focusedDay;
  //     _rangeStart = null;
  //     _rangeEnd = null;
  //     _rangeSelectionMode = RangeSelectionMode.toggledOff;
  //   });
  // }

  // void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
  //   if (end != null &&
  //       (end.isBefore(DateTime(
  //               start?.year ?? 0, start?.month ?? 0, (start?.day ?? 0) - 6)) ||
  //           end.isAfter(DateTime(
  //               start?.year ?? 0, start?.month ?? 0, (start?.day ?? 0) + 7)))) {
  //     setState(() {
  //       _focusedDay.value = focusedDay;
  //       _rangeStart = end;
  //       _rangeEnd = end;
  //       _selectedDays.clear();
  //       _rangeSelectionMode = RangeSelectionMode.enforced;
  //       widget.vitalHistoryBloc.add(SyncSelectedDate(
  //           _rangeStart ?? DateTime.now(),
  //           _rangeEnd ?? _rangeStart ?? DateTime.now(),
  //           shouldRefresh: false));
  //     });
  //   } else {
  //     setState(() {
  //       _focusedDay.value = focusedDay;
  //       _rangeStart = start;
  //       _rangeEnd = end;
  //       _selectedDays.clear();
  //       _rangeSelectionMode = RangeSelectionMode.toggledOn;
  //       widget.vitalHistoryBloc.add(SyncSelectedDate(
  //           _rangeStart ?? DateTime.now(),
  //           _rangeEnd ?? _rangeStart ?? DateTime.now(),
  //           shouldRefresh: false));
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      color: Colors.white,
      child: Stack(children: <Widget>[
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: 70,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            color: ColorPallet.kPrimary.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.start,
                // children: <Widget>[
                // Text('Selected date: $_selectedDate'),
                // Text('Selected date count: $_dateCount'),
                // Text('Selected range: $_range'),
                // Text('Selected ranges count: $_rangeCount')
                Text(
                  'Calendar',
                  style: TextStyle(
                    fontSize: 45 * FCStyle.ffem,
                    fontWeight: FontWeight.w600,
                    height: 1 * FCStyle.ffem / FCStyle.fem,
                    color: Color(0xff000000),
                  ),
                ),
                //   ],
                // ),
                Container(
                  margin: EdgeInsets.fromLTRB(0 * FCStyle.fem, 0 * FCStyle.fem,
                      0 * FCStyle.fem, 1 * FCStyle.fem),
                  child: TextButton(
                    onPressed: () {
                      fcRouter.pop();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFFAC2734),
                      radius: 35 * FCStyle.fem,
                      child: SvgPicture.asset(
                        AssetIconPath.closeIcon,
                        width: 35 * FCStyle.fem,
                        height: 35 * FCStyle.fem,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 70,
          right: 0,
          bottom: 0,
          child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Choose Start Date',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                        width: 290,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              showDatePicker(
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                      data: ThemeData.light().copyWith(
                                        primaryColor: ColorPallet.kPrimary,
                                        splashColor: Colors.black,
                                        accentColor: ColorPallet.kPrimary,
                                        colorScheme: ColorScheme.light(
                                            onPrimary: ColorPallet.kPrimaryText,
                                            primary: ColorPallet.kPrimary),
                                        buttonTheme: ButtonThemeData(
                                            textTheme: ButtonTextTheme.primary),
                                      ),
                                      child: child ?? SizedBox.shrink());
                                },
                                helpText: 'Select Start Date',
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2001),
                                lastDate: DateTime.now(),
                                initialEntryMode:
                                    DatePickerEntryMode.calendarOnly,
                              ).then((date) {
                                setState(() {
                                  date != null ? _startDate = date! : '';
                                  date != null
                                      ? _startDateController.text =
                                          DateFormat('MMMM d, y')
                                              .format(_startDate)
                                      : '';
                                });
                              });
                            });
                          },
                          child: IgnorePointer(
                            child: TextField(
                              readOnly: true,
                              controller: _startDateController,
                              decoration: InputDecoration(
                                labelText: '',
                                errorText: errorStartDateText,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Choose End Date',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                        width: 290,
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                showDatePicker(
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return Theme(
                                        data: ThemeData.light().copyWith(
                                          primaryColor: ColorPallet.kPrimary,
                                          accentColor: ColorPallet.kPrimary,
                                          colorScheme: ColorScheme.light(
                                              onPrimary:
                                                  ColorPallet.kPrimaryText,
                                              primary: ColorPallet.kPrimary),
                                          buttonTheme: ButtonThemeData(
                                              textTheme:
                                                  ButtonTextTheme.primary),
                                        ),
                                        child: child ?? SizedBox.shrink());
                                  },
                                  helpText: 'Select End Date',
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2001),
                                  lastDate: DateTime.now(),
                                  initialEntryMode:
                                      DatePickerEntryMode.calendarOnly,
                                ).then((date) {
                                  setState(() {
                                    date != null ? _endDate = date! : '';
                                    date != null
                                        ? _endDateController.text =
                                            DateFormat('MMMM d, y')
                                                .format(_endDate)
                                        : '';
                                  });
                                });
                              });
                            },
                            child:
                                //  Column(
                                //   children: [
                                //     Container(
                                //         decoration: BoxDecoration(
                                //             border: Border.all(
                                //           color: Color.fromARGB(30, 0, 0, 0),
                                //           width: 1,
                                //         )),
                                //         padding: EdgeInsets.symmetric(
                                //             vertical: 5, horizontal: 15),
                                //         child: Column(
                                //           children: [
                                //             Row(
                                //               children: [
                                //                 Text(
                                //                   _EndDateString,
                                //                   style: TextStyle(
                                //                       fontWeight: FontWeight.w700,
                                //                       fontSize: 18),
                                //                 ),
                                //                 SizedBox(
                                //                   width: 20,
                                //                 ),
                                //                 Icon(
                                //                   Icons.arrow_drop_down,
                                //                   size: 20,
                                //                 )
                                //               ],
                                //             ),
                                //           ],
                                //         )
                                //         // child: DropdownButton<DateTime>(
                                //         //     hint: Text('Choose A Date'),
                                //         //     items: ['${DateFormat('MMMM d, y').format(_startDate)}']
                                //         //         .map((e) => DropdownMenuItem<DateTime>(child: Text(e)))
                                //         //         .toList(),
                                //         //     onChanged: (DateTime? value) {
                                //         //       setState(() {
                                //         //         showDatePicker(
                                //         //                 helpText: 'Select Start Date',
                                //         //                 context: context,
                                //         //                 initialDate: DateTime.now(),
                                //         //                 firstDate: DateTime(2001),
                                //         //                 lastDate: DateTime(2099))
                                //         //             .then((date) {
                                //         //           setState(() {
                                //         //             date != null ? _startDate = date! : '';
                                //         //           });
                                //         //         });
                                //         //       });
                                //         //     }),
                                //         ),
                                //     _endDate.compareTo(_startDate) < 0
                                //         ? Text(
                                //             'The Start Date should be smaller than End Date',
                                //             style: TextStyle(
                                //                 fontWeight: FontWeight.w700,
                                //                 fontSize: 15))
                                //         : Text('')
                                //   ],
                                // ),
                                IgnorePointer(
                              child: TextField(
                                controller: _endDateController,
                                decoration: InputDecoration(
                                  labelText: '',
                                  errorText: errorEndDateText,
                                ),
                              ),
                            )),
                      )
                    ],
                  )),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FCMaterialButton(
                        elevation: 0,
                        color: ColorPallet.kPrimary,
                        isBorder: false,
                        defaultSize: true,
                        borderRadius: BorderRadius.circular(8),
                        onPressed: () {
                          setState(() {
                            if (_endDateController.text == '' &&
                                _startDateController.text == '') {
                              errorStartDateText = 'Please enter Start Date';
                              errorEndDateText = 'Please enter End Date';
                            } else if (_startDateController.text == '') {
                              errorStartDateText = 'Please enter Start Date';
                            } else if (_endDateController.text == '') {
                              errorEndDateText = 'Please enter End Date';
                            } else if (_endDate.compareTo(_startDate) > 0) {
                              widget.vitalHistoryBloc.add(SyncSelectedDate(
                                  _startDate, _endDate,
                                  shouldRefresh: true));

                              fcRouter.pop();
                            } else {
                              errorStartDateText =
                                  'The Start Date should be smaller than End Date';
                              errorEndDateText =
                                  'The End Date should be bigger than Start Date';
                            }
                          });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Submit',
                                style: FCStyle.textStyle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25 * FCStyle.fem,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FCMaterialButton(
                        elevation: 0,
                        color: Colors.white,
                        isBorder: true,
                        borderColor: ColorPallet.kPrimary,
                        defaultSize: true,
                        borderRadius: BorderRadius.circular(8),
                        onPressed: () {
                          setState(() {
                            _endDateController.text = '';
                            _startDateController.text = '';
                            errorStartDateText = '';
                            errorEndDateText = '';
                            _startDate = DateTime.now();
                            _endDate = DateTime.now();
                          });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Reset',
                                style: FCStyle.textStyle.copyWith(
                                  color: ColorPallet.kPrimary,
                                  fontSize: 25 * FCStyle.fem,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FCMaterialButton(
                        elevation: 0,
                        color: Colors.white,
                        isBorder: true,
                        borderColor: Color.fromARGB(255, 99, 0, 0),
                        defaultSize: true,
                        borderRadius: BorderRadius.circular(8),
                        onPressed: () {
                          fcRouter.pop();
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Cancel',
                                style: FCStyle.textStyle.copyWith(
                                  color: Color.fromARGB(255, 99, 0, 0),
                                  fontSize: 25 * FCStyle.fem,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ))
                ],
              )),
        )
        // Positioned(
        //   left: 0,
        //   top: 70,
        //   width: 300,
        //   bottom: 0,
        //   child: SfDateRangePicker(
        //     onSelectionChanged: _onSelectionChanged,
        //     selectionMode: DateRangePickerSelectionMode.range,
        //     initialSelectedRange: PickerDateRange(
        //         DateTime.now().subtract(const Duration(days: 4)),
        //         DateTime.now().add(const Duration(days: 3))),
        //   ),
        // )
      ]),
    );

    // return Stack(
    //   alignment: Alignment.center,
    //   children: [
    //     // Align(
    //     //   alignment: Alignment.topRight,
    //     //   child: CloseIconButton(
    //     //     size: FCStyle.largeFontSize * 2,
    //     //   ),
    //     // ),
    //     Positioned(
    //       left: 0,
    //       right: 0,
    //       top: 0,
    //       height: 70,
    //       child: Container(
    //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    //         color: ColorPallet.kPrimary.withOpacity(0.1),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             // Column(
    //             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //             // mainAxisSize: MainAxisSize.min,
    //             // crossAxisAlignment: CrossAxisAlignment.start,
    //             // children: <Widget>[
    //             // Text('Selected date: $_selectedDate'),
    //             // Text('Selected date count: $_dateCount'),
    //             // Text('Selected range: $_range'),
    //             // Text('Selected ranges count: $_rangeCount')
    //             Text(
    //               'Calendar',
    //               style: TextStyle(
    //                 fontSize: 45 * FCStyle.ffem,
    //                 fontWeight: FontWeight.w600,
    //                 height: 1 * FCStyle.ffem / FCStyle.fem,
    //                 color: Color(0xff000000),
    //               ),
    //             ),
    //             //   ],
    //             // ),
    //             Container(
    //               margin: EdgeInsets.fromLTRB(0 * FCStyle.fem, 0 * FCStyle.fem,
    //                   0 * FCStyle.fem, 1 * FCStyle.fem),
    //               child: TextButton(
    //                 onPressed: () {
    //                   fcRouter.pop();
    //                 },
    //                 style: TextButton.styleFrom(
    //                   padding: EdgeInsets.zero,
    //                 ),
    //                 child: CircleAvatar(
    //                   backgroundColor: const Color(0xFFAC2734),
    //                   radius: 35 * FCStyle.fem,
    //                   child: SvgPicture.asset(
    //                     AssetIconPath.closeIcon,
    //                     width: 35 * FCStyle.fem,
    //                     height: 35 * FCStyle.fem,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //     Container(
    //       height: 100,
    //       child: SfDateRangePicker(
    //         onCancel: () {
    //           Navigator.pop(context);
    //         },
    //         onSubmit: (value) {
    //           // context<VitalHistoryBloc>().add(SyncSelectedDate(
    //           //     _startDate ?? DateTime.now(),
    //           //     _endDate ?? DateTime.now(),
    //           //     shouldRefresh: false));
    //           // if (value is PickerDateRange) {
    //           //   final DateTime rangeStartDate = value.startDate!;
    //           //   final DateTime rangeEndDate = value.endDate!;
    //           //   setState(() {
    //           //     widget.vitalHistoryBloc.add(SyncSelectedDate(
    //           //         // _rangeStart ?? DateTime.now(),
    //           //         // _rangeEnd ?? _rangeStart ?? DateTime.now(),
    //           //         rangeStartDate,
    //           //         rangeEndDate,
    //           //         shouldRefresh: false));
    //           //   });
    //           // } else if (value is DateTime) {
    //           //   final DateTime selectedDate = value;
    //           // } else if (value is List<DateTime>) {
    //           //   final List<DateTime> selectedDates = value;
    //           // } else if (value is List<PickerDateRange>) {
    //           //   final List<PickerDateRange> selectedRanges = value;
    //           // }

    //           //   context.read<VitalHistoryBloc>().add(SyncSelectedDate(
    //           //       _rangeStart ?? DateTime.now(),
    //           //       _rangeEnd ?? _rangeStart ?? DateTime.now(),
    //           //       shouldRefresh: true,
    //           //       mergeTempToSelected: true));
    //           // });
    //           setState(() {
    //             widget.vitalHistoryBloc.add(SyncSelectedDate(
    //                 // _rangeStart ?? DateTime.now(),
    //                 // _rangeEnd ?? _rangeStart ?? DateTime.now(),
    //                 _startDate,
    //                 _endDate,
    //                 shouldRefresh: true));
    //             print(
    //                 'ish startDateInCalendar ${_startDate} and endate ${_endDate}');
    //           });
    //           Navigator.pop(context);
    //         }
    //         // context.read<VitalHistoryBloc>().add(SyncSelectedDate(
    //         //     _startDate, _endDate,
    //         //     shouldRefresh: true, mergeTempToSelected: true));
    //         ,
    //         maxDate: DateTime.now(),
    //         headerHeight: 50,
    //         showNavigationArrow: true,
    //         showActionButtons: true,
    //         todayHighlightColor: Color.fromARGB(255, 89, 91, 196),
    //         headerStyle: DateRangePickerHeaderStyle(
    //             backgroundColor: Color.fromARGB(142, 241, 247, 255),
    //             textAlign: TextAlign.center,
    //             textStyle: TextStyle(
    //                 fontSize: 30 * FCStyle.fem,
    //                 fontWeight: FontWeight.bold,
    //                 color: Color.fromARGB(255, 116, 116, 116))),
    //         backgroundColor: Colors.white,
    //         startRangeSelectionColor: Color.fromARGB(255, 89, 91, 196),
    //         endRangeSelectionColor: Color.fromARGB(255, 89, 91, 196),
    //         rangeSelectionColor: Color.fromARGB(255, 238, 239, 255),
    //         rangeTextStyle: TextStyle(
    //             color: Color.fromARGB(255, 89, 91, 196),
    //             fontWeight: FontWeight.bold),
    //         selectionTextStyle: TextStyle(
    //             color: Color.fromARGB(255, 255, 255, 255),
    //             fontWeight: FontWeight.bold),
    //         view: DateRangePickerView.month,
    //         onSelectionChanged: _onSelectionChanged,
    //         selectionMode: DateRangePickerSelectionMode.range,
    //         // initialSelectedRange: PickerDateRange(
    //         //     DateTime.now().subtract(const Duration(days: 4)),
    //         //     DateTime.now().add(const Duration(days: 3))),
    //       ),
    //     ),

    //     Container(
    //         child: _range != ''
    //             ? Positioned(
    //                 bottom: 10,
    //                 left: 10,
    //                 child: Row(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: <Widget>[
    //                       Text(
    //                         'Selected range:',
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.bold,
    //                             color: Color.fromARGB(255, 131, 131, 131),
    //                             fontSize: 22 * FCStyle.fem),
    //                       ),
    //                       Text(
    //                         ' $_range',
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.bold,
    //                             color: Color.fromARGB(255, 131, 131, 131),
    //                             fontSize: 22 * FCStyle.fem),
    //                       ),
    //                     ]))
    //             : Text(''))
    //   ],
    // );

    //  Column(
    //   children: [
    //     ValueListenableBuilder<DateTime>(
    //       valueListenable: _focusedDay,
    //       builder: (context, value, _) {
    //         return _CalendarHeader(
    //           focusedDay: value,
    //           clearButtonVisible: canClearSelection,
    //           onTodayButtonTap: () {
    //             setState(() => _focusedDay.value = DateTime.now());
    //           },
    //           onClearButtonTap: () {
    //             setState(() {
    //               _rangeStart = null;
    //               _rangeEnd = null;
    //               _selectedDays.clear();
    //             });
    //           },
    //           onLeftArrowTap: () {
    //             _pageController.previousPage(
    //               duration: Duration(milliseconds: 300),
    //               curve: Curves.easeOut,
    //             );
    //           },
    //           onRightArrowTap: () {
    //             _pageController.nextPage(
    //               duration: Duration(milliseconds: 300),
    //               curve: Curves.easeOut,
    //             );
    //           },
    //         );
    //       },
    //     ),
    //     TableCalendar<Event>(
    //       firstDay: kFirstDay,
    //       lastDay: kToday,
    //       focusedDay: _focusedDay.value,
    //       headerVisible: false,
    //       selectedDayPredicate: (day) => _selectedDays.contains(day),
    //       rangeStartDay: _rangeStart,
    //       rangeEndDay: _rangeEnd,
    //       calendarFormat: _calendarFormat,
    //       rangeSelectionMode: _rangeSelectionMode,
    //       startingDayOfWeek: StartingDayOfWeek.monday,
    //       daysOfWeekHeight: 30.sp,
    //       calendarStyle: CalendarStyle(
    //         markerDecoration:
    //             BoxDecoration(color: ColorPallet.kSimpleLightGreen),
    //         rangeHighlightColor: Colors.transparent,
    //         rangeHighlightScale: 0,
    //         withinRangeTextStyle: TextStyle(
    //             color: ColorPallet.kPrimaryTextColor,
    //             fontSize: 20,
    //             fontWeight: FontWeight.bold),
    //         rangeStartTextStyle: TextStyle(
    //             color: ColorPallet.kPrimaryTextColor,
    //             fontSize: 20,
    //             fontWeight: FontWeight.bold),
    //         rangeEndTextStyle: TextStyle(
    //             color: ColorPallet.kPrimaryTextColor,
    //             fontSize: 20,
    //             fontWeight: FontWeight.bold),
    //         rangeStartDecoration: BoxDecoration(
    //             color: ColorPallet.kSimpleLightGreen, shape: BoxShape.circle),
    //         withinRangeDecoration: BoxDecoration(
    //             color: ColorPallet.kSimpleLightGreen, shape: BoxShape.circle),
    //         rangeEndDecoration: BoxDecoration(
    //             color: ColorPallet.kSimpleLightGreen, shape: BoxShape.circle),
    //         isTodayHighlighted: false,
    //         todayDecoration: BoxDecoration(
    //             color: ColorPallet.kBrightGreen, shape: BoxShape.circle),
    //       ),
    //       // holidayPredicate: (day) {
    //       //   // Every 20th day of the month will be treated as a holiday
    //       //   return day.day == 20;
    //       // },
    //       //onDaySelected: _onDaySelected,
    //       onRangeSelected: _onRangeSelected,
    //       onCalendarCreated: (controller) => _pageController = controller,
    //       onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
    //       onFormatChanged: (format) {
    //         if (_calendarFormat != format) {
    //           setState(() => _calendarFormat = format);
    //         }
    //       },
    //       calendarBuilders: CalendarBuilders(
    //         dowBuilder: (context, day) {
    //           if (day.weekday == DateTime.sunday) {}
    //           final text = DateFormat.E().format(day);

    //           return Center(
    //             child: Text(
    //               text,
    //               style: TextStyle(
    //                   color: ColorPallet.kPrimaryTextColor,
    //                   fontSize: FCStyle.blockSizeVertical * 2.2,
    //                   fontWeight: FontWeight.bold),
    //             ),
    //           );
    //         },
    //         defaultBuilder: (context, day, day1) {
    //           return Container(
    //             alignment: Alignment.center,
    //             height: FCStyle.blockSizeVertical * 10,
    //             child: Text(
    //               DateFormat.d().format(day),
    //               style: TextStyle(
    //                   color: (day.isBefore(DateTime(
    //                               _rangeStart?.year ?? 0,
    //                               _rangeStart?.month ?? 0,
    //                               (_rangeStart?.day ?? 0) - 6)) ||
    //                           day.isAfter(DateTime(
    //                               _rangeStart?.year ?? 0,
    //                               _rangeStart?.month ?? 0,
    //                               (_rangeStart?.day ?? 0) + 7)))
    //                       ? ColorPallet.kFadedRed
    //                       : ColorPallet.kPrimaryTextColor,
    //                   fontSize: FCStyle.mediumFontSize,
    //                   fontWeight: FontWeight.bold),
    //             ),
    //           );
    //         },
    //         outsideBuilder: (context, day, day1) {
    //           return Container();
    //         },
    //         selectedBuilder: (context, day, focusedDay) {
    //           if (_rangeStart!.isBefore(day) && _rangeEnd!.isAfter(day)) {
    //             return Container(
    //               alignment: Alignment.center,
    //               height: FCStyle.blockSizeVertical * 10,
    //               decoration: BoxDecoration(
    //                   color: ColorPallet.kSimpleLightGreen,
    //                   shape: BoxShape.circle),
    //               child: Text(
    //                 DateFormat.d().format(day),
    //                 style: TextStyle(
    //                     color: ColorPallet.kPrimaryTextColor,
    //                     fontSize: FCStyle.mediumFontSize,
    //                     fontWeight: FontWeight.bold),
    //               ),
    //             );
    //           }
    //           return Container(
    //             alignment: Alignment.center,
    //             height: FCStyle.blockSizeVertical * 10,
    //             child: Text(
    //               DateFormat.d().format(day),
    //               style: TextStyle(
    //                   color: ColorPallet.kPrimaryTextColor,
    //                   fontSize: FCStyle.mediumFontSize,
    //                   fontWeight: FontWeight.bold),
    //             ),
    //           );
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }
}

// @override
// Widget build(BuildContext context) {
//   // TODO: implement build
//   throw UnimplementedError();
// }

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onClearButtonTap;
  final bool clearButtonVisible;

  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onClearButtonTap,
    required this.clearButtonVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: EdgeInsets.only(
          top: FCStyle.blockSizeVertical,
          bottom: FCStyle.blockSizeVertical * 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPallet.kCardBackground,
                boxShadow: [
                  BoxShadow(
                    color: ColorPallet.kBlack,
                    spreadRadius: -6,
                    offset: Offset(0, 5),
                    blurRadius: 20,
                  ),
                ]),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPallet.kBrightGreen,
              ),
              child: GestureDetector(
                key: FCElementID.calendarPreviousMonthButton,
                onTap: onLeftArrowTap,
                child: Icon(
                  Icons.chevron_left,
                  color: ColorPallet.kWhite,
                  size: FCStyle.blockSizeHorizontal * 5,
                ),
              ),
            ),
          ),
          SizedBox(
            width: FCStyle.blockSizeHorizontal * 2,
          ),
          Text(
            headerText,
            style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontSize: FCStyle.largeFontSize,
                fontWeight: FontWeight.bold),
          ),
          IconButton(
            key: FCElementID.calendarCurrentPageButton,
            icon: Icon(Icons.calendar_today, size: 20.0),
            visualDensity: VisualDensity.compact,
            onPressed: onTodayButtonTap,
          ),
          SizedBox(
            width: FCStyle.blockSizeHorizontal * 2,
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPallet.kCardBackground,
                boxShadow: [
                  BoxShadow(
                    color: ColorPallet.kBlack,
                    spreadRadius: -6,
                    offset: Offset(0, 5),
                    blurRadius: 20,
                  ),
                ]),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPallet.kBrightGreen,
              ),
              child: GestureDetector(
                key: FCElementID.calendarNextMonthButton,
                onTap: onRightArrowTap,
                child: Icon(
                  Icons.chevron_right,
                  color: ColorPallet.kWhite,
                  size: FCStyle.blockSizeHorizontal * 5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
