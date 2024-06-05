import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/entity/dosage.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/utils/how_much_dosage_input.dart';

import '../../../../core/blocs/auth_bloc/auth_bloc.dart';
import '../../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart' as ThemeBloc;
import '../../../../core/enitity/user.dart';
import '../../../../core/router/router_delegate.dart';
import '../../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../../../../core/screens/home_screen/widgets/logout_button.dart';
import '../../../../shared/fc_back_button.dart';
import '../../../../shared/fc_bottom_status_bar.dart';
import '../../../../shared/fc_confirm_dialog.dart';
import '../../../../shared/fc_material_button.dart';
import '../../../../shared/popup_scaffold.dart';
import '../../../../shared/famici_scaffold.dart';
import '../../../../utils/config/color_pallet.dart';
import '../../../../utils/config/famici.theme.dart';
import '../../../../utils/constants/assets_paths.dart';
import '../../../calander/blocs/calendar/calendar_bloc.dart';
import '../../../notification/helper/medication_notify_helper.dart';
import '../add_medication/blocs/add_medication/add_medication_bloc.dart';
import '../add_medication/screens/select_medication_type_popup.dart';
import '../blocs/medication_bloc.dart';
import '../entity/selected_medication_details.dart';

class AddEditMedicationScreen extends StatefulWidget {
  AddEditMedicationScreen({Key? key, this.medicine}) : super(key: key);
  final SelectedMedicationDetails? medicine;
  @override
  State<AddEditMedicationScreen> createState() =>
      _AddEditMedicationScreenState();
}

