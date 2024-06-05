part of 'barrel.dart';

class HealthAndWellnessButton extends StatelessWidget {
  final isHealthAndWellness;

  const HealthAndWellnessButton( {
    required this.isHealthAndWellness,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState)
    {
      return Center(
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, notification) {
            int count = notification.appointments.length +
                notification.medications.length;
            return app.Badge(
              position: app.BadgePosition.topEnd(end: 24.r),
              showBadge: count > 0,
              badgeContent: SizedBox(
                width: 50.r,
                height: 50.r,
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        count > 99
                            ? '99+'
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
                key: FCElementID.healthAndWellnessButton,
                onPressed: () {
                  fcRouter.navigate(HealthAndWellnessRoute());
                },
                padding: EdgeInsets.all(FCStyle.smallFontSize),
                margin: EdgeInsets.symmetric(
                  horizontal: FCStyle.smallFontSize + 2,
                ),
                minDistance: 5,
                style: isHealthAndWellness? FCStyle.highlightedButtonCardStyle : FCStyle.buttonCardStyle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Image.asset(
                        AssetIconPath.plusIcon,
                        excludeFromSemantics: true,
                        height: FCStyle.mediumFontSize * 4,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        HomeStrings.healthAndWellness.tr(),
                        style: TextStyle(
                          color: themeState.isDark ? ColorPallet.kWhite : ColorPallet.kPrimaryTextColor,
                          fontSize: FCStyle.mediumFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
    );
  }
}
