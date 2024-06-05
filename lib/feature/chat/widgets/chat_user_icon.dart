import 'package:badges/badges.dart' as app;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../../utils/constants/assets_paths.dart';
import '../../notification/blocs/notification_bloc/notification_bloc.dart';
import '../blocs/chat_bloc/chat_bloc.dart';
import '../blocs/sigle_user_chat/single_user_chat_bloc.dart';

class ChatUserIcon extends StatefulWidget {
  final String conversationId;
  final String senderId;
  final String profileUrl;
  final String username;

  const ChatUserIcon(
      {Key? key,
      required this.conversationId,
      required this.senderId,
      required this.profileUrl,
      required this.username})
      : super(key: key);

  @override
  State<ChatUserIcon> createState() => _ChatUserIconState();
}

class _ChatUserIconState extends State<ChatUserIcon> {
  int msgCount = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      buildWhen: (prv, next) =>
          prv.multipleMessageCount[widget.senderId] !=
              next.multipleMessageCount[widget.senderId] ||
          !prv.multipleMessageCount.containsKey(widget.senderId) ||
          !next.multipleMessageCount.containsKey(widget.senderId),
      builder: (context, notification) {
        msgCount = notification.multipleMessageCount[widget.senderId] ?? 0;
        return app.Badge(
          showBadge: msgCount > 0,
          badgeColor: const Color(0xff4F56C1),
          badgeContent: SizedBox(
            width: 60.r,
            height: 60.r,
            child: Padding(
              padding: EdgeInsets.all(8.r),
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
                      fontSize: 32.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
          child: GestureDetector(
            onTap: () async {
              context
                  .read<ChatBloc>()
                  .add(ViewUserMessagesChatEvent(widget.conversationId));

              context
                  .read<SingleUserChatBloc>()
                  .add(SetCurrentUserName(widget.username));
            },
            child: Container(
              width: 200 * FCStyle.fem,
              height: 180 * FCStyle.fem,
              alignment: Alignment.center,
              padding: EdgeInsets.all(15 * FCStyle.fem),
              decoration: BoxDecoration(
                color: ColorPallet.kWhite,
                borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.profileUrl == ""
                      ? SvgPicture.asset(
                          AssetIconPath.avatarIcon,
                          excludeFromSemantics: true,
                          height: 100 * FCStyle.fem,
                          color: Color(0xFF5057C3),
                        )
                      : CachedNetworkImage(
                          height: 180 * FCStyle.fem,
                          width: 170 * FCStyle.fem,
                          fit: BoxFit.cover,
                          imageUrl: widget.profileUrl ?? "",
                          placeholder: (context, url) => SizedBox(
                            height: 180 * FCStyle.fem,
                            child: Shimmer.fromColors(
                                baseColor: ColorPallet.kWhite,
                                highlightColor: ColorPallet.kPrimaryGrey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.photo,
                                      size: 180 * FCStyle.fem,
                                    ),
                                  ],
                                )),
                          ),
                          errorWidget: (context, url, error) => SizedBox(
                            height: 100 * FCStyle.fem,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  DashboardIcons.mobexNewLogoVertical,
                                  size: 100 * FCStyle.fem,
                                  color: ColorPallet.kPrimaryTextColor,
                                ),
                              ],
                            ),
                          ),
                          fadeInCurve: Curves.easeIn,
                          fadeInDuration: const Duration(milliseconds: 100),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
