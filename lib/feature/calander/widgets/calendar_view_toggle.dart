import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famici/feature/calander/blocs/calendar/calendar_bloc.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

class CalendarViewToggle extends StatefulWidget {
  const CalendarViewToggle({
    Key? key,
    CalendarView? selected,
    this.onChange,
  })  : selected = selected ?? CalendarView.day,
        super(key: key);

  final CalendarView selected;
  final ValueChanged<CalendarView>? onChange;
  @override
  _CalendarViewToggleState createState() => _CalendarViewToggleState();
}

class _CalendarViewToggleState extends State<CalendarViewToggle> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 428 * FCStyle.fem,
      height: 54 * FCStyle.fem,
      child: Stack(
        children: [
          SizedBox(
            width: 428 * FCStyle.fem,
            height: 54 * FCStyle.fem,
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            left: 428 * FCStyle.fem * (widget.selected.index) / 3,
            child: FCGradientButton(
              onPressed: () {},
              child: SizedBox(
                width: 428 * FCStyle.fem / 3,
                height: 54 * FCStyle.fem,
              ),
              padding: EdgeInsets.zero,
              borderRadius: 0.r,
            ),
          ),
          SizedBox(
            width: 428 * FCStyle.fem,
            height: 54 * FCStyle.fem,
            child: Row(
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(15.r),
                  onTap: () {
                    widget.onChange?.call(CalendarView.day);
                  },
                  child: Container(
                    width: 428 * FCStyle.fem / 3,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 4.0),
                    decoration: BoxDecoration(
                        border: widget.selected == CalendarView.day
                            ? Border.all(color: Colors.transparent, width: 0)
                            : Border.all(
                                color: Color.fromARGB(255, 216, 218, 220),
                                width: 1)),
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: TextStyle(
                        color: widget.selected == CalendarView.day
                            ? ColorPallet.kPrimaryText
                            : ColorPallet.kPrimary,
                        fontSize: 24 * FCStyle.fem,
                      ),
                      child: Text(CalendarView.day.name.capitalize()),
                    ),
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(15.r),
                  onTap: () {
                    widget.onChange?.call(CalendarView.week);
                  },
                  child: Container(
                    width: 428 * FCStyle.fem / 3,
                    decoration: BoxDecoration(
                        border: widget.selected == CalendarView.week
                            ? Border.all(color: Colors.transparent, width: 0)
                            : Border.all(
                                color: Color.fromARGB(255, 216, 218, 220),
                                width: 1)),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 4.0),
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: TextStyle(
                        color: widget.selected == CalendarView.week
                            ? ColorPallet.kPrimaryText
                            : ColorPallet.kPrimary,
                        fontSize: 24 * FCStyle.fem,
                      ),
                      child: Text(CalendarView.week.name.capitalize()),
                    ),
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(15.r),
                  onTap: () {
                    widget.onChange?.call(CalendarView.month);
                  },
                  child: Container(
                    width: 428 * FCStyle.fem / 3,
                    decoration: BoxDecoration(
                        border: widget.selected == CalendarView.month
                            ? Border.all(color: Colors.transparent, width: 0)
                            : Border.all(
                                color: Color.fromARGB(255, 216, 218, 220),
                                width: 1)),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 4.0),
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: TextStyle(
                        color: widget.selected == CalendarView.month
                            ? ColorPallet.kPrimaryText
                            : ColorPallet.kPrimary,
                        fontSize: 24 * FCStyle.fem,
                      ),
                      child: Text(CalendarView.month.name.capitalize()),
                    ),
                  ),
                ),
                // InkWell(
                //   splashColor: Colors.transparent,
                //   hoverColor: Colors.transparent,
                //   highlightColor: Colors.transparent,
                //   borderRadius: BorderRadius.circular(15.r),
                //   onTap: () {
                //     widget.onChange?.call(CalendarView.year);
                //   },
                //   child: Container(
                //     width: 428 * FCStyle.fem / 4,
                //     alignment: Alignment.center,
                //     decoration: BoxDecoration(
                //         border: widget.selected == CalendarView.year
                //             ? Border.all(color: Colors.transparent, width: 0)
                //             : Border.all(
                //                 color: Color.fromARGB(255, 216, 218, 220),
                //                 width: 1)),
                //     padding: EdgeInsets.only(left: 4.0),
                //     child: AnimatedDefaultTextStyle(
                //       duration: Duration(milliseconds: 300),
                //       style: TextStyle(
                //         color: widget.selected == CalendarView.year
                //             ? Colors.white
                //             :ColorPallet.kPrimary,
                //         fontSize: 24 * FCStyle.fem,
                //       ),
                //       child: Text(CalendarView.year.name.capitalize()),
                //     ),
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
