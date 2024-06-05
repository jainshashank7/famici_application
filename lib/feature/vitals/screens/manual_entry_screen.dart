import 'package:debug_logger/debug_logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:livecare/livecare.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/core/screens/home_screen/widgets/logout_button.dart';
import 'package:famici/feature/vitals/blocs/manual_reading_add/manual_reading_bloc.dart';
import 'package:famici/feature/vitals/blocs/reading_input_validator/reading_input_validator_cubit.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/fc_back_button.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart' as ThemeBloc;
import '../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../../../utils/helpers/events_track.dart';
import '../../health_and_wellness/vitals_and_wellness/entity/vital.dart';
import '../../health_and_wellness/vitals_and_wellness/widgets/device_type_icon.dart';
import '../../health_and_wellness/vitals_and_wellness/widgets/vital_reading.dart';
import '../../time_picker/time_picker_screen.dart';
import '../blocs/vital_sync_bloc/vital_sync_bloc.dart';
import '../models/reading_input_models.dart';

class ManualEntryScreen extends StatefulWidget {
  const ManualEntryScreen({
    Key? key,
    required this.vital,
  }) : super(key: key);

  final Vital vital;

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  late ManualReadingBloc _readingBloc;
  final ScrollController _readingsController = ScrollController();
  int readingIndex = 1;
  @override
  void initState() {
    _readingBloc = ManualReadingBloc(
      vital: widget.vital,
      vitalSyncBloc: context.read<VitalSyncBloc>(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _readingBloc,
        child: BlocBuilder<ThemeBloc.ThemeBuilderBloc, ThemeBloc.ThemeBuilderState>(
  builder: (context, stateM) {
    return FamiciScaffold(
          toolbarHeight: 108,
          toolbarPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          trailing: LogoutButton(),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add Value Manually',
                style: FCStyle.textStyle.copyWith(
                    fontSize: 45 * FCStyle.fem, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
          child: Container(
              margin: EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 16),
              decoration: BoxDecoration(
                  color: Color.fromARGB(229, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.only(
                // top: 50 * FCStyle.fem,
                left: 50 * FCStyle.fem,
              ),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            VitalTypeDisplayCard(vital: widget.vital),
                            // SizedBox(height: FCStyle.xLargeFontSize),

                            // BlocBuilder<ManualReadingBloc, ManualReadingState>(
                            //   builder: (context, state) {
                            //     return IgnorePointer(
                            //       ignoring: state.readings.length > 4,
                            //       child: FCMaterialButton(
                            //         onPressed: () {
                            //           _readingBloc.add(AddMoreReading());
                            //         },
                            //         child: Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //           children: [
                            //             Icon(
                            //               Icons.add_circle_rounded,
                            //               color: ColorPallet.kPrimaryTextColor,
                            //               size: FCStyle.largeFontSize,
                            //             ),
                            //             SizedBox(width: 8.0),
                            //             Text(
                            //               'Add More Readings',
                            //               style: FCStyle.textStyle,
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // )
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        height: FCStyle.xLargeFontSize * 9,
                        child: NewReadingList(
                          readingBloc: _readingBloc,
                          readingsController: _readingsController,
                          vital: widget.vital,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      bottom: 160,
                      right: 30,
                      child: BlocBuilder<ManualReadingBloc, ManualReadingState>(
                        builder: (context, state) {
                          return Row(
                            children: [
                              state.readings.length > 1
                                  ? IconButton(
                                      icon: Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 30),
                                      onPressed: () {
                                        _readingsController.animateTo(
                                          _readingsController.position.pixels -
                                              200,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.ease,
                                        );
                                      },
                                    )
                                  : SizedBox.shrink(),
                              SizedBox(width: FCStyle.largeFontSize),
                              IgnorePointer(
                                ignoring: state.readings.length > 4,
                                child: FCMaterialButton(
                                  defaultSize: true,
                                  onPressed: () {
                                    var properties = TrackEvents()
                                        .setProperties(
                                            fromDate: '',
                                            toDate: '',
                                            reading: '',
                                            readingDateTime: '',
                                            vital: state.vital.name,
                                            appointmentDate: '',
                                            appointmentTime: '',
                                            appointmentCounselors: '',
                                            appointmentType: '',
                                            callDuration: '',
                                            readingType: '');
                                    TrackEvents().trackEvents(
                                        'Manual Entry - Add more Readings Clicked',
                                        properties);
                                    _readingBloc.add(AddMoreReading());
                                  },
                                  child: Container(
                                    width: 180 * FCStyle.fem,
                                    height: 180 * FCStyle.fem,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_circle_rounded,
                                          color: ColorPallet.kPrimary,
                                          size: 40 * FCStyle.fem,
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          'Add More',
                                          style: FCStyle.textStyle.copyWith(
                                              color: ColorPallet.kPrimary,
                                              fontSize: 22 * FCStyle.fem,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'Readings',
                                          style: FCStyle.textStyle.copyWith(
                                              color: ColorPallet.kPrimary,
                                              fontSize: 22 * FCStyle.fem,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )),
                  Positioned(
                    bottom: 30,
                    right: 20,
                    child: BlocConsumer<ManualReadingBloc, ManualReadingState>(
                      listener: (context, state) {
                        if (state.status == Status.success) {
                          fcRouter.pop();
                        }
                      },
                      builder: (context, state) {
                        if (state.isValid && state.validTime) {
                          return NextButton(
                            hasIcon: false,
                            color: ColorPallet.kPrimary,
                            label: CommonStrings.done.tr(),
                            size: Size(50, 30),
                            onPressed: () {
                              var properties = TrackEvents().setProperties(
                                  fromDate: '',
                                  toDate: '',
                                  reading: '',
                                  readingDateTime: '',
                                  vital: state.vital.name,
                                  appointmentDate: '',
                                  appointmentTime: '',
                                  appointmentCounselors: '',
                                  appointmentType: '',
                                  callDuration: '',
                                  readingType: '');
                              TrackEvents().trackEvents(
                                  'Manual Entry - Done', properties);

                              _readingBloc.add(SaveNewManualReadings());
                            },
                          );
                        }
                        return NextButton(
                          color: ColorPallet.kPrimary.withOpacity(0.4),
                          hasIcon: false,
                          size: Size(50, 30),
                          label: 'Save',
                          onPressed: () {
                            var properties = TrackEvents().setProperties(
                                fromDate: '',
                                toDate: '',
                                reading: '',
                                readingDateTime: '',
                                vital: state.vital.name,
                                appointmentDate: '',
                                appointmentTime: '',
                                appointmentCounselors: '',
                                appointmentType: '',
                                callDuration: '',
                                readingType: '');
                            TrackEvents()
                                .trackEvents('Manual Entry - Save', properties);
                          },
                        );
                      },
                    ),
                  )
                ],
              )),
        );
  },
));
  }
}

class NewReadingList extends StatelessWidget {
  const NewReadingList({
    Key? key,
    required ManualReadingBloc readingBloc,
    required ScrollController readingsController,
    required Vital vital,
  })  : _readingBloc = readingBloc,
        _readingsController = readingsController,
        _vital = vital,
        super(key: key);

  final ManualReadingBloc _readingBloc;
  final ScrollController _readingsController;
  final Vital _vital;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<ManualReadingBloc, ManualReadingState>(
          bloc: _readingBloc,
          builder: (context, state) {
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              _readingsController.animateTo(
                _readingsController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            });

            return Container(
              width: _vital.vitalType == VitalType.bp ? 360 : 410,

              // height: FCStyle.xLargeFontSize * 5,
              constraints: state.readings.length > 1
                  ? BoxConstraints(
                      maxWidth: 410,
                    )
                  : null,

              // child:
              // ShaderMask(
              //   shaderCallback: (Rect bounds) {
              //     return LinearGradient(
              //       begin: Alignment.centerRight,
              //       end: Alignment.center,
              //       colors: <Color>[Color.fromRGBO(0, 0, 0, 0), Colors.white],
              //     ).createShader(bounds);
              //   },
              //   blendMode: BlendMode.dstIn,
              child: ListView.builder(
                shrinkWrap: true,
                controller: _readingsController,
                itemCount: state.readings.length,
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: FCStyle.xLargeFontSize * 3,
                ),
                scrollDirection: Axis.horizontal,
                reverse: true,
                itemBuilder: (context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: NewVitalReading(
                      vital: _vital,
                      index: index,
                      isDismissible: state.readings.length > 1,
                      onDismissed: () {
                        _readingBloc.add(
                          RemoveNewManualReading(index),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class NewVitalReading extends StatelessWidget {
  const NewVitalReading({
    Key? key,
    required this.vital,
    required this.index,
    this.isDismissible = false,
    this.onDismissed,
  }) : super(key: key);

  final Vital vital;
  final int index;
  final bool isDismissible;
  final VoidCallback? onDismissed;

  Widget dismissibleWrapper({required Widget child}) {
    return Container(
      width: vital.vitalType == VitalType.bp
          ? 440 * FCStyle.fem
          : 275 * FCStyle.fem,
      decoration: BoxDecoration(
          color: ColorPallet.kPrimary, borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.symmetric(
          horizontal: 26 * FCStyle.fem, vertical: 0 * FCStyle.fem),
      child: isDismissible
          ? Dismissible(
              direction: DismissDirection.up,
              onDismissed: (direction) {
                if (direction == DismissDirection.up) {
                  onDismissed?.call();
                }
              },
              key: Key(
                '${index}_${DateTime.now().toString()}',
              ),
              child: child,
            )
          : child,
    );
  }

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
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
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      builder: (BuildContext context, Widget? child) {
        return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: ColorPallet.kPrimary,
              accentColor: ColorPallet.kPrimary,
              colorScheme: ColorScheme.light(
                  primary: ColorPallet.kPrimary,
                  onPrimary: ColorPallet.kPrimaryText),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child ?? SizedBox.shrink());
      },
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }

  @override
  Widget build(BuildContext context) {
    return dismissibleWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.watch_later_outlined,
            color: Color.fromARGB(56, 255, 255, 255),
            size: 50 * FCStyle.fem,
          ),
          SizedBox(height: 12.0 * FCStyle.fem),
          Text(
            'Date and Time',
            style: TextStyle(
                fontSize: 28 * FCStyle.fem, color: ColorPallet.kPrimaryText),
          ),
          SizedBox(height: 12.0 * FCStyle.fem),
          BlocBuilder<ManualReadingBloc, ManualReadingState>(
            builder: (context, state) {
              String time = DateFormat('d MMM, h:mma')
                  .format(DateTime.fromMicrosecondsSinceEpoch(
                      state.readings[index].readAt * 1000))
                  .replaceAll('am', 'AM')
                  .replaceAll('pm', 'PM');

              return InkWell(
                // isBorder: true,
                // color: Colors.transparent,
                // borderColor: Color.fromARGB(118, 255, 255, 255),
                // borderRadius: BorderRadius.circular(9),
                // defaultSize: true,
                onTap: () {
                  // DatePicker.showDateTimePicker(
                  //   context,
                  //   showTitleActions: true,
                  //   onChanged: (date) {
                  //     DebugLogger.info('change $date');
                  //   },
                  //   onConfirm: (date) {
                  //     context
                  //         .read<ManualReadingBloc>()
                  //         .add(ManualReadingTimeUpdated(
                  //           date,
                  //           index,
                  //         ));
                  //   },
                  //   maxTime: DateTime.now(),
                  // );
                  showDateTimePicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year),
                          lastDate: DateTime.now(),
                          initialDate: DateTime.fromMicrosecondsSinceEpoch(
                              state.readings[index].readAt * 1000))
                      .then((value) {
                    if (value != null)
                      context
                          .read<ManualReadingBloc>()
                          .add(ManualReadingTimeUpdated(
                            value!,
                            index,
                          ));
                  });
                },
                // showDialog(

                //   context: context,
                //   builder: (context) {
                //     return TimePickerScreen();
                //   },
                // ).then((value) {
                //   print('isha hi ' + value);
                //   if (value != null) {
                //     context
                //         .read<ManualReadingBloc>()
                //         .add(ManualReadingTimeUpdated(
                //           value,
                //           index,
                //         ));
                //   }
                // });

                child: Container(
                  height: 60 * FCStyle.fem,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(15, 255, 255, 255),
                      border: Border.all(
                          color: Color.fromARGB(114, 255, 255, 255), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  // width: 194 * FCStyle.fem,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                  child: Text(
                    time,
                    style: FCStyle.textStyle.copyWith(
                        fontSize: 27 * FCStyle.fem,
                        fontWeight: FontWeight.w700,
                        color: ColorPallet.kPrimaryText),
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: 40,
            child: BlocBuilder<ManualReadingBloc, ManualReadingState>(
                builder: (context, state) {
              if (state.invalidTimeIndex == index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Future Times are Not Allowed',
                    style: FCStyle.textStyle.copyWith(
                      fontSize: FCStyle.defaultFontSize,
                      color: ColorPallet.kRed,
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            }),
          ),
          DeviceTypeIcon(
            type: vital.vitalType,
            color: Color.fromARGB(56, 255, 255, 255),
            size: 35 * FCStyle.fem,
          ),
          SizedBox(height: 12.0 * FCStyle.fem),
          Text(
            'Reading Value',
            style: TextStyle(
                fontSize: 28 * FCStyle.fem, color: ColorPallet.kPrimaryText),
          ),
          SizedBox(height: 12.0 * FCStyle.fem),
          InputReadingInformationByType(index: index, vital: vital),
        ],
      ),
    );
  }
}

class InputReadingInformationByType extends StatelessWidget {
  const InputReadingInformationByType({
    Key? key,
    required this.index,
    required this.vital,
  }) : super(key: key);

  final int index;
  final Vital vital;

  @override
  Widget build(BuildContext context) {
    if (vital.vitalType == VitalType.heartRate) {
      return Column(
        children: [
          SizedBox(
            child: BlocBuilder<ManualReadingBloc, ManualReadingState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    // FCTextFormField(

                    //   key: Key('${index}_${DateTime.now().toString()}'),
                    //   hintText: 'ex: 94',
                    //   hintFontSize: FCStyle.defaultFontSize,
                    //   maxLines: 1,
                    //   initialValue: state.readings[index].pulse,
                    //   contentPadding: EdgeInsets.symmetric(
                    //     horizontal: 8,
                    //     vertical:8,
                    //   ),
                    // ),

                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return VitalReadingInput(
                              title: vital.name,
                              unit: vital.measureUnit,
                              min: 40,
                              max: 200,
                            );
                          },
                        ).then((value) {
                          context
                              .read<ManualReadingBloc>()
                              .add(ManualReadingInputAdded(
                                state.readings[index].copyWith(pulse: value),
                                index,
                              ));
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(15, 255, 255, 255),
                            border: Border.all(
                                color: Color.fromARGB(114, 255, 255, 255),
                                width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        // width: 194 * FCStyle.fem,
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.readings[index].pulse,
                              key: Key('${index}_${DateTime.now().toString()}'),
                              style: FCStyle.textStyle.copyWith(
                                  fontSize: 32 * FCStyle.fem,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPallet.kPrimaryText),
                            ),
                            Text(
                              ' ${vital.measureUnit}',
                              style: FCStyle.textStyle.copyWith(
                                  fontSize: 32 * FCStyle.fem,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPallet.kPrimaryText),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          // Text(
          //   '${vital.measureUnit}',
          //   style: FCStyle.textStyle.copyWith(
          //     fontSize: FCStyle.defaultFontSize,
          //   ),
          // )
        ],
      );
    }
    if (vital.vitalType == VitalType.bp) {
      return
          //  Container(
          //                 decoration: BoxDecoration(
          //                     color: Color.fromARGB(15, 255, 255, 255),
          //                     border: Border.all(
          //                         color: Color.fromARGB(114, 255, 255, 255),
          //                         width: 1),
          //                     borderRadius: BorderRadius.circular(10)),
          //                 alignment: Alignment.center,
          //                 width: 194 * FCStyle.fem,
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     Text(
          //                       state.readings[index].pulse,
          //                       key: Key('${index}_${DateTime.now().toString()}'),
          //                       style: FCStyle.textStyle.copyWith(
          //                           fontSize: 32 * FCStyle.fem,
          //                           fontWeight: FontWeight.w700,
          //                           color: Colors.white),
          //                     ),
          //                     Text(
          //                       ' ${vital.measureUnit}',
          //                       style: FCStyle.textStyle.copyWith(
          //                           fontSize: 32 * FCStyle.fem,
          //                           fontWeight: FontWeight.w700,
          //                           color: Colors.white),
          //                     ),
          //                   ],
          //                 ),
          //               ),

          Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: BlocBuilder<ManualReadingBloc, ManualReadingState>(
                      builder: (context, state) {
                        return Text(
                          'Systolic',
                          style: FCStyle.textStyle.copyWith(
                              fontSize: FCStyle.defaultFontSize,
                              color: ColorPallet.kPrimaryText),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: FCStyle.xLargeFontSize + 25),
                  SizedBox(
                    width: FCStyle.largeFontSize * 2,
                    child: BlocBuilder<ManualReadingBloc, ManualReadingState>(
                      builder: (context, state) {
                        return Text(
                          'Diastolic',
                          style: FCStyle.textStyle.copyWith(
                              fontSize: FCStyle.defaultFontSize,
                              color: ColorPallet.kPrimaryText),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: FCStyle.largeFontSize * 2),
                ],
              ),
              SizedBox(height: 4.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    child: BlocBuilder<ManualReadingBloc, ManualReadingState>(
                      builder: (context, state) {
                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return VitalReadingInput(
                                      title: vital.name,
                                      unit: 'Systolic',
                                      min: 50,
                                      max: 190,
                                    );
                                  },
                                ).then((value) {
                                  context
                                      .read<ManualReadingBloc>()
                                      .add(ManualReadingInputAdded(
                                        state.readings[index]
                                            .copyWith(sys: value),
                                        index,
                                      ));
                                });
                              },
                              child: Container(
                                key: Key(
                                    '${index}_${DateTime.now().toString()}'),
                                padding: EdgeInsets.symmetric(
                                  horizontal: FCStyle.defaultFontSize,
                                  vertical: FCStyle.smallFontSize,
                                ),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(15, 255, 255, 255),
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(114, 255, 255, 255),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                alignment: Alignment.center,
                                width: 120 * FCStyle.fem,
                                child: Text(
                                  state.readings[index].sys,
                                  style: FCStyle.textStyle.copyWith(
                                      fontSize: 32 * FCStyle.fem,
                                      fontWeight: FontWeight.w700,
                                      color: ColorPallet.kPrimaryText),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: FCStyle.xLargeFontSize,
                    child: Text(
                      '/',
                      textAlign: TextAlign.center,
                      style: FCStyle.textStyle.copyWith(
                          fontSize: FCStyle.xLargeFontSize,
                          color: ColorPallet.kPrimaryText),
                    ),
                  ),
                  SizedBox(
                    width: FCStyle.largeFontSize * 3,
                    child: BlocBuilder<ManualReadingBloc, ManualReadingState>(
                      builder: (context, state) {
                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return VitalReadingInput(
                                      title: vital.name,
                                      unit: 'Diastolic',
                                      min: 35,
                                      max: 100,
                                    );
                                  },
                                ).then((value) {
                                  context
                                      .read<ManualReadingBloc>()
                                      .add(ManualReadingInputAdded(
                                        state.readings[index]
                                            .copyWith(dia: value),
                                        index,
                                      ));
                                });
                              },
                              child: Container(
                                key: Key(
                                    '${index}_1_${DateTime.now().toString()}'),
                                padding: EdgeInsets.symmetric(
                                  horizontal: FCStyle.defaultFontSize,
                                  vertical: FCStyle.smallFontSize,
                                ),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(15, 255, 255, 255),
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(114, 255, 255, 255),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                alignment: Alignment.center,
                                width: 120 * FCStyle.fem,
                                child: Text(
                                  state.readings[index].dia,
                                  style: FCStyle.textStyle.copyWith(
                                      fontSize: 32 * FCStyle.fem,
                                      fontWeight: FontWeight.w700,
                                      color: ColorPallet.kPrimaryText),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      vital.measureUnit!,
                      textAlign: TextAlign.center,
                      style: FCStyle.textStyle.copyWith(
                          fontSize: 25 * FCStyle.fem,
                          fontWeight: FontWeight.w700,
                          color: ColorPallet.kPrimaryText),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }
    if (vital.vitalType == VitalType.gl) {
      return Column(
        children: [
          SizedBox(
            child: BlocBuilder<ManualReadingBloc, ManualReadingState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    // FCTextFormField(
                    //   key: Key('${index}_${DateTime.now().toString()}'),
                    //   hintText: 'ex: 94',
                    //   maxLines: 1,
                    //   initialValue: state.readings[index].bgValue,
                    //   contentPadding: EdgeInsets.symmetric(
                    //     horizontal: FCStyle.defaultFontSize,
                    //     vertical: FCStyle.smallFontSize,
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return VitalReadingInput(
                              title: vital.name,
                              unit: vital.measureUnit,
                              min: 30,
                              max: 600,
                            );
                          },
                        ).then((value) {
                          context
                              .read<ManualReadingBloc>()
                              .add(ManualReadingInputAdded(
                                state.readings[index].copyWith(bgValue: value),
                                index,
                              ));
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        key: Key('${index}_${DateTime.now().toString()}'),
                        padding: EdgeInsets.symmetric(
                          horizontal: FCStyle.defaultFontSize,
                          vertical: FCStyle.smallFontSize,
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(15, 255, 255, 255),
                            border: Border.all(
                                color: Color.fromARGB(114, 255, 255, 255),
                                width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.readings[index].bgValue,
                              style: FCStyle.textStyle.copyWith(
                                  fontSize: 27 * FCStyle.fem,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPallet.kPrimaryText),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${vital.measureUnit}',
                              style: FCStyle.textStyle.copyWith(
                                  fontSize: 27 * FCStyle.fem,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPallet.kPrimaryText),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      );
    }
    if (vital.vitalType == VitalType.ws) {
      return Column(
        children: [
          SizedBox(
            child: BlocBuilder<ManualReadingBloc, ManualReadingState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return VitalReadingInput(
                              title: vital.name,
                              unit: vital.measureUnit,
                              min: 0,
                              max: 1000,
                              allowDecimal: true,
                            );
                          },
                        ).then((value) {
                          context
                              .read<ManualReadingBloc>()
                              .add(ManualReadingInputAdded(
                                state.readings[index].copyWith(weight: value),
                                index,
                              ));
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        key: Key('${index}_${DateTime.now().toString()}'),
                        padding: EdgeInsets.symmetric(
                          horizontal: FCStyle.defaultFontSize,
                          vertical: FCStyle.smallFontSize,
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(15, 255, 255, 255),
                            border: Border.all(
                                color: Color.fromARGB(114, 255, 255, 255),
                                width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.readings[index].weight,
                              style: FCStyle.textStyle.copyWith(
                                  fontSize: 27 * FCStyle.fem,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPallet.kPrimaryText),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${vital.measureUnit}',
                              style: FCStyle.textStyle.copyWith(
                                  fontSize: 27 * FCStyle.fem,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPallet.kPrimaryText),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      );
    }
    if (vital.vitalType == VitalType.spo2) {
      return Column(
        children: [
          SizedBox(
            child: BlocBuilder<ManualReadingBloc, ManualReadingState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return VitalReadingInput(
                              title: vital.name,
                              unit: vital.measureUnit,
                              min: 70,
                              max: 100,
                            );
                          },
                        ).then((value) {
                          context
                              .read<ManualReadingBloc>()
                              .add(ManualReadingInputAdded(
                                state.readings[index].copyWith(oxygen: value),
                                index,
                              ));
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        key: Key('${index}_${DateTime.now().toString()}'),
                        padding: EdgeInsets.symmetric(
                          horizontal: FCStyle.defaultFontSize,
                          vertical: FCStyle.smallFontSize,
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(15, 255, 255, 255),
                            border: Border.all(
                                color: Color.fromARGB(114, 255, 255, 255),
                                width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.readings[index].oxygen,
                              style: FCStyle.textStyle.copyWith(
                                  fontSize: 27 * FCStyle.fem,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPallet.kPrimaryText),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${vital.measureUnit}',
                              style: FCStyle.textStyle.copyWith(
                                  fontSize: 27 * FCStyle.fem,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPallet.kPrimaryText),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      );
    }
    if (vital.vitalType == VitalType.temp) {
      return Column(
        children: [
          SizedBox(
            child: BlocBuilder<ManualReadingBloc, ManualReadingState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return VitalReadingInput(
                              title: vital.name,
                              unit: vital.measureUnit,
                              allowDecimal: true,
                              allowSigned: true,
                              min: 70,
                              max: 120,
                            );
                          },
                        ).then((value) {
                          context.read<ManualReadingBloc>().add(
                                ManualReadingInputAdded(
                                  state.readings[index]
                                      .copyWith(temperature: value),
                                  index,
                                ),
                              );
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        key: Key('${index}_${DateTime.now().toString()}'),
                        padding: EdgeInsets.symmetric(
                          horizontal: FCStyle.defaultFontSize,
                          vertical: FCStyle.smallFontSize,
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(15, 255, 255, 255),
                            border: Border.all(
                                color: Color.fromARGB(114, 255, 255, 255),
                                width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.readings[index].temperature,
                              style: FCStyle.textStyle.copyWith(
                                  fontSize: 27 * FCStyle.fem,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPallet.kPrimaryText),
                            ),
                            SizedBox(width: 5),
                            Text(
                              '${vital.measureUnit}',
                              style: FCStyle.textStyle.copyWith(
                                  fontSize: 27 * FCStyle.fem,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPallet.kPrimaryText),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      );
    }

    if (vital.vitalType == VitalType.activity) {
      return Column(
        children: [
          SizedBox(
            child: BlocBuilder<ManualReadingBloc, ManualReadingState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return VitalReadingInput(
                              title: vital.name,
                              unit: vital.measureUnit,
                              allowDecimal: true,
                              allowSigned: true,
                              min: 0,
                              max: 10000,
                            );
                          },
                        ).then(
                          (value) {
                            context.read<ManualReadingBloc>().add(
                                  ManualReadingInputAdded(
                                    state.readings[index]
                                        .copyWith(steps: value),
                                    index,
                                  ),
                                );
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        key: Key('${index}_${DateTime.now().toString()}'),
                        padding: EdgeInsets.symmetric(
                          horizontal: FCStyle.defaultFontSize,
                          vertical: FCStyle.smallFontSize,
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(15, 255, 255, 255),
                            border: Border.all(
                                color: Color.fromARGB(114, 255, 255, 255),
                                width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.readings[index].steps,
                              style: FCStyle.textStyle.copyWith(
                                  fontSize: 27 * FCStyle.fem,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPallet.kPrimaryText),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${vital.measureUnit}',
                              style: FCStyle.textStyle.copyWith(
                                  fontSize: 27 * FCStyle.fem,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPallet.kPrimaryText),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      );
    }
    if (vital.vitalType == VitalType.sleep) {
      return Column(
        children: [
          SizedBox(
            child: BlocBuilder<ManualReadingBloc, ManualReadingState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return VitalReadingInput(
                              title: vital.name,
                              unit: vital.measureUnit,
                              allowDecimal: true,
                              allowSigned: true,
                              min: 0,
                              max: 24,
                            );
                          },
                        ).then((value) {
                          context.read<ManualReadingBloc>().add(
                                ManualReadingInputAdded(
                                  state.readings[index].copyWith(hr: value),
                                  index,
                                ),
                              );
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        key: Key('${index}_${DateTime.now().toString()}'),
                        padding: EdgeInsets.symmetric(
                          horizontal: FCStyle.defaultFontSize,
                          vertical: FCStyle.smallFontSize,
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(15, 255, 255, 255),
                            border: Border.all(
                                color: Color.fromARGB(114, 255, 255, 255),
                                width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.readings[index].hr,
                              style: FCStyle.textStyle.copyWith(
                                  fontSize: 27 * FCStyle.fem,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPallet.kPrimaryText),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${vital.measureUnit}',
                              style: FCStyle.textStyle.copyWith(
                                  fontSize: 27 * FCStyle.fem,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPallet.kPrimaryText),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      );
    }
    return SizedBox.shrink();
  }
}

class VitalReadingInput extends StatefulWidget {
  const VitalReadingInput({
    Key? key,
    this.title = '',
    this.unit = '',
    this.min,
    this.max,
    this.allowDecimal = false,
    this.allowSigned = false,
  }) : super(key: key);

  final String? title;
  final String? unit;
  final double? min;
  final double? max;
  final bool allowDecimal;
  final bool allowSigned;

  @override
  State<VitalReadingInput> createState() => _VitalReadingInputState();
}

class _VitalReadingInputState extends State<VitalReadingInput> {
  final ReadingInputValidatorCubit validatorCubit =
      ReadingInputValidatorCubit();

  final FocusNode _node = FocusNode();

  @override
  void dispose() {
    validatorCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32.0,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: FCStyle.xLargeFontSize * 3,
                child: BlocBuilder(
                  bloc: validatorCubit,
                  builder: (context, ReadingInputValidatorState state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: FCStyle.xLargeFontSize * 6,
                          child: FCTextFormField(
                            focusNode: _node,
                            autoFocus: true,
                            hasError: state.value.invalid,
                            error: state.value.error?.message,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: FCStyle.defaultFontSize,
                              vertical: FCStyle.defaultFontSize,
                            ),
                            onChanged: (value) {
                              validatorCubit.validate(
                                value: value,
                                min: widget.min,
                                max: widget.max,
                              );
                            },
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: widget.allowDecimal,
                              signed: widget.allowSigned,
                            ),
                            textInputFormatters: widget.allowDecimal
                                ? [
                                    DecimalTextInputFormatter(
                                      decimalRange: 2,
                                      activatedNegativeValues:
                                          widget.allowSigned,
                                    )
                                  ]
                                : [FilteringTextInputFormatter.digitsOnly],
                            onSubmit: state.value.valid
                                ? (bpm) {
                                    if (bpm.isNotEmpty) {
                                      Navigator.pop(context, bpm);
                                    } else {
                                      _node.requestFocus();
                                    }
                                  }
                                : (val) {
                                    _node.requestFocus();
                                  },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            top: FCStyle.defaultFontSize,
                          ),
                          child: Text(
                            widget.unit!,
                            style: FCStyle.textStyle.copyWith(
                              color: ColorPallet.kPrimaryText,
                              fontSize: FCStyle.mediumFontSize,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                height: 108.0,
                child: Row(
                  children: [
                    FCBackButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 108.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title!,
                      style: FCStyle.textStyle.copyWith(
                        fontSize: FCStyle.largeFontSize,
                        color: ColorPallet.kPrimaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VitalTypeDisplayCard extends StatelessWidget {
  const VitalTypeDisplayCard({Key? key, required this.vital}) : super(key: key);

  final Vital vital;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      key: ValueKey('vitalItemButton+${vital.vitalId}'),
      style: FCStyle.buttonCardStyleWithBorderRadius(
          borderRadius: FCStyle.mediumFontSize, color: Colors.transparent),
      minDistance: 3,
      onPressed: () {},
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                vital.name!,
                maxLines: 2,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorPallet.kPrimary,
                  fontSize: 45 * FCStyle.fem,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30 * FCStyle.fem),
              child: DeviceTypeIcon(
                  type: vital.vitalType,
                  size: 140 * FCStyle.fem,
                  color: ColorPallet.kPrimary),
            ),
            SizedBox(
              height: 35 * FCStyle.fem,
            ),
            VitalViewTimeAgoWithError(
              vital: vital,
            ),
            SizedBox(
              height: 30 * FCStyle.fem,
            ),
            VitalReading(
              vital: vital,
              unitTextStyle: TextStyle(
                color: ColorPallet.kPrimary,
                fontFamily: 'roboto',
                fontSize: 30 * FCStyle.fem,
                fontWeight: FontWeight.w700,
              ),
              forceSingleLine: true,
              textStyle: TextStyle(
                  color: ColorPallet.kPrimary,
                  fontFamily: 'roboto',
                  fontSize: 30 * FCStyle.fem,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 8,
            ),
            // VitalViewTimeAgoWithError(
            //   vital: _vital,
            // ),
          ],
        ),
      ),
    );
  }
}

class VitalViewTimeAgoWithError extends StatelessWidget {
  const VitalViewTimeAgoWithError({
    Key? key,
    required this.vital,
  }) : super(key: key);

  final Vital vital;

  int get timeDifferance {
    int dif = DateTime.now().millisecondsSinceEpoch - vital.time!;
    return Duration(milliseconds: dif).inMinutes;
  }

  bool get isConnected => vital.connected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: FCStyle.largeFontSize * 4,
      // width: FCStyle.xLargeFontSize * 6,
      child: Builder(builder: (context) {
        // if (isConnected || timeDifferance < 1) {
        //   return Column(
        //     children: [
        //       vital.count > 0
        //           ? Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   'Measured ',
        //                   style: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                   ),
        //                 ),
        //                 TimeAgoText(
        //                   startTime: vital.reading.readAt,
        //                   textStyle: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                   ),
        //                 ),
        //               ],
        //             )
        //           : Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   'Not Measured',
        //                   style: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //     ],
        //   );
        // } else if (1 < timeDifferance && timeDifferance < 3) {
        //   return Column(
        //     children: [
        //       vital.count > 0
        //           ? Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   'Measured ',
        //                   style: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                   ),
        //                 ),
        //                 TimeAgoText(
        //                   startTime: vital.reading.readAt,
        //                   textStyle: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                   ),
        //                 ),
        //               ],
        //             )
        //           : Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   'Not Measured',
        //                   style: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //     ],
        //   );
        // } else if (timeDifferance > 3) {
        //   return Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       vital.count > 0
        //           ? Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   'Measured ',
        //                   style: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                     color: ColorPallet.kPrimaryTextColor,
        //                   ),
        //                 ),
        //                 TimeAgoText(
        //                   startTime: vital.reading.readAt,
        //                   textStyle: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                     color: ColorPallet.kPrimaryTextColor,
        //                   ),
        //                 ),
        //               ],
        //             )
        //           : Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   'Not Measured',
        //                   style: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //       //   SizedBox(height: 16.0),
        //       //   Text(
        //       //     vital.vitalType == VitalType.fallDetection
        //       //         ? 'Please Connect a Device'
        //       //         : 'Please Connect a Device to Measure or Manually Enter a Value',
        //       //     textAlign: TextAlign.center,
        //       //     style: FCStyle.textStyle.copyWith(
        //       //       color: ColorPallet.kDarkRed,
        //       //       fontSize: 26 * FCStyle.fem,
        //       //     ),
        //       //   )
        //     ],
        //   );
        // }
        return Container(
          child: vital.count > 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      Text(
                        'Last Reading ',
                        style: TextStyle(
                          fontSize: 25 * FCStyle.fem,
                        ),
                      ),
                      TimeAgoText(
                        startTime: vital.reading.readAt,
                        multiLine: true,
                        textStyle: TextStyle(
                          fontSize: 25 * FCStyle.fem,
                        ),
                      )
                    ])
              : Text(
                  "Not Measured",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25 * FCStyle.fem,
                  ),
                ),
        );
      }),
    );
  }
}
