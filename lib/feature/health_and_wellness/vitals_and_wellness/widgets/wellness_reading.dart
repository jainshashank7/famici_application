import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:livecare/livecare.dart';
import 'package:famici/feature/calander/entities/appointments_entity.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/entity/wellness_entity.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/stringExtention.dart';

import '../../../../utils/barrel.dart';
import '../entity/vital.dart';

class WellnessReading extends StatelessWidget {
  const WellnessReading(
      {Key? key,
      required this.wellness,
      this.forceSingleLine = false,
      this.textStyle,
      this.unitTextStyle})
      : super(key: key);

  final Vital wellness;
  final bool forceSingleLine;
  final TextStyle? textStyle, unitTextStyle;
  Widget singleLineContainer({required List<Widget> children}) {
    if (forceSingleLine) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      );
    }
    return Column(
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (wellness.vitalType == VitalType.activity) {
      return singleLineContainer(
        children: [
          Text(
            wellness.reading.steps,
            softWrap: true,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: textStyle ??
                TextStyle(
                  color: ColorPallet.kPrimaryTextColor,
                  fontSize: FCStyle.largeFontSize,
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (forceSingleLine) SizedBox(width: 8.0),
          Text(
            wellness.measureUnit!.toTitleCase(),
            softWrap: true,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: unitTextStyle != null
                ? unitTextStyle
                : TextStyle(
                    color: ColorPallet.kPrimary,
                    fontFamily: 'roboto',
                    fontSize: 25 * FCStyle.fem,
                    fontWeight: FontWeight.w700,
                  ),
          ),
        ],
      );
    } else if (wellness.vitalType == VitalType.ws) {
      return singleLineContainer(
        children: [
          Text(
            wellness.reading.weight,
            softWrap: true,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: textStyle ??
                TextStyle(
                  color: ColorPallet.kPrimaryTextColor,
                  fontSize: FCStyle.largeFontSize,
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (forceSingleLine) SizedBox(width: 8.0),
          Text(
            wellness.measureUnit!,
            softWrap: true,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: unitTextStyle != null
                ? unitTextStyle
                : TextStyle(
                    color: ColorPallet.kPrimary,
                    fontFamily: 'roboto',
                    fontSize: 25 * FCStyle.fem,
                    fontWeight: FontWeight.w700,
                  ),
          ),
        ],
      );
    } else if (wellness.vitalType == VitalType.sleep) {
      return singleLineContainer(
        children: [
          Text(
            wellness.reading.hr,
            softWrap: true,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: textStyle ??
                TextStyle(
                  color: ColorPallet.kPrimaryTextColor,
                  fontSize: FCStyle.largeFontSize,
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (forceSingleLine) SizedBox(width: 8.0),
          Text(
            wellness.measureUnit!.toTitleCase(),
            softWrap: true,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: unitTextStyle != null
                ? unitTextStyle
                : TextStyle(
                    color: ColorPallet.kPrimary,
                    fontFamily: 'roboto',
                    fontSize: 25 * FCStyle.fem,
                    fontWeight: FontWeight.w700,
                  ),
          ),
        ],
      );
    }

    return Text(
      '',
      softWrap: true,
      textAlign: TextAlign.center,
      maxLines: 2,
      style: TextStyle(
        color: ColorPallet.kPrimaryTextColor,
        fontSize: FCStyle.largeFontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
