part of 'barrel.dart';

class MyAppsButton extends StatelessWidget {
  const MyAppsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, themeState) {
      return Center(
        child: NeumorphicButton(
          key: FCElementID.myAppsButton,
          onPressed: () async {
            fcRouter.navigate(MyAppRoute());
          },
          minDistance: 5,
          padding: EdgeInsets.all(FCStyle.smallFontSize),
          margin: EdgeInsets.symmetric(
            horizontal: FCStyle.smallFontSize + 2,
          ),
          style: FCStyle.buttonCardStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image.asset(
                  AssetIconPath.moreIcon,
                  excludeFromSemantics: true,
                  height: FCStyle.mediumFontSize * 4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  HomeStrings.myApps.tr(),
                  style: TextStyle(
                    color: themeState.isDark
                        ? ColorPallet.kWhite
                        : ColorPallet.kPrimaryTextColor,
                    fontSize: FCStyle.mediumFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
