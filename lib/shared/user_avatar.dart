import 'dart:io';

import 'package:badges/badges.dart' as app;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:shimmer/shimmer.dart';

import '../feature/notification/blocs/notification_bloc/notification_bloc.dart';

class UserAvatar extends StatelessWidget {
  UserAvatar(
      {Key? key,
        required this.user,
        this.onTap,
        double? height,
        double? width,
        double? padding,
        this.circleMargin,
        EdgeInsets? margin,
        double? borderRadius,
        bool? showName,
        EdgeInsets? namePadding,
        bool? hideNonVerifiedUser,
        bool? showNotificationBadge})
      : width = width ?? FCStyle.xLargeFontSize * 4,
        height = height ?? FCStyle.xLargeFontSize * 4,
        margin = margin ?? const EdgeInsets.all(32),
        namePadding = namePadding ?? EdgeInsets.zero,
        padding = padding ?? 16.0,
        borderRadius = borderRadius ?? 32.0,
        showName = showName ?? false,
        hideNonVerifiedUser = hideNonVerifiedUser ?? true,
        showNotificationBadge = showNotificationBadge ?? false,
        super(key: key);

  final User user;
  final VoidCallback? onTap;
  final double height;
  final double width;
  final double padding;
  final EdgeInsets margin;
  final double? circleMargin;
  final double borderRadius;
  final bool showName;
  final bool showNotificationBadge;
  final bool hideNonVerifiedUser;
  final EdgeInsets namePadding;

  ImageProvider? get profileImage {
    if (isNull(user.profileUrl)) {
      return CachedNetworkImageProvider('');
    }
    if (user.profileUrl!.contains('http://') ||
        user.profileUrl!.contains('https://')) {
      return CachedNetworkImageProvider(
        user.profileUrl ?? '',
      );
    }
    return FileImage(File(user.profileUrl!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return hideNonVerifiedUser && !user.isInvitationAccepted?
        SizedBox.shrink():
        Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: margin,
                  child: BlocBuilder<NotificationBloc, NotificationState>(
                    builder: (context, notification) {
                      int count = notification.messages[user.id]?.length ?? 0;
                      return app.Badge(
                        showBadge: showNotificationBadge && count > 0,
                        badgeContent: SizedBox(
                          width: 50.r,
                          height: 50.r,
                          child: Padding(
                            padding: EdgeInsets.all(8.r),
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                  count > 99
                                      ? "99+"
                                      : NumberFormat.compact().format(
                                    count,
                                  ),
                                  style: FCStyle.textStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 30.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        elevation: 6,
                        padding: EdgeInsets.all(4.0),
                        child: NeumorphicButton(
                          minDistance: 4,
                          padding: EdgeInsets.all(padding),
                          onPressed: onTap,
                          style: FCStyle.buttonCardStyle.copyWith(
                            color: user.isSelected
                                ? ColorPallet.kDarkShadeGreen
                                : null,
                            border: user.isSelected
                                ? NeumorphicBorder(
                              color: ColorPallet.kBrightGreen,
                              width: 1,
                            )
                                : NeumorphicBorder(
                              width: 0,
                            ),
                          ),
                          child: Container(
                            width: width,
                            height: height,
                            padding: EdgeInsets.all(circleMargin ?? width / 12),
                            child:
                            // Container(
                            //   child: Text('dqwdqw'),
                            // )

                            user.profileUrl != null &&
                                user.profileUrl!.isNotEmpty &&
                                storageType(user.profileUrl ?? '') ==
                                    StorageType.local
                                ? CircleAvatar(
                                backgroundColor: ColorPallet.kGrey,
                                foregroundImage:
                                FileImage(File(user.profileUrl!)),
                                child: themeState.mode ==
                                    Brightness.dark
                                    ? Image(
                                    image: AssetImage(
                                      AssetIconPath.userAvatarLight,
                                    ))
                                    : Image(
                                    image: AssetImage(
                                      AssetIconPath.userAvatar,
                                    )))
                                : CachedNetworkImage(
                              imageUrl: user.profileUrl ?? '',
                              imageBuilder: (
                                  context,
                                  ImageProvider image,
                                  ) {
                                return CircleAvatar(
                                  backgroundColor: ColorPallet.kGrey,
                                  foregroundImage:
                                  !isNull(user.profileUrl)
                                      ? image
                                      : null,
                                  child: themeState.mode ==
                                      Brightness.dark
                                      ? Image(
                                      image: AssetImage(
                                        AssetIconPath
                                            .userAvatarLight,
                                      ))
                                      : Image(
                                    image: AssetImage(
                                      AssetIconPath.userAvatar,
                                    ),
                                  ),
                                );
                              },
                              errorWidget: (context, url, dynamic) {
                                return CircleAvatar(
                                  backgroundColor:
                                  ColorPallet.kCardBackground,
                                  child: themeState.mode ==
                                      Brightness.dark
                                      ? Image(
                                      image: AssetImage(
                                        AssetIconPath
                                            .userAvatarLight,
                                      ))
                                      : Image(
                                    image: AssetImage(
                                      AssetIconPath.userAvatar,
                                    ),
                                  ),
                                );
                              },
                              progressIndicatorBuilder:
                                  (context, url, progress) {
                                return Shimmer.fromColors(
                                  child: CircleAvatar(),
                                  baseColor: ColorPallet
                                      .kDarkBackGround
                                      .withOpacity(0.7),
                                  highlightColor: ColorPallet
                                      .kLightBackGround
                                      .withOpacity(0.7),
                                  // direction: ShimmerDirection.ltr,
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                showName
                    ? Padding(
                  padding: namePadding,
                  child: Text(
                    user.givenName ?? 'Anonymous',
                    style: TextStyle(
                      color: ColorPallet.kPrimaryTextColor,
                      fontSize: FCStyle.defaultFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                    : SizedBox.shrink()
              ],
            ),
          ],
        );
      },
    );
  }
}
