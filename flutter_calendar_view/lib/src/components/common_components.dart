// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../style/header_style.dart';
import '../typedefs.dart';

class CalendarPageHeader extends StatelessWidget {
  /// When user taps on right arrow.
  final VoidCallback? onNextDay;

  /// When user taps on left arrow.
  final VoidCallback? onPreviousDay;

  /// When user taps on title.
  final AsyncCallback? onTitleTapped;

  /// Date of month/day.
  final DateTime date;

  /// Secondary date. This date will be used when we need to define a
  /// range of dates.
  /// [date] can be starting date and [secondaryDate] can be end date.
  final DateTime? secondaryDate;

  /// Provides string to display as title.
  final StringProvider dateStringBuilder;

  /// backgeound color of header.
  final Color backgroundColor;

  /// Color of icons at both sides of header.
  final Color iconColor;

  final Color textColor;
  final double? fontSize;

  final bool showTopDate;

  /// Common header for month and day view In this header user can define format
  /// in which date will be displayed by providing [dateStringBuilder] function.
  const CalendarPageHeader({
    Key? key,
    required this.date,
    required this.dateStringBuilder,
    this.onNextDay,
    this.onTitleTapped,
    this.onPreviousDay,
    this.secondaryDate,
    this.backgroundColor = Constants.headerBackground,
    this.iconColor = Constants.black,
    this.textColor = Colors.white,
    this.showTopDate = false,
    this.fontSize,
    required HeaderStyle headerStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      padding: EdgeInsets.only(top: 10),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Schedule Preview',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: InkWell(
                        onTap: onTitleTapped,
                        child: Text(
                          DateFormat('MMMM d, y').format(this.date),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: backgroundColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onPreviousDay,
                      customBorder: CircleBorder(),
                      child: Container(
                        child: Center(
                          child: Icon(
                            Icons.chevron_left,
                            size: 25,
                            weight: 700,
                            color: backgroundColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    InkWell(
                      onTap: onNextDay,
                      customBorder: CircleBorder(),
                      child: Container(
                        child: Center(
                          child: Icon(
                            Icons.chevron_right,
                            size: 25,
                            weight: 700,
                            color: backgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 250,
                )
              ]),
          if (showTopDate)
            LayoutBuilder(builder: (context, cons) {
              return Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: (cons.biggest.width / 6) + 16,
                ),
                child: Text(
                  DateFormat().add_MMMMEEEEd().format(date),
                  style: TextStyle(
                    color: backgroundColor,
                    fontSize: fontSize,
                  ),
                ),
              );
            })
        ],
      ),
    );
  }
}
