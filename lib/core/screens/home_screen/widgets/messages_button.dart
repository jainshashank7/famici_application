part of 'barrel.dart';

class MessagesButton extends StatelessWidget {
  const MessagesButton({
    Key? key,
    double? size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return Column(
          children: [
            Text(
              HomeStrings.messages.tr(),
              style: TextStyle(
                color: themeState.isDark
                    ? ColorPallet.kWhite
                    : ColorPallet.kPrimaryTextColor,
                fontSize: FCStyle.mediumFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, notification) {
                return app.Badge(
                  showBadge: notification.multipleMessageCount.isNotEmpty,
                  badgeContent: SizedBox(
                    width: 50.r,
                    height: 50.r,
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            notification.multipleMessageCount.length > 99
                                ? "99+"
                                : NumberFormat.compact().format(
                                    notification.multipleMessageCount.length,
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
                    style: FCStyle.buttonCardStyle,
                    minDistance: 5,
                    onPressed: () async {
                      fcRouter.navigate(MultipleChatUserRoute());
                      // context
                      //     .read<ChatBloc>()
                      //     .add(ViewUserMessagesChatEvent(//contact
                      // ));
                    },
                    child: Container(
                      height: FCStyle.largeFontSize * 6,
                      width: FCStyle.largeFontSize * 6,
                      padding: EdgeInsets.all(FCStyle.mediumFontSize),
                      child: Image.asset(
                        AssetIconPath.messageIconDark,
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }
}