class _AddEditMedicationScreenState extends State<AddEditMedicationScreen> {
  Dosage dose = Dosage(
      detail: '',
      quantity: HowMuchDosageInput.dirty(value: '1'),
      time: '',
      hasQuantity: true);
  SelectedMedicationDetails newMedDetails = SelectedMedicationDetails(
    endDate: DateFormat("yyyy-MM-dd").format(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1)),
    medicationName: '',
    startDate: DateFormat("yyyy-MM-dd").format(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day)),
    isRemind: false,
  );
  bool showError = false;
  List<String> sigTypes = [
    "Take 1 tablet daily",
    "Take 1 tablet at bedtime",
    "Take 1 tablet twice daily",
    "Take 1 tablet daily in the evening",
    "Take 2 tablets once daily",
    "Take 2 tablets at bedtime",
    "Take 2 tablets daily in the evening",
    "Take 2 tablets twice daily",
    "Take 1 tablet as needed",
    "Take 2 tablets as needed",
  ];
  final _formKey = GlobalKey<FormState>();
  DateTime _medTimeRaw = DateTime.now();
  FocusNode textFieldFocus = FocusNode();
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _prescriberNameController =
      TextEditingController();

  late TextEditingController _medTypeController = TextEditingController();
  late TextEditingController _sigController = TextEditingController();
  late TextEditingController _medTimeController = TextEditingController();
  late TextEditingController _quantityController = TextEditingController();
  late TextEditingController _medRemTimeController = TextEditingController();
  FocusNode medicationNameFoucs = FocusNode();
  TimeOfDay? pickedTime;
  FocusNode prescriberNameFocus = FocusNode();
  FocusNode quantityFocus = FocusNode();
  late TextEditingController _startDateController = TextEditingController();
  late TextEditingController _endDateController = TextEditingController();
  var isEditing = false;
  bool setReminder = false;
  @override
  void initState() {
    // TODO: implement initState
    if (widget.medicine != null) {
      //name
      _nameController.text = widget.medicine!.medicationName!;
      newMedDetails.medicationName = widget.medicine!.medicationName!;

      //prescriber name
      if (widget.medicine?.prescriberName != null) {
        _prescriberNameController.text = widget.medicine!.prescriberName!;
        newMedDetails.prescriberName = widget.medicine!.prescriberName!;
      }

      //startDate
      newMedDetails.startDate = widget.medicine!.startDate!;
      _startDateController.text = DateFormat('MM-dd-yyyy')
          .format(DateTime.parse(newMedDetails!.startDate!));

      //endDate
      newMedDetails.endDate = widget.medicine!.endDate!;
      _endDateController.text = DateFormat('MM-dd-yyyy')
          .format(DateTime.parse(newMedDetails!.endDate!));

      //med type
      if (widget.medicine?.medicationType == null) {
      } else {
        _medTypeController.text = widget.medicine!.medicationType!;

        newMedDetails.medicationType = widget.medicine!.medicationType!;
      }
      newMedDetails.medicationTypeId = widget.medicine!.medicationTypeId!;
      //dose ID
      dose.id = widget.medicine!.dosageList![0].id!;
      //quantity
      dose.quantity = widget.medicine!.dosageList![0].quantity;
      _quantityController.text = dose.quantity.value;

      //sig
      dose.detail = widget.medicine!.dosageList![0].detail;
      _sigController.text = widget.medicine!.dosageList![0].detail;

// isReminder
      setReminder = (widget.medicine!.isRemind!);
      if (widget.medicine!.isRemind != false) {
// remTime
        if (widget.medicine?.medicationReminderTime != null) {
          DateTime remTime = DateFormat("HH:mm")
              .parse(widget.medicine!.medicationReminderTime!);
          pickedTime = TimeOfDay(hour: remTime.hour, minute: remTime.minute);
          _medRemTimeController.text = DateFormat('hh:mm a')
              .format(remTime)
              .replaceAll('am', 'AM')
              .replaceAll('pm', 'PM');

          print('hi isha this is' + _medRemTimeController.text);
        }
      }

      //medTime
      dose.time = widget.medicine!.dosageList![0].time;
      _medTimeRaw =
          DateFormat("HH:mm").parse(widget.medicine!.dosageList![0].time);
      _medTimeController.text = DateFormat('hh:mm a')
          .format(_medTimeRaw)
          .replaceAll('am', 'AM')
          .replaceAll('pm', 'PM');
    } else {
      _medTimeController.text = '';
      _startDateController.text = '';
      _endDateController.text = '';
      _sigController.text = '';
      _quantityController.text = '';

      _medTypeController.text = '';
      dose.detail = sigTypes[0];
      dose.time = DateFormat('HH:mm').format(_medTimeRaw);
    }

    super.initState();
  }

  Widget build(BuildContext context) {
    AddMedicationBloc addMedicationBloc =
        AddMedicationBloc(context.read<AuthBloc>());
    return BlocBuilder<ThemeBloc.ThemeBuilderBloc, ThemeBloc.ThemeBuilderState>(
  builder: (context, stateM) {
    return FamiciScaffold(
        toolbarHeight: 140.h,
        leading: FCBackButton(
          onPressed: BackToStep,
        ),
        title: Center(
          child: Text(
            (widget.medicine != null ? 'Edit ' : 'Add ') + 'Medication',
            style: FCStyle.textStyle
                .copyWith(fontSize: 50.sp, fontWeight: FontWeight.w700),
          ),
        ),
        topRight: LogoutButton(),
        bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
        child: Form(
            key: _formKey,
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.focusedChild?.unfocus();
                }
              },
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(('Medication Summary'),
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
                                  SizedBox(
                                    height: 23,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Medication Name',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 125, 127, 129),
                                            fontSize: 20 * FCStyle.fem,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(newMedDetails.medicationName!,
                                          maxLines: 2,
                                          overflow: TextOverflow.visible,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28 * FCStyle.fem,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 23,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Prescriber Name',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 125, 127, 129),
                                            fontSize: 20 * FCStyle.fem,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(newMedDetails.prescriberName!,
                                          maxLines: 2,
                                          overflow: TextOverflow.visible,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28 * FCStyle.fem,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 23,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Start Date',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 125, 127, 129),
                                            fontSize: 20 * FCStyle.fem,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          color: ColorPallet.kPrimary,
                                          size: 28 * FCStyle.fem,
                                        ),
                                        SizedBox(width: 13),
                                        Text(
                                            DateFormat('MM-dd-yyyy').format(
                                                DateTime.parse(
                                                    newMedDetails.startDate!)),
                                            style: TextStyle(
                                                color: ColorPallet.kPrimary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25 * FCStyle.fem))
                                      ])
                                    ],
                                  ),
                                  SizedBox(
                                    height: 23,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'End Date',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 125, 127, 129),
                                            fontSize: 20 * FCStyle.fem,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          color: ColorPallet.kPrimary,
                                          size: 28 * FCStyle.fem,
                                        ),
                                        SizedBox(width: 13),
                                        Text(
                                            DateFormat('MM-dd-yyyy').format(
                                                DateTime.parse(
                                                    newMedDetails.endDate!)),
                                            style: TextStyle(
                                                color: ColorPallet.kPrimary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25 * FCStyle.fem))
                                      ])
                                    ],
                                  ),
                                ],
                              )),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                              margin: EdgeInsets.only(
                                  right: 20, top: 0, bottom: 16),
                              padding: EdgeInsets.only(
                                  top: 50 * FCStyle.fem, bottom: 30),
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(244, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                padding: EdgeInsets.only(left: 25, right: 25),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Medication Type',
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
                                            Navigator.of(context)
                                                .push(PageRouteBuilder(
                                                    opaque: false,
                                                    pageBuilder:
                                                        (BuildContext context1,
                                                            _, __) {
                                                      return SelectMedicationTypePopup(
                                                        addMedicationBloc:
                                                            addMedicationBloc,
                                                      );
                                                    }))
                                                .then((value) {
                                              if (value == true) {
                                                setState(() {
                                                  _medTypeController.text =
                                                      addMedicationBloc
                                                          .state
                                                          .selectedMedicationType
                                                          .medicationType
                                                          .toString();
                                                  newMedDetails.medicationType =
                                                      addMedicationBloc
                                                          .state
                                                          .selectedMedicationType
                                                          .medicationType
                                                          .toString();
                                                  print('so this is' +
                                                      addMedicationBloc.state
                                                          .selectedMedicationType
                                                          .toString());
                                                  newMedDetails
                                                          .medicationTypeId =
                                                      addMedicationBloc
                                                          .state
                                                          .selectedMedicationType
                                                          .medicationTypeId;
                                                });
                                              }
                                            });
                                          },
                                          child: TextFormField(
                                            validator: (value) {
                                              print('hi checking for _medtype' +
                                                  _medTypeController.text);
                                              if (_medTypeController
                                                  .text.isEmpty) {
                                                return "";
                                              }
                                            },
                                            controller: _medTypeController,
                                            enabled: false,
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
                                                errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red,
                                                        width: 1)),
                                                errorStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 155, 44, 36),
                                                    height: 0),
                                                contentPadding: EdgeInsets.only(
                                                    top: 12,
                                                    bottom: 12,
                                                    left: 14,
                                                    right: 14),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                // prefixIcon: Icon(Icons.email),
                                                suffixIcon: Icon(Icons.arrow_drop_down_rounded, color: Color.fromARGB(255, 0, 0, 0), size: 60 * FCStyle.fem),
                                                hintText: 'Medication Type',
                                                hintStyle: TextStyle(color: Color.fromARGB(255, 143, 146, 161), fontSize: 28 * FCStyle.fem, fontWeight: FontWeight.w600)),
                                          ),
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
                                          'Quantity',
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
                                          validator: (value) {
                                            if (_quantityController.text ==
                                                '') {
                                              return '';
                                            } else if (_quantityController
                                                    .text ==
                                                '0') {
                                              return 'Quantity cannot be 0';
                                            }
                                            ;
                                          },
                                          inputFormatters: [
                                            UpperCaseTextFormatter()
                                          ],
                                          keyboardType: TextInputType.number,
                                          focusNode: textFieldFocus,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          controller: _quantityController,
                                          autofocus: false,
                                          onChanged: (value) {
                                            dose.quantity =
                                                HowMuchDosageInput.dirty(
                                                    value: value.toString());
                                          },
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 28 * FCStyle.fem,
                                              fontWeight: FontWeight.w600),
                                          decoration: InputDecoration(
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 1,
                                                  )),
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
                                              contentPadding:
                                                  EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                              hintText: 'Number of units in bottle',
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
                                        Row(
                                          children: [
                                            Text(
                                              'Dosage',
                                              style: TextStyle(
                                                  fontSize: 18 * FCStyle.fem,
                                                  color: Color.fromARGB(
                                                      255, 125, 127, 129),
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide.none),
                                            labelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontSize: 28 * FCStyle.fem,
                                                fontWeight: FontWeight.w600),
                                            errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 1)),
                                            errorStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 155, 44, 36),
                                                height: 0),
                                            contentPadding: EdgeInsets.only(
                                                left: 8, right: 4, bottom: 0),
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
                                                  width: 1),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (_sigController.text == '') {
                                              return "";
                                            }
                                            ;
                                          },
                                          icon: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12.0),
                                            child: Icon(
                                                Icons.arrow_drop_down_rounded,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                size: 60 * FCStyle.fem),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          // underline: SizedBox.shrink(),
                                          isExpanded: true,
                                          hint: _sigController.text == ''
                                              ? Text(
                                                  '  Select Quantity & Frequency',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 143, 146, 161),
                                                      fontSize:
                                                          28 * FCStyle.fem,
                                                      fontWeight:
                                                          FontWeight.w600))
                                              : Text(
                                                  _sigController.text,
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontSize:
                                                          28 * FCStyle.fem,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                          onChanged: (val) {
                                            setState(() {
                                              _sigController.text = val!;
                                              dose.detail = val!;
                                            });
                                          },
                                          items: sigTypes.map(
                                            (val) {
                                              return DropdownMenuItem<String>(
                                                value: val,
                                                child: Container(

                                                    // padding: EdgeInsets.only(
                                                    //     left: 14),
                                                    child: Text(
                                                  val,
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontSize:
                                                          28 * FCStyle.fem,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                              );
                                            },
                                          ).toList(),
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
                                          'Medication Time',
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

                                            showTimePicker(
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      return Theme(
                                                          data:
                                                              ThemeData.light()
                                                                  .copyWith(
                                                            primaryColor:
                                                                ColorPallet
                                                                    .kPrimary,
                                                            accentColor:
                                                                ColorPallet
                                                                    .kPrimary,
                                                            colorScheme: ColorScheme.light(
                                                                primary:
                                                                    ColorPallet
                                                                        .kPrimary,
                                                                onPrimary:
                                                                    ColorPallet
                                                                        .kPrimaryText),
                                                            buttonTheme:
                                                                ButtonThemeData(
                                                                    textTheme:
                                                                        ButtonTextTheme
                                                                            .primary),
                                                          ),
                                                          child: child ??
                                                              SizedBox
                                                                  .shrink());
                                                    },
                                                    context: context,
                                                    initialTime: TimeOfDay(
                                                        hour: _medTimeRaw.hour,
                                                        minute:
                                                            _medTimeRaw.minute))
                                                .then((value) {
                                              setState(() {
                                                _medTimeController
                                                    .text = (value !=
                                                        null)
                                                    ? DateFormat('hh:mm a')
                                                        .format(_medTimeRaw
                                                            .copyWith(
                                                                hour:
                                                                    value.hour,
                                                                minute: value
                                                                    .minute))
                                                        .replaceAll('am', 'AM')
                                                        .replaceAll('pm', 'PM')
                                                    : _medTimeController.text;
                                                if (value != null) {
                                                  _medTimeRaw =
                                                      _medTimeRaw.copyWith(
                                                          hour: value.hour,
                                                          minute: value.minute);
                                                  dose.time =
                                                      DateFormat('HH:mm')
                                                          .format(_medTimeRaw);
                                                }
                                              });
                                            });
                                          },
                                          child: TextFormField(
                                            validator: (value) {
                                              if (_medTimeController.text ==
                                                  "") {
                                                return '';
                                              }
                                            },
                                            controller: _medTimeController,
                                            enabled: false,
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontSize: 28 * FCStyle.fem,
                                                fontWeight: FontWeight.w600),
                                            decoration: InputDecoration(
                                                errorStyle:
                                                    TextStyle(height: 0),
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
                                                errorBorder:
                                                    OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1)),
                                                contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                // prefixIcon: Icon(Icons.email),
                                                suffixIcon: Icon(Icons.watch_later_outlined, color: Color.fromARGB(255, 0, 0, 0), size: 40 * FCStyle.fem),
                                                hintText: 'Enter Medication time',
                                                hintStyle: TextStyle(color: Color.fromARGB(255, 143, 146, 161), fontSize: 28 * FCStyle.fem, fontWeight: FontWeight.w600)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Set Reminder',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 28 * FCStyle.fem,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: ((context1) {
                                                      return PopupScaffold(
                                                        width:
                                                            750 * FCStyle.fem,
                                                        height:
                                                            451 * FCStyle.fem,
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                176, 0, 0, 0),
                                                        bodyColor:
                                                            Colors.transparent,
                                                        constrained: false,
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xffffffff),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10 *
                                                                        FCStyle
                                                                            .fem),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                padding: EdgeInsets.fromLTRB(
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
                                                                width: double
                                                                    .infinity,
                                                                height: 95 *
                                                                    FCStyle.fem,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: ColorPallet
                                                                      .kPrimary
                                                                      .withOpacity(
                                                                          0.1),
                                                                  borderRadius:
                                                                      BorderRadius.circular(10 *
                                                                          FCStyle
                                                                              .fem),
                                                                ),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      'Set Reminder',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            45 *
                                                                                FCStyle.ffem,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        height: 1 *
                                                                            FCStyle.ffem /
                                                                            FCStyle.fem,
                                                                        color: Color(
                                                                            0xff000000),
                                                                      ),
                                                                    ),
                                                                    const Spacer(),
                                                                    Container(
                                                                      margin: EdgeInsets.fromLTRB(
                                                                          0 * FCStyle.fem,
                                                                          0 * FCStyle.fem,
                                                                          0 * FCStyle.fem,
                                                                          1 * FCStyle.fem),
                                                                      child:
                                                                          TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            setReminder =
                                                                                false;
                                                                            newMedDetails.isRemind =
                                                                                false;
                                                                          });
                                                                          Navigator.pop(
                                                                              context1);
                                                                        },
                                                                        style: TextButton
                                                                            .styleFrom(
                                                                          padding:
                                                                              EdgeInsets.zero,
                                                                        ),
                                                                        child:
                                                                            CircleAvatar(
                                                                          backgroundColor:
                                                                              const Color(0xFFAC2734),
                                                                          radius:
                                                                              35 * FCStyle.fem,
                                                                          child:
                                                                              SvgPicture.asset(
                                                                            AssetIconPath.closeIcon,
                                                                            width:
                                                                                35 * FCStyle.fem,
                                                                            height:
                                                                                35 * FCStyle.fem,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                      margin: EdgeInsets.only(
                                                                          top: 33 *
                                                                              FCStyle
                                                                                  .fem,
                                                                          left: 45 *
                                                                              FCStyle.fem),
                                                                      child: Text(
                                                                        newMedDetails
                                                                            .medicationName!,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontSize:
                                                                              27 * FCStyle.ffem,
                                                                          color:
                                                                              Color(0xff666666),
                                                                        ),
                                                                      )),
                                                                  Container(
                                                                      margin: EdgeInsets.only(
                                                                          top: 33 *
                                                                              FCStyle
                                                                                  .fem,
                                                                          left: 2 *
                                                                              FCStyle.fem),
                                                                      child: Text(
                                                                        ' - Dose 1',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              27 * FCStyle.ffem,
                                                                          color:
                                                                              Color(0xff666666),
                                                                        ),
                                                                      )),
                                                                ],
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.only(
                                                                    top: 33 *
                                                                        FCStyle
                                                                            .fem,
                                                                    left: 45 *
                                                                        FCStyle
                                                                            .fem),
                                                                padding: EdgeInsets.only(
                                                                    left: 10 *
                                                                        FCStyle
                                                                            .fem),
                                                                width: 353 *
                                                                    FCStyle.fem,
                                                                height: 54 *
                                                                    FCStyle.fem,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: ColorPallet
                                                                            .kPrimary,
                                                                        width: 3 *
                                                                            FCStyle
                                                                                .ffem),
                                                                    borderRadius:
                                                                        BorderRadius.circular(10 *
                                                                            FCStyle.fem)),
                                                                child: Center(
                                                                  child:
                                                                      TextField(
                                                                    controller:
                                                                        _medRemTimeController,
                                                                    decoration: InputDecoration.collapsed(
                                                                        hintText:
                                                                            "Enter Time"),
                                                                    readOnly:
                                                                        true,
                                                                    onTap:
                                                                        () async {
                                                                      await showTimePicker(
                                                                        builder: (BuildContext
                                                                                context,
                                                                            Widget?
                                                                                child) {
                                                                          return Theme(
                                                                              data: ThemeData.light().copyWith(
                                                                                primaryColor: ColorPallet.kPrimary,
                                                                                accentColor: ColorPallet.kPrimary,
                                                                                colorScheme: ColorScheme.light(primary: ColorPallet.kPrimary, onPrimary: ColorPallet.kPrimaryText),
                                                                                buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                                                                              ),
                                                                              child: child ?? SizedBox.shrink());
                                                                        },
                                                                        initialTime:
                                                                            TimeOfDay.now(),
                                                                        context:
                                                                            context1,
                                                                        useRootNavigator:
                                                                            false,
                                                                        // builder: (BuildContext context, Widget? child) {
                                                                        //   return MediaQuery(
                                                                        //     data: MediaQuery.of(context)
                                                                        //         .copyWith(alwaysUse24HourFormat: false),
                                                                        //     child: child!,
                                                                        //   );
                                                                        // },
                                                                      ).then(
                                                                          (value) {
                                                                        if (value !=
                                                                            null) {
                                                                          pickedTime =
                                                                              value;
                                                                        }
                                                                      });

                                                                      if (pickedTime !=
                                                                          null) {
                                                                        DateTime parsedTime = DateTime(
                                                                            DateTime.now().year,
                                                                            DateTime.now().month,
                                                                            DateTime.now().day,
                                                                            pickedTime!.hour,
                                                                            pickedTime!.minute);

                                                                        _medRemTimeController
                                                                            .text = DateFormat(
                                                                                'hh:mm a')
                                                                            .format(
                                                                                parsedTime)
                                                                            .replaceAll("pm",
                                                                                "PM")
                                                                            .replaceAll('am',
                                                                                "AM");
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                  margin: EdgeInsets.only(
                                                                      top: 33 *
                                                                          FCStyle
                                                                              .fem,
                                                                      left: 45 *
                                                                          FCStyle
                                                                              .fem),
                                                                  child: Text(
                                                                    dose.detail !=
                                                                            ''
                                                                        ? dose
                                                                            .detail!
                                                                        : '',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize: 27 *
                                                                          FCStyle
                                                                              .ffem,
                                                                      color: Color(
                                                                          0xff666666),
                                                                    ),
                                                                  )),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  if (pickedTime ==
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      showError =
                                                                          true;
                                                                    });
                                                                  } else {
                                                                    DateTime parsedTime = DateTime(
                                                                        DateTime.now()
                                                                            .year,
                                                                        DateTime.now()
                                                                            .month,
                                                                        DateTime.now()
                                                                            .day,
                                                                        pickedTime!
                                                                            .hour,
                                                                        pickedTime!
                                                                            .minute);

                                                                    // MedicationNotificationHelper.createLocalNotification(
                                                                    //     widget.medication, parsedTime);

                                                                    // notificationDb.updateOrInsertReminder(
                                                                    //     widget.medication.medicationId.toString(),
                                                                    //     parsedTime.toString());

                                                                    // context.read<MedicationBloc>().add(
                                                                    //     SetSelectedMedicationReminder(parsedTime.toString()));

                                                                    setState(
                                                                        () {
                                                                      setReminder =
                                                                          true;
                                                                      newMedDetails
                                                                              .isRemind =
                                                                          true;
                                                                      newMedDetails
                                                                          .medicationReminderTime = DateFormat(
                                                                              'HH:mm')
                                                                          .format(
                                                                              parsedTime);
                                                                    });
                                                                    Navigator.pop(
                                                                        context1);
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 207 *
                                                                      FCStyle
                                                                          .fem,
                                                                  height: 65 *
                                                                      FCStyle
                                                                          .fem,
                                                                  margin: EdgeInsets.only(
                                                                      top: 33 *
                                                                          FCStyle
                                                                              .fem,
                                                                      left: 45 *
                                                                          FCStyle
                                                                              .fem),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: ColorPallet
                                                                        .kPrimary,
                                                                    borderRadius:
                                                                        BorderRadius.circular(10 *
                                                                            FCStyle.fem),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Color(
                                                                            0x07000000),
                                                                        offset: Offset(
                                                                            0 * FCStyle.fem,
                                                                            10 * FCStyle.fem),
                                                                        blurRadius:
                                                                            2.5 *
                                                                                FCStyle.fem,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Set Reminder',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            20 *
                                                                                FCStyle.ffem,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        height: 1.05 *
                                                                            FCStyle.ffem /
                                                                            FCStyle.fem,
                                                                        color: Color(
                                                                            0xffffffff),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              if (showError)
                                                                Container(
                                                                  margin: EdgeInsets.only(
                                                                      left: 50 *
                                                                          FCStyle
                                                                              .fem,
                                                                      top: 5 *
                                                                          FCStyle
                                                                              .fem),
                                                                  child: Text(
                                                                    'Please select a time',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize: 18 *
                                                                          FCStyle
                                                                              .ffem,
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }));
                                              },
                                              child: IgnorePointer(
                                                child: CupertinoSwitch(
                                                    activeColor:
                                                        ColorPallet.kPrimary,
                                                    trackColor: Color.fromARGB(
                                                        231, 158, 158, 158),
                                                    value: setReminder,
                                                    onChanged: (val) {}),
                                              ),
                                            )
                                          ],
                                        ),
                                        BlocBuilder<CalendarBloc,
                                                CalendarState>(
                                            builder: (context, state) {
                                          return Container(
                                            padding: EdgeInsets.only(
                                              left: 40 * FCStyle.fem,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                FCMaterialButton(
                                                  elevation: 6,
                                                  onPressed: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      setState(() {
                                                        newMedDetails
                                                            .dosageList = [
                                                          dose
                                                        ];
                                                      });
                                                      DateTime medRemStartDate =
                                                          DateTime.parse(
                                                              newMedDetails
                                                                  .startDate!);
                                                      // if (setReminder == true)
                                                      //   print(
                                                      //       'So this is the whole data : medd dose id ${newMedDetails.dosageList![0].id!} med name ${newMedDetails.medicationName} , pres name (complimentary) ${newMedDetails.prescriberName}, startDate : ${newMedDetails.startDate}, endDate : ${newMedDetails.endDate}, medType and Id: ${newMedDetails.medicationType} and ${newMedDetails.medicationTypeId}, quantity : ${newMedDetails.dosageList![0].quantity!} , SIG : ${newMedDetails.dosageList![0].detail!}, medication Time: ${newMedDetails.dosageList![0].time!}, isReminder : ${setReminder}, reminderTime : ${pickedTime} ');
                                                      // else
                                                      //   print(
                                                      //       'So this is the whole data : med name ${newMedDetails.medicationName} , pres name (complimentary) ${newMedDetails.prescriberName}, startDate : ${newMedDetails.startDate}, endDate : ${newMedDetails.endDate}, medType and Id: ${newMedDetails.medicationType} and ${newMedDetails.medicationTypeId}, quantity : ${newMedDetails.dosageList![0].quantity!} , SIG : ${newMedDetails.dosageList![0].detail!}, medication Time: ${newMedDetails.dosageList![0].time!}, isReminder : ${setReminder}, reminderTime : ${pickedTime} ');
                                                      // ignore: curly_braces_in_flow_control_structures
                                                      if (widget.medicine !=
                                                          null) {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return FCConfirmDialog(
                                                                height: 450,
                                                                width: 830,
                                                                submitText:
                                                                    'Edit',
                                                                cancelText:
                                                                    'Cancel',
                                                                message:
                                                                    "Are you sure you want to edit this Medicine?",
                                                              );
                                                            }).then((value) async {
                                                          if (value == false) {
                                                            fcRouter.pop();
                                                          } else if (value ==
                                                              true) {
                                                            if (newMedDetails
                                                                .isRemind!) {
                                                              context.read<MedicationBloc>().add(UpdateMedication(
                                                                  med:
                                                                      newMedDetails,
                                                                  medicationId: widget
                                                                      .medicine!
                                                                      .medicationId!,
                                                                  medReminderTime: medRemStartDate.copyWith(
                                                                      hour: pickedTime!
                                                                          .hour,
                                                                      minute: pickedTime!
                                                                          .minute)));
                                                            } else {
                                                              context
                                                                  .read<
                                                                      MedicationBloc>()
                                                                  .add(UpdateMedication(
                                                                      med:
                                                                          newMedDetails,
                                                                      medicationId: widget
                                                                          .medicine!
                                                                          .medicationId!));
                                                            }

                                                            fcRouter.pop();
                                                          }
                                                        });
                                                      } else {
                                                        if (newMedDetails
                                                            .isRemind!) {
                                                          context
                                                              .read<
                                                                  MedicationBloc>()
                                                              .add(SetMedication(
                                                                  med:
                                                                      newMedDetails,
                                                                  medReminderTime: medRemStartDate.copyWith(
                                                                      hour: pickedTime!
                                                                          .hour,
                                                                      minute: pickedTime!
                                                                          .minute)));
                                                        } else {
                                                          context
                                                              .read<
                                                                  MedicationBloc>()
                                                              .add(SetMedication(
                                                                  med:
                                                                      newMedDetails));
                                                        }
                                                        fcRouter.pop();
                                                      }
                                                    } else {}
                                                  },
                                                  defaultSize: false,
                                                  color: ColorPallet.kPrimary,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 2.0,
                                                        horizontal: 5),
                                                    child: Center(
                                                      child: Text(
                                                        (widget.medicine != null
                                                                ? 'Edit '
                                                                : 'Save ') +
                                                            'Medication',
                                                        style: FCStyle.textStyle
                                                            .copyWith(
                                                                color: ColorPallet
                                                                    .kPrimaryText,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
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
                                  ],
                                ),
                              )),
                        ),
                      ],
                    )
                  : Container(
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
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Medication Name',
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
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        controller: _nameController,
                                        autofocus: false,
                                        focusNode: medicationNameFoucs,
                                        validator: (value) {
                                          if (value == '') {
                                            return 'Please enter the Medication Name';
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (value) {
                                          newMedDetails.medicationName = value;
                                        },
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
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
                                                borderSide: BorderSide(
                                                    color:
                                                        Color.fromARGB(255, 125, 125, 125),
                                                    width: 1)),
                                            contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                            hintText: 'Enter Medication Name',
                                            hintStyle: TextStyle(color: Color.fromARGB(255, 143, 146, 161), fontSize: 28 * FCStyle.fem, fontWeight: FontWeight.w600)),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Prescriber Name',
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
                                        onTap: () {
                                          medicationNameFoucs.unfocus();
                                        },
                                        inputFormatters: [
                                          UpperCaseTextFormatter()
                                        ],
                                        focusNode: prescriberNameFocus,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        controller: _prescriberNameController,
                                        autofocus: false,
                                        validator: (value) {
                                          if (value == '') {
                                            return 'Please enter the Prescriber Name';
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (value) {
                                          newMedDetails.prescriberName = value;
                                        },
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
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
                                                borderSide: BorderSide(
                                                    color:
                                                        Color.fromARGB(255, 125, 125, 125),
                                                    width: 1)),
                                            contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                            hintText: 'Enter Prescriber Name',
                                            hintStyle: TextStyle(color: Color.fromARGB(255, 143, 146, 161), fontSize: 28 * FCStyle.fem, fontWeight: FontWeight.w600)),
                                      ),
                                    ],
                                  ),
                                  Row(children: [
                                    Flexible(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Start Date',
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
                                                medicationNameFoucs.unfocus();
                                                prescriberNameFocus.unfocus();
                                                showDatePicker(
                                                        builder: (BuildContext
                                                                context,
                                                            Widget? child) {
                                                          return Theme(
                                                              data: ThemeData
                                                                      .light()
                                                                  .copyWith(
                                                                primaryColor: Color(
                                                                    0xFF5155C3),
                                                                accentColor: Color(
                                                                    0xFF5155C3),
                                                                colorScheme: ColorScheme.light(
                                                                    onPrimary:
                                                                        ColorPallet
                                                                            .kPrimaryText,
                                                                    primary:
                                                                        ColorPallet
                                                                            .kPrimary),
                                                                buttonTheme: ButtonThemeData(
                                                                    textTheme:
                                                                        ButtonTextTheme
                                                                            .primary),
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
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime.now(),
                                                        lastDate:
                                                            DateTime(
                                                                DateTime.now()
                                                                        .year +
                                                                    1,
                                                                DateTime.now()
                                                                    .month,
                                                                DateTime.now()
                                                                    .day))
                                                    .then((value) {
                                                  setState(() {
                                                    _startDateController
                                                        .text = (value !=
                                                            null)
                                                        ? DateFormat(
                                                                'MM-dd-yyyy')
                                                            .format(value)
                                                        : _startDateController
                                                            .text;
                                                    if (value != null) {
                                                      // reminder.startTime = value!;
                                                      newMedDetails.startDate =
                                                          DateFormat(
                                                                  "yyyy-MM-dd")
                                                              .format(value);
                                                    }
                                                  });
                                                });
                                              },
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == '') {
                                                    return 'Please enter Start Date';
                                                  } else if (DateTime.parse(
                                                          newMedDetails
                                                              .startDate!)
                                                      .isAfter(DateTime.parse(
                                                          newMedDetails
                                                              .endDate!))) {
                                                    return '';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                controller:
                                                    _startDateController,
                                                enabled: false,
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 28 * FCStyle.fem,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                decoration: InputDecoration(
                                                    errorBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.red,
                                                            width: 1)),
                                                    errorStyle: TextStyle(
                                                        color: Colors.red),
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
                                                            color: Color.fromARGB(255, 125, 125, 125),
                                                            width: 1)),
                                                    contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                    // prefixIcon: Icon(Icons.email),
                                                    suffixIcon: Icon(Icons.calendar_today_outlined, color: Colors.black),
                                                    hintText: 'MM-DD-YYYY',
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
                                              'End Date',
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
                                                medicationNameFoucs.unfocus();
                                                prescriberNameFocus.unfocus();
                                                showDatePicker(
                                                        builder:
                                                            (BuildContext
                                                                    context,
                                                                Widget? child) {
                                                          return Theme(
                                                              data: ThemeData
                                                                      .light()
                                                                  .copyWith(
                                                                primaryColor: Color(
                                                                    0xFF5155C3),
                                                                accentColor: Color(
                                                                    0xFF5155C3),
                                                                colorScheme: ColorScheme.light(
                                                                    onPrimary:
                                                                        ColorPallet
                                                                            .kPrimaryText,
                                                                    primary:
                                                                        ColorPallet
                                                                            .kPrimary),
                                                                buttonTheme: ButtonThemeData(
                                                                    textTheme:
                                                                        ButtonTextTheme
                                                                            .primary),
                                                              ),
                                                              child: child ??
                                                                  SizedBox
                                                                      .shrink());
                                                        },
                                                        initialEntryMode:
                                                            DatePickerEntryMode
                                                                .calendarOnly,
                                                        context: context,
                                                        initialDate: DateTime
                                                            .parse(newMedDetails
                                                                .startDate!),
                                                        firstDate: DateTime
                                                            .parse(
                                                                newMedDetails
                                                                    .startDate!),
                                                        lastDate: DateTime(
                                                            DateTime.now()
                                                                    .year +
                                                                1,
                                                            DateTime.now()
                                                                .month,
                                                            DateTime.now().day))
                                                    .then((value) {
                                                  setState(() {
                                                    _endDateController
                                                        .text = (value !=
                                                            null)
                                                        ? DateFormat(
                                                                'MM-dd-yyyy')
                                                            .format(value)
                                                        : _endDateController
                                                            .text;
                                                    if (value != null) {
                                                      // reminder.startTime = value!;
                                                      newMedDetails.endDate =
                                                          DateFormat(
                                                                  "yyyy-MM-dd")
                                                              .format(value);
                                                    }
                                                  });
                                                });
                                              },
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == '') {
                                                    return 'Please enter End Date';
                                                  } else if (DateTime.parse(
                                                          newMedDetails
                                                              .startDate!)
                                                      .isAfter(DateTime.parse(
                                                          newMedDetails
                                                              .endDate!))) {
                                                    return 'End date is smaller than start date';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                controller: _endDateController,
                                                enabled: false,
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 28 * FCStyle.fem,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                decoration: InputDecoration(
                                                    errorBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.red,
                                                            width: 1)),
                                                    errorStyle: TextStyle(
                                                        color: Colors.red),
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
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                    contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                                    suffixIcon: Icon(Icons.calendar_today_outlined, color: Colors.black),
                                                    hintText: 'MM-DD-YYYY',
                                                    hintStyle: TextStyle(color: Color.fromARGB(255, 143, 146, 161), fontSize: 28 * FCStyle.fem, fontWeight: FontWeight.w600)),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ]),
                                  SizedBox(height: 2),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    child: FCMaterialButton(
                                      elevation: 6,
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          // If the form is valid, display a snackbar. In the real world,
                                          // you'd often call a server or save the information in a database.
                                          setState(
                                            () => {isEditing = true},
                                          );
                                        } else {}
                                      },
                                      defaultSize: false,
                                      color: ColorPallet.kPrimary,
                                      child: SizedBox(
                                        width: FCStyle.largeFontSize * 3,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3.0),
                                          child: Center(
                                            child: Text(
                                              'Next',
                                              style: FCStyle.textStyle.copyWith(
                                                color: ColorPallet.kPrimaryText,
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
            )));
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

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
