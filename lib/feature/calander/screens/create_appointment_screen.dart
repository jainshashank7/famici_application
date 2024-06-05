// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/feature/calander/entities/appointments_entity.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/fc_back_button.dart';
import 'package:famici/shared/fc_info_popup.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/strings/appointment_strings.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart' as ThemeBloc;
import '../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../../../core/screens/home_screen/widgets/logout_button.dart';
import '../../notification/helper/appointment_notification_helper.dart';
import '../blocs/calendar/calendar_bloc.dart';
import '../blocs/manage_reminders/manage_reminders_bloc.dart';

class CreateAppointmentScreen extends StatefulWidget {
  CreateAppointmentScreen({
    Key? key,
    this.appointment,
    bool? isICalBool,
    this.ical,
  })  : isICal = isICalBool == null ? false : true,
        super(key: key);

  final Reminders? appointment;
  bool isICal;
  final ICalURL? ical;

  @override
  _CreateAppointmentScreenState createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  // ClientReminderModel reminderModel = ClientReminderModel();
  // RecurrenceModel recurrenceModel = RecurrenceModel();
  ICalURL icalLocal = ICalURL(name: "", color: Colors.red, id: "", url: "");
  Reminders reminder = Reminders(
    reminderId: 0,
    title: '',
    startTime: DateTime.now(),
    endTime: DateTime.now(),
    allDay: false,
    recurrenceRule: null,
    recurrenceId: '',
    note: '',
    creatorType: '',
    itemType: ClientReminderType.EVENT,
  );
  var isEvent = true;
  var isAllDay = false;

  // late ManageAppointmentBloc _manageAppointment;
  RecurrenceRule recurrenceModel =
      RecurrenceRule(interval: 0, count: 0, byday: [], isAfter: false);

  late User _me;
  var isEditing = false;

  Reminders? get appointment => widget.appointment;

  FocusNode textFieldFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _icalFormKey = GlobalKey<FormState>();
  Map<String, bool> values = {
    'Mon': true,
    'Tue': false,
    'Wed': false,
    'Thus': false,
    'Fri': false,
    'Sat': false,
    'Sun': false,
  };

  late String _dropDownEndValue;
  late TextEditingController _intervalController = TextEditingController();
  // var _weekDay = [];

  late TextEditingController _countController = TextEditingController();
  late TextEditingController _recurrenceEndDateController =
      TextEditingController();

  late DateTime EndDate;
  late TextEditingController _notesController = TextEditingController();
  late TextEditingController _titleController = TextEditingController();
  late TextEditingController _RecurrenceController = TextEditingController();

  late TextEditingController _startDateController = TextEditingController();
  late TextEditingController _endDateController = TextEditingController();
  late TextEditingController _dateController = TextEditingController();
  late TextEditingController _icalCalendarTitleController =
      TextEditingController();
  late TextEditingController _icalCalendarURLController =
      TextEditingController();
  late Color pickedColor;
  @override
  void initState() {
    if (widget.isICal == true) {
      setState(() {
        isEvent = false;
      });
    }
    reminder.endTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, DateTime.now().hour + 1, DateTime.now().minute);
    _icalCalendarTitleController.text = "";
    _icalCalendarURLController.text = "";
    pickedColor = ColorPallet.kSecondary;
    // _manageAppointment = ManageAppointmentBloc(
    //   me: _me,
    //   appointment: appointment,
    //   calendarBloc: context.read<CalendarBloc>(),
    // );
    _me = Provider.of<User>(context, listen: false);
    values = {
      'Sun': false,
      'Mon': false,
      'Tue': false,
      'Wed': false,
      'Thus': false,
      'Fri': false,
      'Sat': false,
    };

    _dropDownEndValue = 'After';
    _intervalController.text = 1.toString();
    // var _weekDay = [];

    _countController.text = 1.toString();
    _recurrenceEndDateController = TextEditingController();

