import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:livecare/livecare.dart';

import '../../../../utils/barrel.dart';
import '../entity/vital.dart';

class VitalReading extends StatelessWidget {
  const VitalReading(
      {Key? key,
      required this.vital,
      this.forceSingleLine = false,
      this.textStyle,
      this.unitTextStyle})
      : super(key: key);

  final Vital vital;
  final bool forceSingleLine;
  final TextStyle? textStyle;
  final TextStyle? unitTextStyle;
  @override
  Widget build(BuildContext context) {
    if (vital.vitalType == VitalType.bp) {
      if (forceSingleLine) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${vital.reading.sys}/${vital.reading.dia} ',
              softWrap: true,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: textStyle ??
                  TextStyle(
                    color: ColorPallet.kPrimaryTextColor,
                    fontSize: FCStyle.smallFontSize,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              width: 7,
            ),
            Text(
              '${vital.measureUnit!}',
              softWrap: true,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: unitTextStyle != null
                  ? unitTextStyle
                  : TextStyle(
                      color: Color(0xFF4D54BB),
                      fontFamily: 'roboto',
                      fontSize: 25 * FCStyle.fem,
                      fontWeight: FontWeight.w700,
                    ),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            vital.reading.sys,
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
          Container(
            color: ColorPallet.kPrimaryTextColor,
            height: 2.0,
            width: FCStyle.defaultFontSize * 3,
          ),
          Text(
            vital.reading.dia,
            softWrap: true,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              color: ColorPallet.kPrimaryTextColor,
              fontSize: FCStyle.smallFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else if (vital.vitalType == VitalType.spo2) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${vital.reading.oxygen}${vital.measureUnit!}',
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
          // SizedBox(
          //   width: 7,
          // ),
          // Text(
          //   '${vital.measureUnit!}',
          //   softWrap: true,
          //   textAlign: TextAlign.center,
          //   maxLines: 2,
          //   style: TextStyle(
          //     color: Color(0xFF4D54BB),
          //     fontFamily: 'roboto',
          //     fontSize: 25,
          //     fontWeight: FontWeight.w700,
          //   ),
          // ),
        ],
      );
    } else if (vital.vitalType == VitalType.gl) {
      if (forceSingleLine) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${vital.reading.bgValue}',
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
            SizedBox(
              width: 7,
            ),
            Text(
              '${vital.measureUnit!}',
              softWrap: true,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: unitTextStyle != null
                  ? unitTextStyle
                  : TextStyle(
                      color: Color(0xFF4D54BB),
                      fontFamily: 'roboto',
                      fontSize: 25 * FCStyle.fem,
                      fontWeight: FontWeight.w700,
                    ),
            ),
          ],
        );
      }
      return Column(
        children: [
          Text(
            vital.reading.bgValue,
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
          Text(
            vital.measureUnit!,
            softWrap: true,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: textStyle ??
                TextStyle(
                  color: ColorPallet.kPrimaryTextColor,
                  fontSize: FCStyle.mediumFontSize * 3 / 5,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      );
    } else if (vital.vitalType == VitalType.heartRate) {
      if (forceSingleLine) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${vital.reading.pulse}',
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
            SizedBox(width: 7),
            Text(
              '${vital.measureUnit!}'.toLowerCase(),
              softWrap: true,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: unitTextStyle != null
                  ? unitTextStyle
                  : TextStyle(
                      color: Color(0xFF4D54BB),
                      fontFamily: 'roboto',
                      fontSize: 25 * FCStyle.fem,
                      fontWeight: FontWeight.w700,
                    ),
            ),
          ],
        );
      }
      return Column(
        children: [
          Text(
            vital.reading.pulse,
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
          Text(
            vital.measureUnit!,
            softWrap: true,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: textStyle ??
                TextStyle(
                  color: ColorPallet.kPrimaryTextColor,
                  fontSize: FCStyle.largeFontSize * 2 / 5,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      );
    } else if (vital.vitalType == VitalType.temp) {
      return Text(
        '${vital.reading.temperature} ${vital.measureUnit!}',
        softWrap: true,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: textStyle ??
            TextStyle(
              color: ColorPallet.kPrimaryTextColor,
              fontSize: FCStyle.largeFontSize,
              fontWeight: FontWeight.bold,
            ),
      );
    } else if (vital.vitalType == VitalType.fallDetection) {
      return Text(
        '${vital.reading.fallDetection ? 1 : 0} ${vital.measureUnit!}',
        softWrap: true,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: textStyle ??
            TextStyle(
              color: ColorPallet.kPrimaryTextColor,
              fontSize: FCStyle.largeFontSize,
              fontWeight: FontWeight.bold,
            ),
      );
    }

    return Text(
      '0 ${vital.measureUnit!}',
      softWrap: true,
      textAlign: TextAlign.center,
      maxLines: 2,
      style: textStyle ??
          TextStyle(
            color: ColorPallet.kPrimaryTextColor,
            fontSize: FCStyle.largeFontSize,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class VitalReadingWithoutUnit extends StatelessWidget {
  const VitalReadingWithoutUnit({
    Key? key,
    required this.vital,
    this.forceSingleLine = false,
    this.textStyle,
  }) : super(key: key);

  final Vital vital;
  final bool forceSingleLine;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    if (vital.vitalType == VitalType.bp) {
      if (forceSingleLine) {
        return Text(
          '${vital.reading.sys}/${vital.reading.dia}',
          softWrap: true,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: textStyle ??
              TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        );
      }

      return Column(
        children: [
          Text(
            vital.reading.sys,
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
          Divider(
            color: ColorPallet.kPrimaryTextColor,
          ),
          Text(
            vital.reading.dia,
            softWrap: true,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: textStyle ??
                TextStyle(
                  color: ColorPallet.kPrimaryTextColor,
                  fontSize: FCStyle.largeFontSize * 2 / 5,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      );
    } else if (vital.vitalType == VitalType.spo2) {
      return Text(
        vital.reading.oxygen,
        softWrap: true,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: textStyle ??
            TextStyle(
              color: ColorPallet.kPrimaryTextColor,
              fontSize: FCStyle.largeFontSize,
              fontWeight: FontWeight.bold,
            ),
      );
    } else if (vital.vitalType == VitalType.gl) {
      return Text(
        vital.reading.bgValue,
        softWrap: true,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: textStyle ??
            TextStyle(
              color: ColorPallet.kPrimaryTextColor,
              fontSize: FCStyle.largeFontSize,
              fontWeight: FontWeight.bold,
            ),
      );
    } else if (vital.vitalType == VitalType.heartRate) {
      return Text(
        vital.reading.pulse,
        softWrap: true,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: textStyle ??
            TextStyle(
              color: ColorPallet.kPrimaryTextColor,
              fontSize: FCStyle.largeFontSize,
              fontWeight: FontWeight.bold,
            ),
      );
    } else if (vital.vitalType == VitalType.temp) {
      return Text(
        vital.reading.temperature,
        softWrap: true,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: textStyle ??
            TextStyle(
              color: ColorPallet.kPrimaryTextColor,
              fontSize: FCStyle.largeFontSize,
              fontWeight: FontWeight.bold,
            ),
      );
    } else if (vital.vitalType == VitalType.fallDetection) {
      return Text(
        '${vital.reading.fallDetection ? 1 : 0} ${vital.measureUnit!}',
        softWrap: true,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: textStyle ??
            TextStyle(
              color: ColorPallet.kPrimaryTextColor,
              fontSize: FCStyle.largeFontSize,
              fontWeight: FontWeight.bold,
            ),
      );
    }

    return Text(
      '0 ${vital.measureUnit!}',
      softWrap: true,
      textAlign: TextAlign.center,
      maxLines: 2,
      style: textStyle ??
          TextStyle(
            color: ColorPallet.kPrimaryTextColor,
            fontSize: FCStyle.largeFontSize,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
