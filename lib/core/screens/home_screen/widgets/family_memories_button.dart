part of 'barrel.dart';

class FamilyMemoriesButton extends StatelessWidget {
  const FamilyMemoriesButton({
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
                MemoriesStrings.photos.tr(),
                style: TextStyle(
                  color: themeState.isDark ? ColorPallet.kWhite : ColorPallet.kPrimaryTextColor,
                  fontSize: FCStyle.mediumFontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16.0),
              BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, notification) {
                  return app.Badge(
                    showBadge: notification.memories.isNotEmpty,
                    badgeContent: SizedBox(
                      width: 50.r,
                      height: 50.r,
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              notification.memories.length > 99
                                  ? "99+"
                                  : NumberFormat.compact().format(
                                notification.memories.length,
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
                      key: FCElementID.familyMemoriesButton,
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      style: FCStyle.buttonCardStyle,
                      minDistance: 5,
                      onPressed: () {
                        fcRouter.navigate(FamilyMemoriesRoute());
                      },
                      child: BlocBuilder<ThemeCubit, ThemeState>(
                        builder: (context, state) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(32.0),
                            child: Container(
                              height: FCStyle.largeFontSize * 6,
                              width: FCStyle.largeFontSize * 6,
                              padding: EdgeInsets.all(16.0),
                              foregroundDecoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    state.mode == Brightness.dark
                                        ? AssetIconPath.memoriesIconDark
                                        : AssetIconPath.memoriesIcon,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }
    );
  }
}
