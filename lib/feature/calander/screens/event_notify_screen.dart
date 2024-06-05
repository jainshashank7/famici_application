import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/blocs/app_bloc/app_bloc.dart';
import '../../../core/router/router_delegate.dart';
import '../../../shared/fc_material_button.dart';
import '../../../shared/popup_scaffold.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../../utils/constants/assets_paths.dart';
import '../../notification/helper/appointment_notification_helper.dart';
import '../blocs/manage_reminders/manage_reminders_bloc.dart';

class EventNotifyScreen extends StatefulWidget {
  final Reminders reminder;

  const EventNotifyScreen({Key? key, required this.reminder}) : super(key: key);

  @override
  State<EventNotifyScreen> createState() => _EventNotifyScreenState();
}

class _EventNotifyScreenState extends State<EventNotifyScreen> {
  Reminders get reminder => widget.reminder;
  String time = '';

  @override
  void dispose() {
    AppointmentsNotificationHelper.dismissGroupKey(
      reminder.reminderId.toString(),
    );
    super.dispose();
  }

  getTime(DateTime startTime, DateTime endTime) {
    if (startTime == endTime) {
      time = DateFormat('hh:mm a, dd MMMM, yyyy').format(startTime);
    } else if (startTime.year == endTime.year &&
        startTime.month == endTime.month &&
        startTime.day == endTime.day) {
      time = '${DateFormat('hh:mm a').format(startTime)} - ${DateFormat('hh:mm a, dd MMMM, yyyy').format(endTime)}';
    } else {
      time = '${DateFormat('hh:mm a, dd MMMM, yyyy').format(reminder.startTime)} - ${DateFormat('hh:mm a, dd MMMM, yyyy').format(reminder.endTime)}';
    }
  }

  @override
  initState() {
    super.initState();
    context.read<AppBloc>().add(DisableLock());

    Future.delayed(const Duration(seconds: 15), () {
      print("activated 123");
      AppointmentsNotificationHelper.dismissGroupKey(
        reminder.reminderId.toString(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String itemType = reminder.itemType
        .toString()
        .replaceAll("ClientReminderType.", "")
        .replaceAll("REMINDER", "reminder")
        .replaceAll("EVENT", "event");

    getTime(reminder.startTime, reminder.endTime);

    return PopupScaffold(
      onTapOutside: () {
        fcRouter.pop();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              AssetIconPath.bellIcon,
              height: FCStyle.xLargeFontSize * 3,
              width: FCStyle.xLargeFontSize * 3,
            ),
          ),
          SizedBox(
            height: 15 * FCStyle.fem,
          ),
          Center(
            child: Text(
              '${reminder.title}',
              style: TextStyle(
                fontSize: 44 * FCStyle.fem,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(15 * FCStyle.fem),
            child: Text(
              time.replaceAll('pm', 'PM').replaceAll("am", 'AM'),
              style: TextStyle(
                fontSize: 28 * FCStyle.fem,
              ),
            ),
          ),
          reminder.note != ""
              ? Container(
                  margin: EdgeInsets.all(15 * FCStyle.fem),
                  child: Text(
                    'Note: ${reminder.note}' ?? "",
                    style: TextStyle(
                      fontSize: 30 * FCStyle.fem,
                    ),
                  ),
                )
              : SizedBox(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FCMaterialButton(
              onPressed: () {
                fcRouter.pop();
              },
              color: const Color(0xf25155c3),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10 * FCStyle.fem),
                      child: Center(
                        child: Text(
                          'Close',
                          textAlign: TextAlign.center,
                          style: FCStyle.textStyle.copyWith(
                            color: ColorPallet.kWhite,
                          ),
                        ),
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
