import 'package:badges/badges.dart' as app;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/feature/notification/blocs/notification_bloc/notification_bloc.dart';
import 'package:famici/utils/barrel.dart';

import '../../../../utils/helpers/events_track.dart';

class MessageButton extends StatefulWidget {
  const MessageButton({Key? key}) : super(key: key);

  @override
  State<MessageButton> createState() => _MessageButtonState();
}

class _MessageButtonState extends State<MessageButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      buildWhen: (prv, next) => prv.globalCount != next.globalCount,
      builder: (context, state) {
        int msgCount = state.globalCount ?? 0;
        return Container(
          margin: EdgeInsets.fromLTRB(0 * FCStyle.fem, 0 * FCStyle.fem,
              5 * FCStyle.fem, 0 * FCStyle.fem),
          child: TextButton(
            onPressed: () {
              var properties = TrackEvents().setProperties(
                  fromDate: '',
                  toDate: '',
                  reading: '',
                  readingDateTime: '',
                  vital: '',
                  appointmentDate: '',
                  appointmentTime: '',
                  appointmentCounselors: '',
                  appointmentType: '',
                  callDuration: '',
                  readingType: '');

              TrackEvents().trackEvents('Messages Clicked', properties);
              fcRouter.navigate(const MultipleChatUserRoute());
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: SizedBox(
              width: 60 * FCStyle.fem,
              height: double.infinity,
              child: Container(
                padding: EdgeInsets.fromLTRB(7.26 * FCStyle.fem,
                    3.21 * FCStyle.fem, 9.37 * FCStyle.fem, 3.21 * FCStyle.fem),
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xfffefeff),
                  borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x03294898),
                      offset:
                          Offset(0 * FCStyle.fem, 1.8518518209 * FCStyle.fem),
                      blurRadius: 1.5740740299 * FCStyle.fem,
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 47.79 * FCStyle.fem,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0 * FCStyle.fem,
                        top: 9.7926635742 * FCStyle.fem,
                        child: Align(
                          child: app.Badge(
                            showBadge: msgCount > 0,
                            badgeColor: const Color(0xff4F56C1),
                            badgeContent: SizedBox(
                              width: 20.r,
                              height: 20.r,
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    msgCount > 99
                                        ? "99+"
                                        : NumberFormat.compact().format(
                                            msgCount,
                                          ),
                                    style: FCStyle.textStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            child: SizedBox(
                              width: 39 * FCStyle.fem,
                              height: 38 * FCStyle.fem,
                              child: SvgPicture.asset(
                                AssetIconPath.messageNotificationIcon,
                                width: 39 * FCStyle.fem,
                                height: 38 * FCStyle.fem,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
