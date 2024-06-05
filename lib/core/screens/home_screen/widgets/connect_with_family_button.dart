part of 'barrel.dart';

class ConnectWithFamilyButton extends StatelessWidget {
  final isMemberPortal;
  const ConnectWithFamilyButton({
    required this.isMemberPortal,
    Key? key,
    double? size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState)
    {
      return Column(
        children: [
          Text(
            HomeStrings.myMemberPortal.tr(),
            style: TextStyle(
              color: themeState.isDark ? ColorPallet.kWhite : ColorPallet.kPrimaryTextColor,
              fontSize: FCStyle.mediumFontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, notification) {
              return app.Badge(
                //showBadge: notification.messages.isNotEmpty,
                showBadge: false,
                badgeContent: SizedBox(
                  width: 50.r,
                  height: 50.r,
                  child: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          notification.messageCount > 99
                              ? "99+"
                              : NumberFormat.compact().format(
                            notification.messageCount,
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
                  key: FCElementID.connectWithFamilyButton,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  style: isMemberPortal ? FCStyle.highlightedButtonCardStyle :  FCStyle.buttonCardStyle,
                  minDistance: 5,
                  onPressed: () {
                    // context.read<MyAppsCubit>().launchWebPortal();
                    fcRouter.navigate(MemberHomeRoute());
                  },
                  child: Container(
                    height: FCStyle.largeFontSize * 6,
                    width: FCStyle.largeFontSize * 6,
                    decoration: BoxDecoration(
                    color: themeState.isDark ? ColorPallet.kDark : ColorPallet.kCardBackground,
                    ),
                    padding: EdgeInsets.all(FCStyle.mediumFontSize),
                    child: Image.asset(
                      AssetIconPath.memberIcon,
                    ),
                  ),
                ),
              );
            },
          )
        ],
      );
    }
    );
  }
}
