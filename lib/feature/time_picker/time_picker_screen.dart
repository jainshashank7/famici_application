import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/feature/time_picker/time_picker_cubit/time_picker_cubit.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';

import '../../utils/strings/medication_strings.dart';

class TimePickerScreen extends StatefulWidget {
  const TimePickerScreen({Key? key}) : super(key: key);

  @override
  State<TimePickerScreen> createState() => _TimePickerScreenState();
}

class _TimePickerScreenState extends State<TimePickerScreen> {
  final TimePickerCubit _timePicker = TimePickerCubit();

  // final ValueChanged<TimeOfDay> onChange;
  void onDone() {

    Navigator.pop(
      context,
      DateFormat("HH:mmA").parse(
        "${_timePicker.state.hour}:${_timePicker.state.minute}${_timePicker.state.period.name.toUpperCase()}",
      ),
    );
  }

  @override
  void dispose() {
    _timePicker.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: CloseIconButton(
              color: ColorPallet.kWhite,
              size: FCStyle.xLargeFontSize * 2,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PhysicalModel(
                  elevation: 2,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    FCStyle.smallFontSize,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(FCStyle.defaultFontSize),
                    decoration: BoxDecoration(
                      color: ColorPallet.kWhite,
                      borderRadius: BorderRadius.circular(
                        FCStyle.smallFontSize,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          ColorPallet.kBackGroundGradientColor1,
                          ColorPallet.kBackGroundGradientColor2
                        ],
                      ),
                    ),
                    child: Text(
                      'Select Time',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorPallet.kInverseBackground,
                        fontWeight: FontWeight.w400,
                        fontSize: FCStyle.mediumFontSize,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(FCStyle.largeFontSize),
                  child: PhysicalModel(
                    elevation: 2,
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      FCStyle.mediumFontSize,
                    ),
                    child: Container(
                      height: FCStyle.xLargeFontSize * 7,
                      width: FCStyle.xLargeFontSize * 8,
                      padding: EdgeInsets.all(FCStyle.largeFontSize),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(FCStyle.mediumFontSize),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            ColorPallet.kBackGroundGradientColor1,
                            ColorPallet.kBackGroundGradientColor2
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TimePickerIconButton(
                                    onPressed: () {
                                      _timePicker.incrementHour();
                                    },
                                  ),
                                  BlocBuilder<TimePickerCubit, TimePickerState>(
                                    bloc: _timePicker,
                                    buildWhen: (curr, prv) =>
                                        curr.hour != prv.hour,
                                    builder: (context, state) {
                                      return context.timeIndicator(
                                        state.hour.toString(),
                                      );
                                    },
                                  ),
                                  TimePickerIconButton(
                                    icon: Icons.remove_rounded,
                                    onPressed: () {
                                      _timePicker.decrementHour();
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TimePickerIconButton(
                                    onPressed: () {
                                      _timePicker.incrementMinute();
                                    },
                                  ),
                                  BlocBuilder<TimePickerCubit, TimePickerState>(
                                    bloc: _timePicker,
                                    buildWhen: (curr, prv) =>
                                        curr.minute != prv.minute,
                                    builder: (context, state) {
                                      return context.timeIndicator(
                                        state.minute > 9
                                            ? state.minute.toString()
                                            : '0${state.minute}',
                                      );
                                    },
                                  ),
                                  TimePickerIconButton(
                                    icon: Icons.remove_rounded,
                                    onPressed: () {
                                      _timePicker.decrementMinute();
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TimePickerIconButton(
                                    onPressed: () {
                                      _timePicker.togglePeriod();
                                    },
                                  ),
                                  BlocBuilder<TimePickerCubit, TimePickerState>(
                                    bloc: _timePicker,
                                    buildWhen: (curr, prv) =>
                                        curr.period != prv.period,
                                    builder: (context, state) {
                                      return context.timeIndicator(
                                        state.period.name.toUpperCase(),
                                      );
                                    },
                                  ),
                                  TimePickerIconButton(
                                    icon: Icons.remove_rounded,
                                    onPressed: () {
                                      _timePicker.togglePeriod();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: (FCStyle.xLargeFontSize * 2) - 2,
                                  bottom: 6,
                                ),
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    color: ColorPallet.kGrey.withOpacity(0.8),
                                    fontWeight: FontWeight.w400,
                                    fontSize: FCStyle.largeFontSize,
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                FCMaterialButton(
                  color: ColorPallet.kGreen,
                  onPressed: () async {
                    onDone();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 20.0,
                    ),
                    child: Text(
                      'Add',
                      style: FCStyle.textStyle.copyWith(
                        color: ColorPallet.kWhite,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

extension TimePickerExt on BuildContext {
  Widget timeIndicator(String time) {
    return Container(
      height: (FCStyle.defaultFontSize * 4) + 8,
      width: (FCStyle.defaultFontSize * 4) + 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(FCStyle.defaultFontSize),
        color: Color(0xFFE7EBF0),
        border: Border.all(color: Color(0xFF7D7D7D), width: 5),
      ),
      child: Center(
        child: Text(
          time.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorPallet.kGrey.withOpacity(0.8),
            fontWeight: FontWeight.w400,
            fontSize: FCStyle.largeFontSize,
          ),
        ),
      ),
    );
  }
}

class TimePickerIconButton extends StatelessWidget {
  const TimePickerIconButton({
    Key? key,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      minDistance: 3,
      style: FCStyle.buttonCardStyle.copyWith(
        boxShape: NeumorphicBoxShape.circle(),
      ),
      padding: EdgeInsets.all(6.0),
      margin: EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorPallet.kGreen,
        ),
        child: Icon(
          icon ?? Icons.add_rounded,
          size: FCStyle.xLargeFontSize + 16,
          color: ColorPallet.kWhite,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
