import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livecare/livecare.dart';
import 'package:famici/utils/barrel.dart';

import '../../../shared/barrel.dart';

class MeasurementSummary extends StatelessWidget {
  MeasurementSummary({
    Key? key,
    double? lowest,
    double? highest,
    double? average,
    String? unit,
    DateTime? lowestDate,
    DateTime? highestDate,
    int? numberOfDaysForAvg,
  })  : _lowest = lowest ?? 0,
        _highest = highest ?? 0,
        _average = average ?? 0,
        _unit = unit ?? '',
        _numberOfDaysForAvg = numberOfDaysForAvg ?? 1,
        _lowestDate = lowestDate ?? DateTime.now(),
        _highestDate = highestDate ?? DateTime.now(),
        super(key: key);

  final double _lowest;
  final DateTime _lowestDate;
  final double _highest;
  final DateTime _highestDate;
  final double _average;
  final int _numberOfDaysForAvg;
  final String _unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 910.h,
      width: FCStyle.xLargeFontSize * 7,
      padding: EdgeInsets.symmetric(
        horizontal: FCStyle.mediumFontSize,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Lowest Measure', style: FCStyle.textStyle),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: ConcaveCard(
              borderRadius: BorderRadius.circular(
                FCStyle.defaultFontSize,
              ),
              child: Container(
                width: double.infinity,
                height: 140.h,
                padding: EdgeInsets.symmetric(
                  horizontal: FCStyle.defaultFontSize,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat().add_MMM().add_d().format(_lowestDate),
                      style: FCStyle.textStyle.copyWith(
                        fontSize: FCStyle.defaultFontSize,
                      ),
                    ),
                    Text(
                      '${NumberFormat.compact().format(_lowest)} $_unit',
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: FCStyle.textStyle.copyWith(
                        fontSize: FCStyle.largeFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text('Highest Measure', style: FCStyle.textStyle),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: ConcaveCard(
              borderRadius: BorderRadius.circular(
                FCStyle.defaultFontSize,
              ),
              child: Container(
                width: double.infinity,
                height: 130.h,
                padding: EdgeInsets.symmetric(
                  horizontal: FCStyle.defaultFontSize,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat().add_MMM().add_d().format(_highestDate),
                      style: FCStyle.textStyle.copyWith(
                        fontSize: FCStyle.defaultFontSize,
                      ),
                    ),
                    Text(
                      '${NumberFormat.compact().format(_highest)} $_unit',
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: FCStyle.textStyle.copyWith(
                        fontSize: FCStyle.largeFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text('Average Measure', style: FCStyle.textStyle),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: ConcaveCard(
              borderRadius: BorderRadius.circular(
                FCStyle.defaultFontSize,
              ),
              child: Container(
                width: double.infinity,
                height: 140.h,
                padding: EdgeInsets.symmetric(
                  horizontal: FCStyle.defaultFontSize,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Last $_numberOfDaysForAvg Days',
                      style: FCStyle.textStyle.copyWith(
                        fontSize: FCStyle.defaultFontSize,
                      ),
                    ),
                    Text(
                      '${NumberFormat.compact().format(_average)} $_unit',
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: FCStyle.textStyle.copyWith(
                        fontSize: FCStyle.largeFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
