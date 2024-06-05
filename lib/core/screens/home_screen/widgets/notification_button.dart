part of 'barrel.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({
    int? count,
    Key? key,
  })  : _count = count ?? 0,
        super(key: key);
  final int _count;
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      minDistance: 3,
      key: FCElementID.homeScreenNotificationBtnKey,
      onPressed: () {
        // context.read<AppBloc>().add(EnableLock());
      },
      style: FCStyle.buttonCardStyle.copyWith(
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        border: NeumorphicBorder(
          color: ColorPallet.kCardDropShadowColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60.r,
              height: 60.r,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPallet.kRed,
              ),
              child: Center(
                child: FittedBox(
                  child: Text(
                    _count > 99 ? "99+" : NumberFormat.compact().format(_count),
                    style: TextStyle(
                      fontSize: FCStyle.mediumFontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Text(
              _count > 1
                  ? CommonStrings.notifications.tr()
                  : CommonStrings.notification.tr(),
              style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontSize: FCStyle.defaultFontSize,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
