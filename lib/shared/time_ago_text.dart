import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

import '../utils/barrel.dart';

class TimeAgoText extends StatelessWidget {
  TimeAgoText({
    Key? key,
    required this.startTime,
    this.multiLine = false,
    this.textStyle,
    this.isDefault = false,
  }) : super(key: ValueKey(startTime.toString()));

  final int startTime;
  final bool multiLine;
  final TextStyle? textStyle;
  final bool isDefault;
  @override
  Widget build(BuildContext context) {
    return Timeago(
      date: DateTime.fromMillisecondsSinceEpoch(startTime),
      allowFromNow: true,
      builder: (context, value) {
        List<String> listStr = value
            .split(' ')
            .map((e) => toBeginningOfSentenceCase(e) ?? '')
            .toList();

        String count = isDefault ? listStr.first : listStr.first;

        if (multiLine) {
          listStr.removeAt(0);
          String suffix = listStr.join(' ');
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(count,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: textStyle != null
                      ? textStyle
                      : TextStyle(
                          color: Colors.black,
                          fontSize: (19 * FCStyle.fem),
                        )),
              SizedBox(
                width: 4,
              ),
              Text(
                suffix,
                softWrap: true,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: textStyle ??
                    TextStyle(
                        color: Colors.black, fontSize: (19 * FCStyle.fem)),
              ),
            ],
          );
        } else {
          String suffix = listStr.join(' ');
          return Text(
            suffix,
            softWrap: true,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: textStyle ??
                TextStyle(
                  color: Colors.black,
                  fontSize: (19 * FCStyle.fem),
                ),
          );
        }
      },
    );
  }
}
