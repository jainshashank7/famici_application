import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/feature/notification/blocs/notification_bloc/notification_bloc.dart';
import 'package:famici/feature/notification/entities/notification.dart'
as app;
import 'package:famici/feature/notification/helper/appointment_notification_helper.dart';
import 'package:famici/feature/notification/helper/memories_notification_helper.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

import '../../../core/blocs/app_bloc/app_bloc.dart';

class MemoriesNotifyScreen extends StatefulWidget {
  const MemoriesNotifyScreen({Key? key, required this.notification})
      : super(key: key);

  final app.Notification notification;

  @override
  State<MemoriesNotifyScreen> createState() =>
      _MemoriesNotifyScreenState();
}

class _MemoriesNotifyScreenState extends State<MemoriesNotifyScreen> {
  app.Notification get notification => widget.notification;

  @override
  void dispose() {
    MemoriesNotificationHelper.dismissGroupKey(
      notification.groupKey,
    );
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    context
        .read<NotificationBloc>()
        .add(SyncMemoryNotificationEvent(notification));
    context.read<AppBloc>().add(DisableLock());
  }

  @override
  Widget build(BuildContext context) {
    return PopupScaffold(
      onTapOutside: () {
        fcRouter.pop();
      },
      child: Column(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "You got a new photos.",
              style: FCStyle.textHeaderStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "check it out from family memories.",
              style: FCStyle.textStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FCMaterialButton(
              onPressed: () {
                fcRouter.pop();
              },
              color: ColorPallet.kGreen,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        'Dismiss',
                        textAlign: TextAlign.center,
                        style: FCStyle.textStyle.copyWith(
                          color: ColorPallet.kWhite,
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
