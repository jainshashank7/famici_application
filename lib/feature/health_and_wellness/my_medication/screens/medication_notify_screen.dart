import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:famici/core/blocs/app_bloc/app_bloc.dart';
import 'package:famici/feature/health_and_wellness/my_medication/blocs/medication_bloc.dart';
import 'package:famici/feature/health_and_wellness/my_medication/blocs/medication_popup_cubit/medication_notify_cubit.dart';
import 'package:famici/feature/notification/entities/notification.dart' as app;
import 'package:famici/feature/notification/helper/medication_notify_helper.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/router/router_delegate.dart';
import '../../../../shared/popup_scaffold.dart';
import '../../../../utils/barrel.dart';
import '../../../../utils/helpers/widget_key.dart';
import '../../../../utils/strings/medication_strings.dart';
import '../../../notification/blocs/notification_bloc/notification_bloc.dart';

class MedicationNotifyScreen extends StatefulWidget {
  final app.Notification notification;

  const MedicationNotifyScreen({Key? key, required this.notification})
      : super(key: key);

  @override
  State<MedicationNotifyScreen> createState() => _MedicationNotifyScreenState();
}

class _MedicationNotifyScreenState extends State<MedicationNotifyScreen> {
  final MedicationNotifyCubit _notifyCubit = MedicationNotifyCubit();

  app.Notification get notification => widget.notification;

  // late Timer _timer;
  late DateTime _now = DateTime.now();
  late MedicationBloc _medicationBloc;

  // void changeDateTime() {
  //   _timer = Timer.periodic(Duration(minutes: 1), (timer) {
  //     setState(() {
  //       _now = DateTime.now();
  //     });
  //   });
  // }

  @override
  void initState() {
    _notifyCubit.syncNotifiedMedication(notification);
    _medicationBloc = context.read<MedicationBloc>();
    // changeDateTime();
    super.initState();

    context
        .read<NotificationBloc>()
        .add(SyncScheduledMedicationNotificationEvent(notification));

    context.read<AppBloc>().add(DisableLock());
  }

  String message(String type, String time, int quantity) {
    Map<String, String> messages = {
      "Cream": "Did you apply cream at $time?",
      "Inhaler": "Did you take puffs at $time?",
      "Capsule": "Did you take quantity pills at $time?",
      "Oral": "Did you take drops at $time?",
      "Pill":
          "Did you take $quantity ${quantity > 1 ? 'pills' : 'pill'} at $time?",
      "Injection": "Did you take injections at $time?",
      "Tablet":
          "Did you take $quantity ${quantity > 1 ? 'pills' : 'pill'} at $time?",
      "Suppository":
          "Did you take $quantity ${quantity > 1 ? 'suppositories' : 'suppository'}  at $time?",
    };

    return messages[type] ?? '';
  }