    EndDate = DateTime.now();
    _notesController.text = '';
    _titleController.text = '';
    _RecurrenceController.text = "Don't Repeat";
    reminder.startTime = DateTime.now();
    reminder.endTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, DateTime.now().hour + 1, DateTime.now().minute);
    _startDateController.text = DateFormat('hh:mm a')
        .format(reminder.startTime)
        .replaceAll('am', 'AM')
        .replaceAll('pm', 'PM');
    _endDateController.text = DateFormat('hh:mm a')
        .format(reminder.endTime)
        .replaceAll('am', 'AM')
        .replaceAll('pm', 'PM');
    _dateController.text = DateFormat('MM-dd-yyyy').format(DateTime.now());
    if (appointment != null) {
      isAllDay = appointment!.allDay;
      isEvent =
          appointment!.itemType == ClientReminderType.EVENT ? true : false;
      reminder = appointment!;
      if (appointment!.recurrenceRule != '') {
        _intervalController.text =
            (appointment!.recurrenceRule).interval.toString();
        // var _weekDay = [];
        recurrenceModel = appointment!.recurrenceRule;

        if ((appointment!.recurrenceRule).until != null) {
          recurrenceModel.isAfter = false;
          recurrenceModel.until = (appointment!.recurrenceRule).until;
          EndDate = (appointment!.recurrenceRule).until;
          _dropDownEndValue = 'On Date';
          _recurrenceEndDateController.text = DateFormat('MM-dd-yyyy')
              .format((appointment!.recurrenceRule).until);
        } else if ((appointment!.recurrenceRule).count != null) {
          _dropDownEndValue = 'After';
          recurrenceModel.isAfter = true;
          _countController.text =
              (appointment!.recurrenceRule).count.toString();
        }
        if ((appointment!.recurrenceRule).byday.length > 0) {
          values = values.map((key, value) {
            final index =
                ['Sun', 'Mon', 'Tue', 'Wed', 'Thus', 'Fri', 'Sat'].indexOf(key);
            final updatedValue =
                (appointment!.recurrenceRule.byday.contains(index))
                    ? true
                    : false;
            return MapEntry(key, updatedValue);
          });
        }
        _RecurrenceController.text = 'Occur every ' +
            recurrenceModel.interval.toString() +
            (recurrenceModel.interval > 1 ? ' weeks' : ' week') +
            ', until ' +
            (recurrenceModel.isAfter == true
                ? (recurrenceModel.count.toString() +
                    (isEvent
                        ? (recurrenceModel.count > 1 ? ' events ' : ' event')
                        : (recurrenceModel.count > 1
                            ? '   reminders'
                            : ' reminder')))
                : DateFormat('MM-dd-yyyy').format(recurrenceModel.until!));
      }

      // DateTime EndDate = DateTime.now();
      _notesController.text =
          (appointment?.note != null ? appointment!.note : '')!;
      _titleController.text =
          appointment?.title != null ? appointment!.title : '';
      _startDateController.text = (DateFormat('hh:mm a')
          .format(appointment!.startTime)
          .replaceAll('am', 'AM')
          .replaceAll('pm', 'PM'));
      _endDateController.text = DateFormat('hh:mm a')
          .format(appointment!.endTime)
          .replaceAll('am', 'AM')
          .replaceAll('pm', 'PM');
      _dateController.text =
          DateFormat('MM-dd-yyyy').format(appointment!.startTime);
    } else if (widget.ical != null) {
      icalLocal.name = widget.ical!.name;
      icalLocal.id = widget.ical!.id;
      icalLocal.color = widget.ical!.color;
      icalLocal.url = widget.ical!.url;
      _icalCalendarTitleController.text = widget.ical!.name;
      _icalCalendarURLController.text = widget.ical!.url;
      pickedColor = widget.ical!.color;
    }
    super.initState();
  }

  @override
  void dispose() {
    // _manageAppointment.close();
    super.dispose();
  }

  Future<void> showSuccessPopup(bool isEditing) async {
    String message = isEditing
        ? AppointmentStrings.appointmentSavedSuccessMessage.tr()
        : AppointmentStrings.appointmentCreateSuccessMessage.tr();

    fcRouter
        .pushWidget(FCInfoPopup(
          type: InfoPopupTypes.success,
          message: message,
          buttonText: CommonStrings.ok.tr(),
        ))
        .then((value) => fcRouter.pop());
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    print(isEvent.toString() + " chibu " + widget.isICal.toString());
    return BlocBuilder<ThemeBloc.ThemeBuilderBloc, ThemeBloc.ThemeBuilderState>(
  builder: (context, stateM) {
    return FamiciScaffold(
        toolbarHeight: 140.h,
        leading: FCBackButton(
          onPressed: BackToStep,
        ),
        title: Center(
          child: Text(
            widget.isICal == true
                ? (widget.ical != null ? 'Edit Calendar' : 'Create Calendar')
                : (appointment != null ? 'Edit the ' : 'Create New ') +
                    (isEvent ? 'Event' : 'Reminder'),
            style: FCStyle.textStyle
                .copyWith(fontSize: 50.sp, fontWeight: FontWeight.w700),
          ),
        ),
        topRight: Row(
          children: [
            Container(
              width: 150,
              child: ElevatedButton(
                // borderRadius: BorderRadius.circular(10),
                // color: Colors.white,
                onPressed: () {
                  fcRouter.popAndPush(IcalListRoute());
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    )),
                    elevation: MaterialStatePropertyAll(20),
                    shadowColor: MaterialStatePropertyAll(
                        Color.fromARGB(87, 41, 72, 152)),
                    alignment: Alignment.center,
                    backgroundColor: MaterialStatePropertyAll(Colors.white)),
                // defaultSize: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon(
                      //   Icons.note_add,
                      //   color: ColorPallet.kPrimary,
                      //   size: 20,
                      // ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      Text(
                        'Calendar List',
                        textAlign: TextAlign.center,
                        style: FCStyle.textStyle.copyWith(
                            fontFamily: 'roboto',
                            fontSize: 25 * FCStyle.fem,
                            fontWeight: FontWeight.w600,
                            color: ColorPallet.kPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            LogoutButton(),
          ],
        ),
        bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
        child: Form(
          key: _formKey,
          child: isEditing
              ? Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              right: 20, left: 15, top: 0, bottom: 16),
                          padding: EdgeInsets.only(
                              top: 40 * FCStyle.fem,
                              left: 30 * FCStyle.fem,
                              right: 10 * FCStyle.fem,
                              bottom: 30),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(244, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      (isEvent ? 'Event' : 'Reminder') +
                                          ' Summary',
                                      style: TextStyle(
                                          color: ColorPallet.kTertiary,
                                          fontSize: 30 * FCStyle.fem,
                                          fontWeight: FontWeight.w700)),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  SvgPicture.asset(
                                    VitalIcons.blogImageLine,
                                    color: ColorPallet.kTertiary,
                                    height: 3.5,
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (isEvent ? 'Event' : 'Reminder') + ' Title',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 125, 127, 129),
                                        fontSize: 20 * FCStyle.fem,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(reminder.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35 * FCStyle.fem,
                                      ))
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date of ' +
                                        (isEvent ? 'Event' : 'Reminder'),
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 125, 127, 129),
                                        fontSize: 20 * FCStyle.fem,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: ColorPallet.kPrimary,
                                    ),
                                    SizedBox(width: 13),
                                    Text(
                                        DateFormat('MM-dd-yyyy')
                                            .format(reminder.startTime),
                                        style: TextStyle(
                                            color: ColorPallet.kPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25 * FCStyle.fem))
                                  ])
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (isEvent ? 'Start and End Time' : 'Time'),
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 125, 127, 129),
                                        fontSize: 20 * FCStyle.fem,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(children: [
                                    Icon(
                                      Icons.watch_later_outlined,
                                      color: ColorPallet.kPrimary,
                                    ),
                                    SizedBox(width: 13),
                                    Text(
                                        DateFormat('hh:mm a')
                                            .format(reminder.startTime.copyWith(
                                                minute:
                                                    reminder.startTime.minute,
                                                hour: reminder.startTime.hour))
                                            .replaceAll('am', 'AM')
                                            .replaceAll('pm', 'PM'),
                                        style: TextStyle(
                                            color: ColorPallet.kPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25 * FCStyle.fem)),
                                    isEvent
                                        ? Text(
                                            ' - ' +
                                                DateFormat('hh:mm a')
                                                    .format(reminder.endTime
                                                        .copyWith(
                                                            minute: reminder
                                                                .endTime.minute,
                                                            hour: reminder
                                                                .endTime.hour))
                                                    .replaceAll('am', 'AM')
                                                    .replaceAll('pm', 'PM'),
                                            style: TextStyle(
                                                color: ColorPallet.kPrimary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25 * FCStyle.fem))
                                        : SizedBox.shrink(),
                                  ])
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recurrence',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 125, 127, 129),
                                        fontSize: 20 * FCStyle.fem,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_RecurrenceController.text,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22 * FCStyle.fem)),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      _RecurrenceController.text !=
                                              "Don't Repeat"
                                          ? Row(children: [
                                              Flexible(
                                                child: Wrap(
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  alignment: WrapAlignment
                                                      .spaceBetween,
                                                  spacing: 10,
                                                  direction: Axis.horizontal,
                                                  children: recurrenceModel
                                                      .byday
                                                      .map((e) {
                                                    return Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 3),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4,
                                                              horizontal: 10),
                                                      decoration: BoxDecoration(
                                                          color: ColorPallet
                                                              .kPrimary,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4)),
                                                      child: Text(
                                                          DateFormat('EEEE')
                                                              .format(DateTime(
                                                                  2023,
                                                                  1,
                                                                  e + 1)),
                                                          style: TextStyle(
                                                              color: ColorPallet
                                                                  .kPrimaryText,
                                                              fontSize: 20 *
                                                                  FCStyle.fem)),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ])
                                          : SizedBox.shrink(),
                                    ],
                                  )
                                ],
                              )
                            ],
                          )),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                          margin:
                              EdgeInsets.only(right: 20, top: 0, bottom: 16),
                          padding: EdgeInsets.only(
                              top: 50 * FCStyle.fem, bottom: 30),
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(244, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 100 * FCStyle.fem,
                                    right: 100 * FCStyle.fem,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Note',
                                        style: TextStyle(
                                            fontSize: 20 * FCStyle.fem,
                                            color: Color.fromARGB(
                                                255, 125, 127, 129),
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      TextFormField(
                                        inputFormatters: [
                                          UpperCaseTextFormatter()
                                        ],
                                        controller: _notesController,
                                        onChanged: (value) {
                                          setState(() {});
                                          reminder.note = value;
                                        },
                                        maxLines: 6,
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 28 * FCStyle.fem,
                                            fontWeight: FontWeight.w600),
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            focusColor: Color.fromARGB(
                                                255, 125, 125, 125),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 125, 125, 125),
                                                    width: 1)),
                                            disabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 125, 125, 125),
                                                    width: 1)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        Color.fromARGB(255, 125, 125, 125),
                                                    width: 1)),
                                            contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                            hintText: 'Enter ' + 'Notes',
                                            hintStyle: TextStyle(color: Color.fromARGB(255, 143, 146, 161), fontSize: 28 * FCStyle.fem, fontWeight: FontWeight.w600)),
                                      ),
                                    ],
                                  ),
                                ),
                                BlocBuilder<CalendarBloc, CalendarState>(
                                    builder: (context, state) {
                                  return Container(
                                    padding: EdgeInsets.only(
                                      left: 40 * FCStyle.fem,
                                      right: 40 * FCStyle.fem,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // appointment != null
                                        //     ? FCMaterialButton(
                                        //         elevation: 6,
                                        //         onPressed: () {
                                        //           showDialog(
                                        //               context: context,
                                        //               builder: (BuildContext
                                        //                   context) {
                                        //                 return FCConfirmDialog(
                                        //                   height: 450,
                                        //                   width: 790,
                                        //                   subText:
                                        //                       'This Action will delete all the recurrence ${appointment!.itemType.name.toLowerCase()} associated with the selected ${appointment!.itemType.name.toLowerCase()}',
                                        //                   submitText: 'Confirm',
                                        //                   cancelText: 'Cancel',
                                        //                   icon: VitalIcons
                                        //                       .deleteIcon,
                                        //                   message:
                                        //                       "Do you want to delete all the recurrence ${appointment!.itemType.name.toLowerCase()} associated with the selected ${appointment!.itemType.name.toLowerCase()}?",
                                        //                 );
                                        //               }).then((value) {
                                        //             if (value) {
                                        //               context
                                        //                   .read<
                                        //                       ManageRemindersBloc>()
                                        //                   .add(DeleteEventsAndRemindersForByRecurrenceRule(
                                        //                       recurrence_id:
                                        //                           appointment!
                                        //                               .recurrenceId,
                                        //                       isEvent: appointment!
                                        //                                   .itemType
                                        //                                   .name ==
                                        //                               ClientReminderType
                                        //                                   .EVENT
                                        //                                   .name
                                        //                                   .toString()
                                        //                           ? true
                                        //                           : false));
                                        //               context
                                        //                   .read<CalendarBloc>()
                                        //                   .add(FetchCalendarDetailsEvent(
                                        //                       state.startDate,
                                        //                       state.endDate));
                                        //               context
                                        //                   .read<CalendarBloc>()
                                        //                   .add(
                                        //                       FetchThisWeekAppointmentsCalendarEvent());
                                        //             }
                                        //             fcRouter.pop();
                                        //           });
                                        //         },
                                        //         defaultSize: false,
                                        //         color: Color.fromARGB(
                                        //             255, 51, 77, 171),
                                        //         child: Padding(
                                        //           padding: const EdgeInsets
                                        //                   .symmetric(
                                        //               vertical: 3.0,
                                        //               horizontal: 6),
                                        //           child: Center(
                                        //             child: Text(
                                        //               'Delete All Recurring ' +
                                        //                   (isEvent
                                        //                       ? 'Event'
                                        //                       : 'Reminder'),
                                        //               style: FCStyle.textStyle
                                        //                   .copyWith(
                                        //                       color: ColorPallet
                                        //                           .kWhite,
                                        //                       fontWeight:
                                        //                           FontWeight
                                        //                               .w600),
                                        //             ),
                                        //           ),
                                        //         ),
                                        //       )
                                        //     : SizedBox.shrink(),
                                        // SizedBox(
                                        //   width: 10,
                                        // ),
                                        FCMaterialButton(
                                          elevation: 6,
                                          onPressed: () {
                                            if (appointment != null) {
                                              if (reminder.recurrenceRule ==
                                                  appointment!.recurrenceRule) {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return FCConfirmDialog(
                                                        height: 450,
                                                        width: 830,
                                                        // subText:
                                                        //     'This Action will edit all the recurring ${appointment!.itemType.name.toLowerCase()} associated with the selected ${appointment!.itemType.name.toLowerCase()}',
                                                        submitText: 'Edit All',
                                                        cancelText: 'Cancel',
                                                        isThirdButton: true,
                                                        thirdButtonText:
                                                            'Edit Only One',

                                                        message:
                                                            "Do you want to edit all the recurring ${appointment!.itemType.name.toLowerCase()} associated with the selected ${appointment!.itemType.name.toLowerCase()}?",
                                                      );
                                                    }).then((value) async {
                                                  if (value == false) {
                                                    AwesomeNotifications()
                                                        .cancelNotificationsByGroupKey(
                                                            reminder.reminderId
                                                                .toString());
                                                    context
                                                        .read<
                                                            ManageRemindersBloc>()
                                                        .add(EditEventsAndRemindersWithoutRecurrenceData(
                                                            notes:
                                                                _notesController
                                                                    .text,
                                                            title:
                                                                _titleController
                                                                    .text,
                                                            reminderId:
                                                                appointment!
                                                                    .reminderId,
                                                            recurrenceId:
                                                                appointment!
                                                                    .recurrenceId,
                                                            startDate: isAllDay
                                                                ? reminder
                                                                    .startTime
                                                                    .copyWith(
                                                                        hour: 0,
                                                                        minute:
                                                                            0)
                                                                : reminder
                                                                    .startTime,
                                                            byRecId: value,
                                                            endDate: isEvent
                                                                ? (isAllDay
                                                                    ? reminder
                                                                        .startTime
                                                                        .copyWith(
                                                                            hour:
                                                                                23,
                                                                            minute:
                                                                                59)
                                                                    : reminder
                                                                        .endTime)
                                                                : reminder
                                                                    .startTime,
                                                            isAllDay: isAllDay,
                                                            isEvent: isEvent));
                                                    // print('deleteing ' +
                                                    //     reminder.title +
                                                    //     ' ' +
                                                    //     reminder.reminderId
                                                    //         .toString());

                                                    // AppointmentsNotificationHelper
                                                    //     .createEventNotification(
                                                    //         reminder);

                                                    fcRouter.pop();
                                                  } else if (value == true) {
                                                    AwesomeNotifications()
                                                        .cancelNotificationsByGroupKey(
                                                            reminder.reminderId
                                                                .toString());
                                                    context.read<ManageRemindersBloc>().add(EditEventsAndRemindersWithRecurrenceData(
                                                        notes: _notesController
                                                            .text,
                                                        title: _titleController
                                                            .text,
                                                        recurrenceModel:
                                                            _RecurrenceController
                                                                        .text ==
                                                                    "Don't Repeat"
                                                                ? null
                                                                : recurrenceModel,
                                                        recurrenceId:
                                                            appointment!
                                                                .recurrenceId,
                                                        startDate: isAllDay
                                                            ? reminder.startTime
                                                                .copyWith(
                                                                    hour: 0,
                                                                    minute: 0)
                                                            : reminder
                                                                .startTime,
                                                        endDate: isEvent
                                                            ? (isAllDay
                                                                ? reminder
                                                                    .startTime
                                                                    .copyWith(
                                                                        hour: 23,
                                                                        minute: 59)
                                                                : reminder.endTime)
                                                            : reminder.startTime,
                                                        isAllDay: isAllDay,
                                                        isEvent: isEvent));
                                                    print('deleteing ' +
                                                        reminder.title +
                                                        ' ' +
                                                        reminder.reminderId
                                                            .toString());

                                                    // AppointmentsNotificationHelper
                                                    //     .createEventNotification(
                                                    //         reminder);

                                                    fcRouter.pop();
                                                  }
                                                });
                                              }
                                              // else {
                                              //   showDialog(
                                              //       context: context,
                                              //       builder:
                                              //           (BuildContext context) {
                                              //         return FCConfirmDialog(
                                              //           height: 450,
                                              //           width: 790,
                                              //           subText:
                                              //               'This Action will edit will all ${appointment!.itemType.name.toLowerCase()} associated with the selected ${appointment!.itemType.name.toLowerCase()}',
                                              //           submitText: 'Confirm',
                                              //           cancelText: 'Cancel',
                                              //           icon: VitalIcons
                                              //               .deleteIcon,
                                              //           message:
                                              //               "Are you sure, want to edit the ${appointment!.itemType.name.toLowerCase()}?",
                                              //         );
                                              //       }).then((value) {
                                              //     context.read<ManageRemindersBloc>().add(EditEventsAndRemindersWithRecurrenceData(
                                              //         notes:
                                              //             _notesController.text,
                                              //         title:
                                              //             _titleController.text,
                                              //         recurrenceModel:
                                              //             _RecurrenceController
                                              //                         .text ==
                                              //                     "Don't Repeat"
                                              //                 ? null
                                              //                 : recurrenceModel,
                                              //         recurrenceId: appointment!
                                              //             .recurrenceId,
                                              //         startDate: isAllDay
                                              //             ? reminder.startTime
                                              //                 .copyWith(
                                              //                     hour: 0,
                                              //                     minute: 0)
                                              //             : reminder.startTime,
                                              //         endDate: isEvent
                                              //             ? (isAllDay
                                              //                 ? reminder
                                              //                     .startTime
                                              //                     .copyWith(
                                              //                         hour: 23,
                                              //                         minute:
                                              //                             59)
                                              //                 : reminder
                                              //                     .endTime)
                                              //             : reminder.startTime,
                                              //         isAllDay: isAllDay,
                                              //         isEvent: isEvent));
                                              //   });
                                              //   fcRouter.pop();
                                              // }
                                            } else {
                                              reminder.recurrenceRule =
                                                  _RecurrenceController.text ==
                                                          "Don't Repeat"
                                                      ? null
                                                      : recurrenceModel;
                                              context
                                                  .read<ManageRemindersBloc>()
                                                  .add(SendEventsAndRemindersData(
                                                      _notesController.text,
                                                      _titleController.text,
                                                      _RecurrenceController
                                                                  .text ==
                                                              "Don't Repeat"
                                                          ? null
                                                          : recurrenceModel,
                                                      isAllDay
                                                          ? reminder.startTime
                                                              .copyWith(
                                                                  hour: 0,
                                                                  minute: 0)
                                                          : reminder.startTime,
                                                      isEvent
                                                          ? (isAllDay
                                                              ? reminder
                                                                  .startTime
                                                                  .copyWith(
                                                                      hour: 23,
                                                                      minute:
                                                                          59)
                                                              : reminder
                                                                  .endTime)
                                                          : reminder.startTime,
                                                      isAllDay,
                                                      isEvent));

                                              fcRouter.pop();
                                            }
                                            ;
                                          },
                                          defaultSize: false,
                                          color: ColorPallet.kPrimary,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3.0, horizontal: 6),
                                            child: Center(
                                              child: Text(
                                                (appointment != null
                                                        ? 'Edit '
                                                        : 'Create ') +
                                                    (isEvent
                                                        ? 'Event'
                                                        : 'Reminder'),
                                                style: FCStyle.textStyle
                                                    .copyWith(
                                                        color: ColorPallet
                                                            .kPrimaryText,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          )),
                    ),
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.focusedChild?.unfocus();
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        right: 20, left: 20, top: 0, bottom: 16),
                    padding: EdgeInsets.only(
                        top: 17 * FCStyle.fem,
                        left: 120 * FCStyle.fem,
                        right: 120 * FCStyle.fem,
                        bottom: 10),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(244, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          isKeyboard == true && widget.isICal == true
                              ? SizedBox.shrink()
                              : SizedBox(
                                  height: 10,
                                ),
                          isKeyboard == true && widget.isICal == true
                              ? SizedBox.shrink()
                              : SizedBox(
                                  height: 57,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      widget.ical != null
                                          ? SizedBox.shrink()
                                          : FCMaterialButton(
                                              elevation: 0,
                                              onPressed: () {
                                                setState(() {
                                                  isEvent = true;
                                                  widget.isICal = false;
                                                });
                                              },
                                              defaultSize: false,
                                              isBorder: !isEvent ||
                                                  widget.isICal == true,
                                              borderColor: !isEvent ||
                                                      widget.isICal == true
                                                  ? ColorPallet.kPrimary
                                                  : Colors.transparent,
                                              color: isEvent &&
                                                      (widget.isICal == false)
                                                  ? ColorPallet.kPrimary
                                                  : Colors.transparent,
                                              child: SizedBox(
                                                width:
                                                    FCStyle.largeFontSize * 3,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 3.0),
                                                  child: Center(
                                                    child: Text(
                                                      'Event',
                                                      style: FCStyle
                                                          .textStyle
                                                          .copyWith(
                                                              color: isEvent
                                                                  ? ColorPallet
                                                                      .kPrimaryText
                                                                  : ColorPallet
                                                                      .kPrimary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 22 *
                                                                  FCStyle.fem),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                      widget.ical != null
                                          ? SizedBox.shrink()
                                          : SizedBox(
                                              width: FCStyle.xLargeFontSize),
                                      widget.ical != null
                                          ? SizedBox.shrink()
                                          : FCMaterialButton(
                                              elevation: 0,
                                              onPressed: () {
                                                setState(() {
                                                  isEvent = false;
                                                  widget.isICal = false;
                                                });
                                              },
                                              isBorder: isEvent ||
                                                  widget.isICal == true,
                                              borderColor: isEvent ||
                                                      widget.isICal == true
                                                  ? ColorPallet.kPrimary
                                                  : Colors.transparent,
                                              defaultSize: false,
                                              color: isEvent ||
                                                      widget.isICal == true
                                                  ? Colors.transparent
                                                  : ColorPallet.kPrimary,
                                              child: SizedBox(
                                                width:
                                                    FCStyle.largeFontSize * 3,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 3.0),
                                                  child: Center(
                                                    child: Text(
                                                      'Reminder',
                                                      style: FCStyle.textStyle.copyWith(
                                                          color: isEvent ||
                                                                  widget.isICal ==
                                                                      true
                                                              ? ColorPallet
                                                                  .kPrimary
                                                              : ColorPallet
                                                                  .kPrimaryText,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              22 * FCStyle.fem),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                      SizedBox(width: FCStyle.xLargeFontSize),
                                      appointment != null
                                          ? SizedBox.shrink()
                                          : FCMaterialButton(
                                              elevation: 0,
                                              onPressed: () {
                                                setState(() {
                                                  widget.isICal = true;
                                                  isEvent = false;
                                                });
                                              },
                                              isBorder: widget.isICal == true
                                                  ? false
                                                  : true,
                                              borderColor:
                                                  widget.isICal == false
                                                      ? ColorPallet.kPrimary
                                                      : Colors.transparent,
                                              defaultSize: false,
                                              color: widget.isICal == false
                                                  ? Colors.transparent
                                                  : ColorPallet.kPrimary,
                                              child: SizedBox(
                                                width:
                                                    FCStyle.largeFontSize * 3,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 3.0),
                                                  child: Center(
                                                    child: Text(
                                                      'Calendar',
                                                      style: FCStyle.textStyle.copyWith(
                                                          color: widget
                                                                      .isICal ==
                                                                  false
                                                              ? ColorPallet
                                                                  .kPrimary
                                                              : ColorPallet
                                                                  .kPrimaryText,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              22 * FCStyle.fem),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: 3,
                          ),
                          widget.isICal == true
                              ? Form(
                                  key: _icalFormKey,
                                  child: Expanded(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.ical != null
                                                  ? 'Title'
                                                  : 'Add Title',
                                              style: TextStyle(
                                                  fontSize: 18 * FCStyle.fem,
                                                  color: Color.fromARGB(
                                                      255, 125, 127, 129),
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.start,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            TextFormField(
                                              inputFormatters: [
                                                UpperCaseTextFormatter()
                                              ],
                                              focusNode: textFieldFocus,
                                              textCapitalization:
                                                  TextCapitalization.characters,
                                              controller:
                                                  _icalCalendarTitleController,
                                              autofocus: false,
                                              validator: (value) {
                                                if (value == '') {
                                                  return 'Please enter a Title';
                                                } else
                                                  return null;
                                              },
                                              onChanged: (value) {
                                                icalLocal.name = value;
                                              },
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 28 * FCStyle.fem,
                                                  fontWeight: FontWeight.w600),
                                              decoration: InputDecoration(
                                                  focusColor: Color.fromARGB(
                                                      255, 125, 125, 125),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 125, 125, 125),
                                                          width: 1)),
                                                  disabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 125, 125, 125),
                                                          width: 1)),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                  contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                  hintText: 'Enter Calendar Title',
                                                  hintStyle: TextStyle(color: Color.fromARGB(255, 143, 146, 161), fontSize: 28 * FCStyle.fem, fontWeight: FontWeight.w600)),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.ical != null
                                                  ? 'URL'
                                                  : 'Add URL',
                                              style: TextStyle(
                                                  fontSize: 18 * FCStyle.fem,
                                                  color: Color.fromARGB(
                                                      255, 125, 127, 129),
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.start,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            TextFormField(
                                              controller:
                                                  _icalCalendarURLController,
                                              autofocus: false,
                                              validator: (value) {
                                                if (value == '') {
                                                  return 'Please enter a URL';
                                                } else
                                                  return null;
                                              },
                                              onChanged: (value) {
                                                icalLocal.url = value;
                                              },
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 28 * FCStyle.fem,
                                                  fontWeight: FontWeight.w600),
                                              decoration: InputDecoration(
                                                  focusColor: Color.fromARGB(
                                                      255, 125, 125, 125),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 125, 125, 125),
                                                          width: 1)),
                                                  disabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 125, 125, 125),
                                                          width: 1)),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                  contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                  hintText: 'Enter Calendar URL',
                                                  hintStyle: TextStyle(color: Color.fromARGB(255, 143, 146, 161), fontSize: 28 * FCStyle.fem, fontWeight: FontWeight.w600)),
                                            ),
                                          ],
                                        ),
                                        //                               ColorPicker( pickerColor: icalLocal.color,
                                        // onColorChanged: (color){
                                        //   setState(() => icalLocal.color = color);},),

                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Color',
                                              style: TextStyle(
                                                  fontSize: 18 * FCStyle.fem,
                                                  color: Color.fromARGB(
                                                      255, 125, 127, 129),
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.start,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                textFieldFocus.unfocus();
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                          titlePadding:
                                                              EdgeInsets.all(0),
                                                          title: Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    43 *
                                                                        FCStyle
                                                                            .fem,
                                                                    24 *
                                                                        FCStyle
                                                                            .fem,
                                                                    15 *
                                                                        FCStyle
                                                                            .fem,
                                                                    16 *
                                                                        FCStyle
                                                                            .fem),
                                                            width:
                                                                double.infinity,
                                                            height: 95 *
                                                                FCStyle.fem,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: ColorPallet
                                                                  .kPrimary
                                                                  .withOpacity(
                                                                      0.1),
                                                              borderRadius: BorderRadius
                                                                  .circular(10 *
                                                                      FCStyle
                                                                          .fem),
                                                            ),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets.fromLTRB(
                                                                      0 *
                                                                          FCStyle
                                                                              .fem,
                                                                      0 *
                                                                          FCStyle
                                                                              .fem,
                                                                      420 *
                                                                          FCStyle
                                                                              .fem,
                                                                      0 *
                                                                          FCStyle
                                                                              .fem),
                                                                  child: Text(
                                                                    'Color Settings',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: 45 *
                                                                          FCStyle
                                                                              .ffem,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      height: 1 *
                                                                          FCStyle
                                                                              .ffem /
                                                                          FCStyle
                                                                              .fem,
                                                                      color: Color(
                                                                          0xff000000),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets.fromLTRB(
                                                                      0 *
                                                                          FCStyle
                                                                              .fem,
                                                                      0 *
                                                                          FCStyle
                                                                              .fem,
                                                                      0 *
                                                                          FCStyle
                                                                              .fem,
                                                                      1 *
                                                                          FCStyle
                                                                              .fem),
                                                                  child:
                                                                      TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      });
                                                                    },
                                                                    style: TextButton
                                                                        .styleFrom(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                    ),
                                                                    child:
                                                                        CircleAvatar(
                                                                      backgroundColor:
                                                                          const Color(
                                                                              0xFFAC2734),
                                                                      radius: 35 *
                                                                          FCStyle
                                                                              .fem,
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        AssetIconPath
                                                                            .closeIcon,
                                                                        width: 35 *
                                                                            FCStyle.fem,
                                                                        height: 35 *
                                                                            FCStyle.fem,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          // actions: <Widget>[
                                                          //   ElevatedButton(
                                                          //     child: const Text(
                                                          //         'Select the color'),
                                                          //     onPressed: () {
                                                          //       Navigator.of(
                                                          //               context)
                                                          //           .pop();
                                                          //     },
                                                          //   ),
                                                          // ],

                                                          content:
                                                              SingleChildScrollView(
                                                            child: BlockPicker(
                                                              layoutBuilder:
                                                                  (context,
                                                                      colors,
                                                                      child) {
                                                                return SizedBox(
                                                                  width: 100,
                                                                  height: 300,
                                                                  child: GridView
                                                                      .count(
                                                                    crossAxisCount:
                                                                        5,
                                                                    crossAxisSpacing:
                                                                        5,
                                                                    mainAxisSpacing:
                                                                        5,
                                                                    children: [
                                                                      for (Color color
                                                                          in colors)
                                                                        child(
                                                                            color)
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                              itemBuilder: (color,
                                                                  isCurrentColor,
                                                                  changeColor) {
                                                                return Container(
                                                                  width: 5,
                                                                  height: 5,
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(4),
                                                                    color:
                                                                        color,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          color: color.withOpacity(
                                                                              0.8),
                                                                          offset: const Offset(
                                                                              1,
                                                                              2),
                                                                          blurRadius:
                                                                              2)
                                                                    ],
                                                                  ),
                                                                  child:
                                                                      Material(
                                                                    color: Colors
                                                                        .transparent,
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          changeColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4),
                                                                      child:
                                                                          AnimatedOpacity(
                                                                        duration:
                                                                            const Duration(milliseconds: 250),
                                                                        opacity: isCurrentColor
                                                                            ? 1
                                                                            : 0,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .done,
                                                                          size:
                                                                              30,
                                                                          color: useWhiteForeground(color)
                                                                              ? Colors.white
                                                                              : Colors.black,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              // layoutBuilder:(context, colors, child) {

                                                              // },
                                                              pickerColor:
                                                                  icalLocal
                                                                      .color,
                                                              onColorChanged:
                                                                  (color) {
                                                                setState(() =>
                                                                    icalLocal
                                                                            .color =
                                                                        color);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),

                                                            // Use Material color picker:
                                                            //
                                                            // child: MaterialPicker(
                                                            //   pickerColor: pickerColor,
                                                            //   onColorChanged: changeColor,
                                                            //   showLabel: true, // only on portrait mode
                                                            // ),
                                                            //
                                                            // Use Block color picker:
                                                            //
                                                            // child: BlockPicker(
                                                            //   pickerColor: currentColor,
                                                            //   onColorChanged: changeColor,
                                                            // ),
                                                            //
                                                            // child: MultipleChoiceBlockPicker(
                                                            //   pickerColors: currentColors,
                                                            //   onColorsChanged: changeColors,
                                                            // ),
                                                          ));
                                                    });
                                              },
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null) {
                                                    return 'Please select the color';
                                                  }
                                                },
                                                // controller: _dateController,
                                                enabled: false,
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 28 * FCStyle.fem,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                decoration: InputDecoration(
                                                    // filled: true,
                                                    // fillColor: icalLocal.color,
                                                    focusColor: Color.fromARGB(
                                                        255, 125, 125, 125),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 125, 125, 125),
                                                            width: 1)),
                                                    disabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 125, 125, 125),
                                                            width: 1)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 125, 125, 125),
                                                            width: 1)),
                                                    contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                    suffixIcon: Icon(Icons.more_vert, color: Colors.black),
                                                    prefixIcon: Icon(Icons.square, color: icalLocal.color),
                                                    hintText: 'Set Color Label',
                                                    hintStyle: TextStyle(color: Color.fromARGB(255, 143, 146, 161), fontSize: 28 * FCStyle.fem, fontWeight: FontWeight.w600)),
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 8),

                                        Container(
                                          alignment: Alignment.bottomRight,
                                          child: FCMaterialButton(
                                            elevation: 6,
                                            onPressed: () async {
                                              if (_icalFormKey.currentState!
                                                  .validate()) {
                                                if (widget.ical != null) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return FCConfirmDialog(
                                                          height: 380,
                                                          width: 700,
                                                          // subText:
                                                          //     'This Action will edit all the recurring ${appointment!.itemType.name.toLowerCase()} associated with the selected ${appointment!.itemType.name.toLowerCase()}',
                                                          submitText: 'Edit',
                                                          cancelText: 'Cancel',
                                                          isThirdButton: false,
                                                          message:
                                                              "Are you sure you want to edit the Calendar?",
                                                        );
                                                      }).then((value) async {
                                                    if (value == true) {
                                                      context
                                                          .read<CalendarBloc>()
                                                          .add(updateICal(
                                                              icalLocal));
                                                      Navigator.pop(context);
                                                    }
                                                  });
                                                } else {
                                                  context
                                                      .read<CalendarBloc>()
                                                      .add(saveICal(icalLocal));
                                                  Navigator.pop(context);
                                                }
                                                // If the form is valid, display a snackbar. In the real world,
                                                // you'd often call a server or save the information in a database.
                                                // setState(
                                                //   () => {isEditing = true},
                                                // );
                                                // reminder.allDay = isAllDay;
                                                // reminder.itemType = isEvent
                                                //     ? ClientReminderType.EVENT
                                                //     : ClientReminderType.REMINDER;
                                                // Navigator.pop(context);
                                              } else {}
                                            },
                                            defaultSize: false,
                                            color: ColorPallet.kPrimary,
                                            child: SizedBox(
                                              width: widget.ical != null
                                                  ? FCStyle.largeFontSize * 5
                                                  : FCStyle.largeFontSize * 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3.0),
                                                child: Center(
                                                  child: Text(
                                                    widget.ical != null
                                                        ? "Edit and Save"
                                                        : "Save",
                                                    style: FCStyle.textStyle
                                                        .copyWith(
                                                      color: ColorPallet.kPrimaryText,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ])))
                              : Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            appointment != null
                                                ? 'Title'
                                                : 'Add Title',
                                            style: TextStyle(
                                                fontSize: 18 * FCStyle.fem,
                                                color: Color.fromARGB(
                                                    255, 125, 127, 129),
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          TextFormField(
                                            inputFormatters: [
                                              UpperCaseTextFormatter()
                                            ],
                                            focusNode: textFieldFocus,
                                            textCapitalization:
                                                TextCapitalization.characters,
                                            controller: _titleController,
                                            autofocus: true,
                                            validator: (value) {
                                              if (value == '') {
                                                return 'Please enter a Title';
                                              } else
                                                return null;
                                            },
                                            onChanged: (value) {
                                              reminder.title = value;
                                            },
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontSize: 28 * FCStyle.fem,
                                                fontWeight: FontWeight.w600),
                                            decoration: InputDecoration(
                                                focusColor: Color.fromARGB(
                                                    255, 125, 125, 125),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 125, 125, 125),
                                                        width: 1)),
                                                disabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 125, 125, 125),
                                                        width: 1)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                hintText: 'Enter ' + (isEvent ? 'Event' : 'Reminder') + ' Title',
                                                hintStyle: TextStyle(color: Color.fromARGB(255, 143, 146, 161), fontSize: 28 * FCStyle.fem, fontWeight: FontWeight.w600)),
                                          ),
                                        ],
                                      ),
                                      Row(children: [
                                        Flexible(
                                            flex: 2,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Date',
                                                  style: TextStyle(
                                                      fontSize:
                                                          18 * FCStyle.fem,
                                                      color: Color.fromARGB(
                                                          255, 125, 127, 129),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  textAlign: TextAlign.start,
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    textFieldFocus.unfocus();
                                                    showDatePicker(
                                                            builder:
                                                                (BuildContext
                                                                        context,
                                                                    Widget?
                                                                        child) {
                                                              return Theme(
                                                                  data: ThemeData
                                                                          .light()
                                                                      .copyWith(
                                                                    primaryColor:
                                                                        ColorPallet
                                                                            .kPrimary,
                                                                    accentColor:
                                                                        ColorPallet
                                                                            .kPrimary,
                                                                    colorScheme: ColorScheme.light(
                                                                        onPrimary:
                                                                            ColorPallet
                                                                                .kPrimaryText,
                                                                        primary:
                                                                            ColorPallet.kPrimary),
                                                                    buttonTheme:
                                                                        ButtonThemeData(
                                                                            textTheme:
                                                                                ButtonTextTheme.primary),
                                                                  ),
                                                                  child: child ??
                                                                      SizedBox
                                                                          .shrink());
                                                            },
                                                            initialEntryMode:
                                                                DatePickerEntryMode
                                                                    .calendarOnly,
                                                            context: context,
                                                            initialDate:
                                                                appointment !=
                                                                        null
                                                                    ? DateTime
                                                                        .now()
                                                                    : reminder
                                                                        .startTime,
                                                            firstDate: DateTime
                                                                .now(),
                                                            lastDate: DateTime(
                                                                DateTime
                                                                            .now()
                                                                        .year +
                                                                    4,
                                                                DateTime.now()
                                                                    .month,
                                                                DateTime.now()
                                                                    .day))
                                                        .then((value) {
                                                      setState(() {
                                                        _dateController
                                                            .text = (value !=
                                                                null)
                                                            ? DateFormat(
                                                                    'MM-dd-yyyy')
                                                                .format(value)
                                                            : _dateController
                                                                .text;
                                                        if (value != null) {
                                                          // reminder.startTime = value!;
                                                          reminder.startTime =
                                                              reminder.startTime
                                                                  .copyWith(
                                                                      year: value
                                                                          .year,
                                                                      month: value
                                                                          .month,
                                                                      day: value
                                                                          .day);
                                                          reminder.endTime =
                                                              reminder.startTime.copyWith(
                                                                  year:
                                                                      value
                                                                          .year,
                                                                  month: value
                                                                      .month,
                                                                  day:
                                                                      value.day,
                                                                  hour: reminder
                                                                      .endTime
                                                                      .hour,
                                                                  minute: reminder
                                                                      .endTime
                                                                      .minute);
                                                        }
                                                      });
                                                    });
                                                  },
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (isEvent &&
                                                          reminder.startTime
                                                              .isAfter(reminder
                                                                  .endTime)) {
                                                        return 'Endtime is smaller than startTime';
                                                      } else
                                                        return null;
                                                    },
                                                    controller: _dateController,
                                                    enabled: false,
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontSize:
                                                            28 * FCStyle.fem,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    decoration: InputDecoration(
                                                        focusColor: Color.fromARGB(
                                                            255, 125, 125, 125),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Color.fromARGB(
                                                                    255, 125, 125, 125),
                                                                width: 1)),
                                                        disabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Color.fromARGB(
                                                                    255, 125, 125, 125),
                                                                width: 1)),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                        contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                        suffixIcon: Icon(Icons.calendar_today_outlined, color: Colors.black),
                                                        hintText: DateFormat('MM-dd-yyyy').format(DateTime.now()),
                                                        hintStyle: TextStyle(color: Color.fromARGB(255, 143, 146, 161), fontSize: 28 * FCStyle.fem, fontWeight: FontWeight.w600)),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  isEvent
                                                      ? 'Start Time'
                                                      : 'Time',
                                                  style: TextStyle(
                                                      fontSize:
                                                          18 * FCStyle.fem,
                                                      color: Color.fromARGB(
                                                          255, 125, 127, 129),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  textAlign: TextAlign.start,
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    textFieldFocus.unfocus();
                                                    if (!isAllDay) {
                                                      showTimePicker(
                                                              builder:
                                                                  (BuildContext context,
                                                                      Widget?
                                                                          child) {
                                                                return Theme(
                                                                    data: ThemeData
                                                                            .light()
                                                                        .copyWith(
                                                                      primaryColor:
                                                                          Color(
                                                                              0xFF5155C3),
                                                                      accentColor:
                                                                          Color(
                                                                              0xFF5155C3),
                                                                      colorScheme:
                                                                          ColorScheme
                                                                              .light(
                                                                        primary:
                                                                            ColorPallet.kPrimary,
                                                                        onPrimary:
                                                                            ColorPallet.kPrimaryText,
                                                                      ),
                                                                      buttonTheme:
                                                                          ButtonThemeData(
                                                                              textTheme: ButtonTextTheme.primary),
                                                                    ),
                                                                    child: child ??
                                                                        SizedBox
                                                                            .shrink());
                                                              },
                                                              context: context,
                                                              initialTime: TimeOfDay(
                                                                  hour: reminder
                                                                      .startTime
                                                                      .hour,
                                                                  minute: reminder
                                                                      .startTime
                                                                      .minute))
                                                          .then((value) {
                                                        setState(() {
                                                          _startDateController
                                                              .text = (value !=
                                                                  null)
                                                              ? DateFormat(
                                                                      'hh:mm a')
                                                                  .format(reminder
                                                                      .startTime
                                                                      .copyWith(
                                                                          hour: value
                                                                              .hour,
                                                                          minute:
                                                                              value
                                                                                  .minute))
                                                                  .replaceAll(
                                                                      'am',
                                                                      'AM')
                                                                  .replaceAll(
                                                                      'pm',
                                                                      'PM')
                                                              : _startDateController
                                                                  .text;
                                                          if (value != null) {
                                                            reminder.startTime = reminder
                                                                .startTime
                                                                .copyWith(
                                                                    hour: value
                                                                        .hour,
                                                                    minute: value
                                                                        .minute);
                                                          }
                                                        });
                                                      });
                                                    } else {}
                                                  },
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (isEvent &&
                                                          reminder.startTime
                                                              .isAfter(reminder
                                                                  .endTime)) {
                                                        return 'Endtime is smaller than startTime';
                                                      } else
                                                        return null;
                                                    },
                                                    controller:
                                                        _startDateController,
                                                    enabled: false,
                                                    style: TextStyle(
                                                        color: isAllDay
                                                            ? Color.fromARGB(
                                                                255,
                                                                143,
                                                                146,
                                                                161)
                                                            : Color.fromARGB(
                                                                255, 0, 0, 0),
                                                        fontSize:
                                                            28 * FCStyle.fem,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    decoration: InputDecoration(
                                                        focusColor: Color.fromARGB(
                                                            255, 125, 125, 125),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Color.fromARGB(
                                                                    255,
                                                                    125,
                                                                    125,
                                                                    125),
                                                                width: 1)),
                                                        disabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Color.fromARGB(
                                                                    255,
                                                                    125,
                                                                    125,
                                                                    125),
                                                                width: 1)),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color.fromARGB(255, 125, 125, 125),
                                                                    width: 1)),
                                                        contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                        // prefixIcon: Icon(Icons.email),
                                                        suffixIcon: Icon(Icons.watch_later_outlined, color: Color.fromARGB(255, 0, 0, 0), size: 40 * FCStyle.fem),
                                                        hintText: DateFormat('hh:mm a').format(DateTime.now()).replaceAll('am', 'AM').replaceAll('pm', 'PM'),
                                                        hintStyle: TextStyle(color: Color.fromARGB(255, 143, 146, 161), fontSize: 28 * FCStyle.fem, fontWeight: FontWeight.w600)),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        SizedBox(
                                          width: isEvent ? 10 : 0,
                                        ),
                                        isEvent
                                            ? Flexible(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'End Time',
                                                      style: TextStyle(
                                                          fontSize:
                                                              18 * FCStyle.fem,
                                                          color: Color.fromARGB(
                                                              255,
                                                              125,
                                                              127,
                                                              129),
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        textFieldFocus
                                                            .unfocus();
                                                        if (!isAllDay) {
                                                          showTimePicker(
                                                                  builder: (BuildContext
                                                                          context,
                                                                      Widget?
                                                                          child) {
                                                                    return Theme(
                                                                        data: ThemeData.light()
                                                                            .copyWith(
                                                                          primaryColor:
                                                                              Color(0xFF5155C3),
                                                                          accentColor:
                                                                              Color(0xFF5155C3),
                                                                          colorScheme: ColorScheme.light(
                                                                              primary: ColorPallet.kPrimary,
                                                                              onPrimary: ColorPallet.kPrimaryText),
                                                                          buttonTheme:
                                                                              ButtonThemeData(textTheme: ButtonTextTheme.primary),
                                                                        ),
                                                                        child: child ??
                                                                            SizedBox.shrink());
                                                                  },
                                                                  context:
                                                                      context,
                                                                  initialTime: isEvent
                                                                      ? TimeOfDay(
                                                                          hour: reminder
                                                                              .endTime
                                                                              .hour,
                                                                          minute: reminder
                                                                              .endTime
                                                                              .minute)
                                                                      : TimeOfDay(
                                                                          hour: reminder
                                                                              .startTime
                                                                              .hour,
                                                                          minute: reminder
                                                                              .startTime
                                                                              .minute))
                                                              .then((value) {
                                                            setState(() {
                                                              _endDateController
                                                                  .text = (value !=
                                                                      null)
                                                                  ? DateFormat(
                                                                          'hh:mm a')
                                                                      .format(reminder.startTime.copyWith(
                                                                          hour: value
                                                                              .hour,
                                                                          minute: value
                                                                              .minute))
                                                                      .replaceAll(
                                                                          'am',
                                                                          'AM')
                                                                      .replaceAll(
                                                                          'pm',
                                                                          'PM')
                                                                  : _endDateController
                                                                      .text;
                                                              if (value !=
                                                                  null) {
                                                                reminder.endTime = reminder
                                                                    .startTime
                                                                    .copyWith(
                                                                        hour: value
                                                                            .hour,
                                                                        minute:
                                                                            value.minute);
                                                              }
                                                            });
                                                          });
                                                        } else {}
                                                      },
                                                      child: IgnorePointer(
                                                        child: TextFormField(
                                                          controller:
                                                              _endDateController,
                                                          enabled: true,
                                                          validator: (value) {
                                                            if (isEvent &&
                                                                reminder
                                                                    .startTime
                                                                    .isAfter(
                                                                        reminder
                                                                            .endTime)) {
                                                              return 'Endtime is smaller than startTime';
                                                            } else
                                                              return null;
                                                          },
                                                          style: TextStyle(
                                                              color: isAllDay
                                                                  ? Color
                                                                      .fromARGB(
                                                                          255,
                                                                          143,
                                                                          146,
                                                                          161)
                                                                  : Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0),
                                                              fontSize: 28 *
                                                                  FCStyle.fem,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          decoration:
                                                              InputDecoration(
                                                                  errorStyle: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                  focusColor:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          125,
                                                                          125,
                                                                          125),
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              125,
                                                                              125,
                                                                              125),
                                                                          width:
                                                                              1)),
                                                                  disabledBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              125,
                                                                              125,
                                                                              125),
                                                                          width: 1)),
                                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                                  contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 10, right: 0),
                                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                                  // prefixIcon: Icon(Icons.email),
                                                                  suffixIcon: Icon(Icons.watch_later_outlined, color: Color.fromARGB(255, 7, 7, 7), size: 40 * FCStyle.fem),
                                                                  hintText: DateFormat('hh:mm a').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour + 1, DateTime.now().minute)).replaceAll('am', 'AM').replaceAll('pm', 'PM'),
                                                                  hintStyle: TextStyle(color: Color.fromARGB(255, 143, 146, 161), fontSize: 28 * FCStyle.fem, fontWeight: FontWeight.w600)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                            : SizedBox(width: 0),
                                      ]),
                                      Row(children: [
                                        Flexible(
                                            flex: 3,
                                            child: InkWell(
                                              onTap: () {
                                                textFieldFocus.unfocus();
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Recurrence',
                                                    style: TextStyle(
                                                        fontSize:
                                                            18 * FCStyle.fem,
                                                        color: Color.fromARGB(
                                                            255, 125, 127, 129),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      textFieldFocus.unfocus();
                                                      await showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            // var _dropDownValue =
                                                            //     'After';

                                                            return StatefulBuilder(
                                                                builder: (context,
                                                                        setStateSB) =>
                                                                    AlertDialog(
                                                                      titlePadding:
                                                                          EdgeInsets.all(
                                                                              0),
                                                                      title:
                                                                          Container(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            43 *
                                                                                FCStyle.fem,
                                                                            24 * FCStyle.fem,
                                                                            15 * FCStyle.fem,
                                                                            16 * FCStyle.fem),
                                                                        width: double
                                                                            .infinity,
                                                                        height: 95 *
                                                                            FCStyle.fem,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: ColorPallet
                                                                              .kPrimary
                                                                              .withOpacity(0.1),
                                                                          borderRadius:
                                                                              BorderRadius.circular(10 * FCStyle.fem),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Container(
                                                                              margin: EdgeInsets.fromLTRB(0 * FCStyle.fem, 0 * FCStyle.fem, 420 * FCStyle.fem, 0 * FCStyle.fem),
                                                                              child: Text(
                                                                                'Select Recurrence Type',
                                                                                style: TextStyle(
                                                                                  fontSize: 45 * FCStyle.ffem,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  height: 1 * FCStyle.ffem / FCStyle.fem,
                                                                                  color: Color(0xff000000),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              margin: EdgeInsets.fromLTRB(0 * FCStyle.fem, 0 * FCStyle.fem, 0 * FCStyle.fem, 1 * FCStyle.fem),
                                                                              child: TextButton(
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
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

                                                                      content:
                                                                          SingleChildScrollView(
                                                                        scrollDirection:
                                                                            Axis.vertical,
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text('Repeat Weekly '),
                                                                                  Text('every  '),
                                                                                  SizedBox(
                                                                                      width: 60,
                                                                                      height: 40,
                                                                                      child: Container(
                                                                                        width: 60.0,
                                                                                        foregroundDecoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(5.0),
                                                                                          border: Border.all(
                                                                                            color: Colors.blueGrey,
                                                                                            width: 2.0,
                                                                                          ),
                                                                                        ),
                                                                                        child: Row(
                                                                                          children: <Widget>[
                                                                                            Expanded(
                                                                                              flex: 1,
                                                                                              child: TextFormField(
                                                                                                textAlign: TextAlign.center,
                                                                                                decoration: InputDecoration(
                                                                                                  contentPadding: EdgeInsets.all(8.0),
                                                                                                  border: OutlineInputBorder(
                                                                                                    borderRadius: BorderRadius.circular(5.0),
                                                                                                  ),
                                                                                                ),
                                                                                                controller: _intervalController,
                                                                                                keyboardType: TextInputType.numberWithOptions(
                                                                                                  decimal: false,
                                                                                                  signed: false,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              height: 38.0,
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: <Widget>[
                                                                                                  Container(
                                                                                                    decoration: BoxDecoration(
                                                                                                      border: Border(
                                                                                                        bottom: BorderSide(
                                                                                                          width: 0.5,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    child: InkWell(
                                                                                                      child: Icon(
                                                                                                        Icons.arrow_drop_up,
                                                                                                        size: 18.0,
                                                                                                      ),
                                                                                                      onTap: () {
                                                                                                        int currentValue = int.parse(_intervalController.text);
                                                                                                        setState(() {
                                                                                                          currentValue++;
                                                                                                          _intervalController.text = (currentValue).toString(); // incrementing value
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                  ),
                                                                                                  InkWell(
                                                                                                    child: Icon(
                                                                                                      Icons.arrow_drop_down,
                                                                                                      size: 18.0,
                                                                                                    ),
                                                                                                    onTap: () {
                                                                                                      int currentValue = int.parse(_intervalController.text);
                                                                                                      setState(() {
                                                                                                        currentValue--;
                                                                                                        _intervalController.text = (currentValue > 1 ? currentValue : 1).toString(); // decrementing value
                                                                                                      });
                                                                                                    },
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      )),
                                                                                  Text('  week(s) on '),
                                                                                  Container(
                                                                                    width: 350,
                                                                                    height: 60,
                                                                                    child: ListView(
                                                                                      scrollDirection: Axis.horizontal,
                                                                                      children: values.keys.map((String key) {
                                                                                        return Container(
                                                                                            alignment: Alignment.center,
                                                                                            width: 50,
                                                                                            height: 30,
                                                                                            child: Column(
                                                                                              children: [
                                                                                                InkWell(
                                                                                                  onTap: () {
                                                                                                    setStateSB(() {
                                                                                                      values[key] = !values[key]!;
                                                                                                    });
                                                                                                  },
                                                                                                  child: Container(
                                                                                                    width: 30,
                                                                                                    height: 30,
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: values[key]! ? ColorPallet.kSecondary : Color.fromARGB(77, 255, 255, 255),
                                                                                                      shape: BoxShape.rectangle,
                                                                                                      borderRadius: BorderRadius.circular(9),
                                                                                                      border: Border.all(
                                                                                                        color: values[key]! ? ColorPallet.kSecondary : ColorPallet.kSecondary,
                                                                                                        width: 3,
                                                                                                      ),
                                                                                                    ),
                                                                                                    child: values[key]!
                                                                                                        ? Icon(
                                                                                                            Icons.check_rounded,
                                                                                                            color: ColorPallet.kLightBackGround,
                                                                                                            weight: 700,
                                                                                                          )
                                                                                                        : SizedBox.shrink(),
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(height: 5),
                                                                                                Text(key)
                                                                                              ],
                                                                                            ));
                                                                                      }).toList(),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 20),
                                                                              Row(
                                                                                children: [
                                                                                  Text('Ends '),
                                                                                  Container(
                                                                                    width: 120,
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: DropdownButton<String>(
                                                                                      isExpanded: true,
                                                                                      hint: _dropDownEndValue == ''
                                                                                          ? Text('After', style: TextStyle(color: Colors.black))
                                                                                          : Text(
                                                                                              _dropDownEndValue,
                                                                                              style: TextStyle(color: Colors.black),
                                                                                            ),
                                                                                      onChanged: (val) {
                                                                                        setStateSB(() {
                                                                                          _dropDownEndValue = val!;
                                                                                        });
                                                                                      },
                                                                                      items: [
                                                                                        'After',
                                                                                        'On Date'
                                                                                      ].map(
                                                                                        (val) {
                                                                                          return DropdownMenuItem<String>(
                                                                                            value: val,
                                                                                            child: Text(val),
                                                                                          );
                                                                                        },
                                                                                      ).toList(),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 12,
                                                                                  ),
                                                                                  (_dropDownEndValue == 'On Date')
                                                                                      ? Container(
                                                                                          width: 180,
                                                                                          height: 40,
                                                                                          child: InkWell(
                                                                                            onTap: () {
                                                                                              showDatePicker(
                                                                                                      builder: (BuildContext context, Widget? child) {
                                                                                                        return Theme(
                                                                                                            data: ThemeData.light().copyWith(
                                                                                                              primaryColor: ColorPallet.kPrimary,
                                                                                                              accentColor: ColorPallet.kPrimary,
                                                                                                              colorScheme: ColorScheme.light(
                                                                                                                primary: ColorPallet.kPrimary,
                                                                                                                onPrimary: ColorPallet.kPrimaryText,
                                                                                                              ),
                                                                                                              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                                                                                                            ),
                                                                                                            child: child ?? SizedBox.shrink());
                                                                                                      },
                                                                                                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                                                                                                      context: context,
                                                                                                      initialDate: EndDate,
                                                                                                      firstDate: DateTime.now(),
                                                                                                      lastDate: DateTime(DateTime.now().year + 4, DateTime.now().month, DateTime.now().day))
                                                                                                  .then((value) {
                                                                                                setState(() {
                                                                                                  _recurrenceEndDateController.text = (value != null) ? DateFormat('MM-dd-yyyy').format(value) : _recurrenceEndDateController.text;
                                                                                                  if (value != null) {
                                                                                                    EndDate = value;
                                                                                                    recurrenceModel.until = value;
                                                                                                  } else {
                                                                                                    recurrenceModel.until = EndDate;
                                                                                                  }
                                                                                                });
                                                                                              });
                                                                                            },
                                                                                            child: TextField(
                                                                                              controller: _recurrenceEndDateController,
                                                                                              enabled: false,
                                                                                              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 28 * FCStyle.fem, fontWeight: FontWeight.w600),
                                                                                              decoration: InputDecoration(
                                                                                                  focusColor: Color.fromARGB(255, 125, 125, 125),
                                                                                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                                                                  disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                                                                  contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                                                                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                                                                  // prefixIcon: Icon(Icons.email),
                                                                                                  suffixIcon: Icon(Icons.calendar_today_outlined),
                                                                                                  hintText: DateFormat('MM-dd-yyyy').format(DateTime.now()),
                                                                                                  hintStyle: TextStyle(color: Color.fromARGB(255, 143, 146, 161), fontSize: 28 * FCStyle.fem, fontWeight: FontWeight.w600)),
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                      : SizedBox(
                                                                                          width: 60,
                                                                                          height: 40,
                                                                                          child: Container(
                                                                                            width: 60.0,
                                                                                            foregroundDecoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                                              border: Border.all(
                                                                                                color: Colors.blueGrey,
                                                                                                width: 2.0,
                                                                                              ),
                                                                                            ),
                                                                                            child: Row(
                                                                                              children: <Widget>[
                                                                                                Expanded(
                                                                                                  flex: 1,
                                                                                                  child: TextFormField(
                                                                                                    textAlign: TextAlign.center,
                                                                                                    decoration: InputDecoration(
                                                                                                      contentPadding: EdgeInsets.all(8.0),
                                                                                                      border: OutlineInputBorder(
                                                                                                        borderRadius: BorderRadius.circular(5.0),
                                                                                                      ),
                                                                                                    ),
                                                                                                    controller: _countController,
                                                                                                    keyboardType: TextInputType.numberWithOptions(
                                                                                                      decimal: false,
                                                                                                      signed: false,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Container(
                                                                                                  height: 38.0,
                                                                                                  child: Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: <Widget>[
                                                                                                      Container(
                                                                                                        decoration: BoxDecoration(
                                                                                                          border: Border(
                                                                                                            bottom: BorderSide(
                                                                                                              width: 0.5,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        child: InkWell(
                                                                                                          child: Icon(
                                                                                                            Icons.arrow_drop_up,
                                                                                                            size: 18.0,
                                                                                                          ),
                                                                                                          onTap: () {
                                                                                                            int currentValue = int.parse(_countController.text);
                                                                                                            setState(() {
                                                                                                              currentValue++;
                                                                                                              _countController.text = (currentValue).toString(); // incrementing value
                                                                                                            });
                                                                                                          },
                                                                                                        ),
                                                                                                      ),
                                                                                                      InkWell(
                                                                                                        child: Icon(
                                                                                                          Icons.arrow_drop_down,
                                                                                                          size: 18.0,
                                                                                                        ),
                                                                                                        onTap: () {
                                                                                                          int currentValue = int.parse(_countController.text);
                                                                                                          setState(() {
                                                                                                            currentValue--;
                                                                                                            _countController.text = (currentValue > 1 ? currentValue : 1).toString(); // decrementing value
                                                                                                          });
                                                                                                        },
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          )),
                                                                                  SizedBox(
                                                                                    width: 7,
                                                                                  ),
                                                                                  _dropDownEndValue == 'After' ? Text(isEvent ? ' event(s)' : ' reminder(s)') : SizedBox.shrink(),
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 20),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      FCMaterialButton(
                                                                                        defaultSize: false,
                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                        color: ColorPallet.kPrimary,
                                                                                        onPressed: () {
                                                                                          List<int> week = [];
                                                                                          int i = 0;
                                                                                          for (var v in values.values) {
                                                                                            if (v == true) {
                                                                                              week.add(i);
                                                                                            }
                                                                                            i++;
                                                                                            //below is the solution
                                                                                          }
                                                                                          recurrenceModel.byday = week;
                                                                                          recurrenceModel.isAfter = _dropDownEndValue == 'After' ? true : false;
                                                                                          recurrenceModel.count = int.parse(_countController.text);
                                                                                          recurrenceModel.interval = int.parse(_intervalController.text);
                                                                                          recurrenceModel.until = EndDate;
                                                                                          _RecurrenceController.text = 'Occur every ' + recurrenceModel.interval.toString() + (recurrenceModel.interval > 1 ? ' weeks' : ' week') + ', until ' + (recurrenceModel.isAfter == true ? (recurrenceModel.count.toString() + (isEvent ? (recurrenceModel.count > 1 ? ' events ' : ' event') : (recurrenceModel.count > 1 ? '   reminders' : ' reminder'))) : DateFormat('MM-dd-yyyy').format(recurrenceModel.until!));
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Text(
                                                                                          "Done",
                                                                                          style: FCStyle.textStyle.copyWith(
                                                                                            color: ColorPallet.kPrimaryText,
                                                                                            fontSize: 25 * FCStyle.fem,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 20,
                                                                                      ),
                                                                                      FCMaterialButton(
                                                                                        isBorder: true,
                                                                                        defaultSize: false,
                                                                                        borderColor: Color(0xFF963209),
                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                        color: ColorPallet.kWhite,
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            _RecurrenceController.text = "Don't Repeat";
                                                                                          });

                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Text(
                                                                                          "Don't Repeat ",
                                                                                          style: FCStyle.textStyle.copyWith(
                                                                                            color: Color(0xFF963209),
                                                                                            fontSize: 25 * FCStyle.fem,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      // TextField(
                                                                      //   onChanged: (value) {},
                                                                      //   decoration: const InputDecoration(
                                                                      //       hintText:
                                                                      //           "Text Field in Dialog"),
                                                                      // ),
                                                                    ));
                                                          });
                                                    },
                                                    child: TextFormField(
                                                      controller:
                                                          _RecurrenceController,
                                                      enabled: false,
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0),
                                                          fontSize:
                                                              28 * FCStyle.fem,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      decoration:
                                                          InputDecoration(
                                                              focusColor: Color.fromARGB(
                                                                  255, 125, 125, 125),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          125,
                                                                          125,
                                                                          125),
                                                                      width:
                                                                          1)),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          125,
                                                                          125,
                                                                          125),
                                                                      width:
                                                                          1)),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                              contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                              // prefixIcon: Icon(Icons.email),
                                                              suffixIcon: Icon(Icons.repeat, color: Colors.black),
                                                              hintText: 'Do Not Repeat',
                                                              hintStyle: TextStyle(color: Color.fromARGB(255, 143, 146, 161), fontSize: 28 * FCStyle.fem, fontWeight: FontWeight.w600)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        SizedBox(
                                          width: isEvent ? 10 : 0,
                                        ),
                                        isEvent
                                            ? Flexible(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 24,
                                                    ),
                                                    Container(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        125,
                                                                        125,
                                                                        125),
                                                                width: 1)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'All Day',
                                                              style: TextStyle(
                                                                  color: isAllDay
                                                                      ? Colors
                                                                          .black
                                                                      : Color.fromARGB(
                                                                          255,
                                                                          143,
                                                                          146,
                                                                          161),
                                                                  fontSize: 26 *
                                                                      FCStyle
                                                                          .fem,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            CupertinoSwitch(
                                                              activeColor:
                                                                  ColorPallet
                                                                      .kPrimary,
                                                              trackColor: Color
                                                                  .fromARGB(
                                                                      231,
                                                                      158,
                                                                      158,
                                                                      158),
                                                              value: isAllDay,
                                                              onChanged:
                                                                  (bool value) {
                                                                setState(() {
                                                                  isAllDay =
                                                                      value;
                                                                });
                                                              },
                                                            )
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                              )
                                            : SizedBox(width: 0),
                                      ]),
                                      SizedBox(height: 8),
                                      Container(
                                        alignment: Alignment.bottomRight,
                                        child: FCMaterialButton(
                                          elevation: 6,
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              // If the form is valid, display a snackbar. In the real world,
                                              // you'd often call a server or save the information in a database.
                                              setState(
                                                () => {isEditing = true},
                                              );
                                              reminder.allDay = isAllDay;
                                              reminder.itemType = isEvent
                                                  ? ClientReminderType.EVENT
                                                  : ClientReminderType.REMINDER;
                                            } else {}
                                          },
                                          defaultSize: false,
                                          color: ColorPallet.kPrimary,
                                          child: SizedBox(
                                            width: FCStyle.largeFontSize * 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3.0),
                                              child: Center(
                                                child: Text(
                                                  'Next',
                                                  style: FCStyle.textStyle
                                                      .copyWith(
                                                    color: ColorPallet
                                                        .kPrimaryText,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]))
                        ]),
                  ),
                ),
        ));
  },
);
  }

  void BackToStep() {
    isEditing
        ? setState(
            () {
              isEditing = false;
            },
          )
        : fcRouter.pop();
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}