  @override
  void dispose() {
    MedicationNotificationHelper.dismissScheduleGroupKey(notification.groupKey);
    Future.delayed(Duration(seconds: 10), () {
      _notifyCubit.close();
    });
    _medicationBloc.add(FetchMedications());
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('%%%%%%%%%%%%%%%');
    // print("Medication triggred");
    print('this is ntofifcation body ' + notification.body.toString());
    return PopupScaffold(
      height: MediaQuery.of(context).size.height - 100,
      width: MediaQuery.of(context).size.width - 100,
      onTapOutside: () {
        fcRouter.pop();
      },
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 20, top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           DateFormat('hh:mm a').format(_now),
                    //           maxLines: 2,
                    //           softWrap: true,
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //               color: ColorPallet.kPrimaryTextColor,
                    //               fontSize: FCStyle.largeFontSize,
                    //               fontWeight: FontWeight.w500),
                    //         ),
                    //         Text(
                    //           DateFormat.yMMMd().format(_now),
                    //           maxLines: 2,
                    //           softWrap: true,
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //               color: ColorPallet.kPrimaryTextColor,
                    //               fontSize: FCStyle.mediumFontSize,
                    //               fontWeight: FontWeight.w400),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    InkWell(
                      onTap: () {
                        fcRouter.pop();
                      },
                      child: Icon(Icons.close,
                          color: ColorPallet.kPrimaryTextColor,
                          size: FCStyle.blockSizeVertical * 10),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: FCStyle.blockSizeVertical * 3,
              ),
              CachedNetworkImage(
                height: FCStyle.blockSizeVertical * 15,
                fit: BoxFit.fitHeight,
                imageUrl: notification.body.imgUrl,
                //httpHeaders: {"Authorization": "Bearer $token}"},
                placeholder: (context, url) => Container(
                  child: Shimmer.fromColors(
                      baseColor: ColorPallet.kWhite,
                      highlightColor: ColorPallet.kPrimaryGrey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                        children: <Widget>[
                          Container(
                            child: Icon(
                              Icons.photo,
                              size: FCStyle.blockSizeVertical * 15,
                            ),
                          ),
                        ],
                      )),
                ),
                errorWidget: (context, url, error) => Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.broken_image,
                          size: FCStyle.blockSizeVertical * 15,
                          color: ColorPallet.kWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                fadeInCurve: Curves.easeIn,
                fadeInDuration: const Duration(milliseconds: 100),
              ),
              SizedBox(
                height: FCStyle.blockSizeVertical * 2,
              ),
              Text(
                notification.body.medicationName,
                maxLines: 2,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ColorPallet.kPrimaryTextColor,
                    fontSize: FCStyle.largeFontSize,
                    fontWeight: FontWeight.w700),
              ),
              // BlocBuilder<MedicationNotifyCubit, MedicationNotifyState>(
              //   bloc: _notifyCubit,
              //   builder: (context, MedicationNotifyState medicNotification) {
              //     return Text(
              //       message(
              //         notification.body.medicationType,
              //         DateFormat("hh:mm a").format(
              //           DateFormat("HH:mm").parse(
              //             medicNotification.dosage.time,
              //           ),
              //         ),
              //         medicNotification.dosage.quantity,
              //       ),
              //       maxLines: 2,
              //       softWrap: true,
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //           color: ColorPallet.kPrimaryTextColor,
              //           fontSize: FCStyle.largeFontSize + 5,
              //           fontWeight: FontWeight.w700),
              //     );
              //   },
              // ),
              SizedBox(
                height: FCStyle.blockSizeVertical * 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NeumorphicButton(
                    key: FCElementID.yesButton,
                    onPressed: () {
                      _notifyCubit.submitTaken();
                      fcRouter.pop();
                    },
                    style: FCStyle.greenButtonStyle,
                    child: Container(
                      width: 120,
                      height: 48.0,
                      alignment: Alignment.center,
                      child: Text(
                        CommonStrings.yes.tr(),
                        style: TextStyle(
                          color: ColorPallet.kBackButtonTextColor,
                          fontSize: FCStyle.mediumFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 96.0),
                  NeumorphicButton(
                    key: FCElementID.noButton,
                    onPressed: () {
                      _notifyCubit.submitMissed();
                      fcRouter.pop();
                    },
                    style: FCStyle.redButtonStyle,
                    child: Container(
                      width: 120,
                      height: 48.0,
                      alignment: Alignment.center,
                      child: Text(
                        CommonStrings.no.tr(),
                        style: TextStyle(
                          color: ColorPallet.kBackButtonTextColor,
                          fontSize: FCStyle.mediumFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              BlocBuilder<MedicationNotifyCubit, MedicationNotifyState>(
                bloc: _notifyCubit,
                builder: (context, MedicationNotifyState medicNotification) {
                  return Text(
                    medicNotification.dosage.detail,
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorPallet.kPrimaryTextColor,
                        fontSize: FCStyle.mediumFontSize + 6,
                        fontWeight: FontWeight.w400),
                  );
                },
              ),
            ],
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.all(20),
            child: NeumorphicButton(
              style: FCStyle.primaryButtonStyle,
              onPressed: () {
                fcRouter.pop();

                fcRouter.navigate(MedicationDetailsRoute());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: FCStyle.blockSizeHorizontal * 15,
                    height: FCStyle.blockSizeVertical * 10,
                    child: Center(
                      child: Text(
                        MedicationStrings.viewMedicationDetails.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorPallet.kPrimaryTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: FCStyle.mediumFontSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
