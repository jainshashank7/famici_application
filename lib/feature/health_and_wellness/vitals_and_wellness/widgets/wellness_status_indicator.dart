import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../../../shared/time_ago_text.dart';
import '../../../../utils/barrel.dart';
import '../../../../utils/strings/vitals_and_wellness_strings.dart';
import '../entity/vital.dart';
import '../entity/wellness_entity.dart';
import 'device_status_indicator.dart';

class WellnessStatusIndicator extends StatelessWidget {
  const WellnessStatusIndicator({
    Key? key,
    required this.wellness,
  }) : super(key: key);

  final Vital wellness;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        wellness.count > 0
            ? TimeAgoText(
                startTime: wellness.reading.readAt,
                multiLine: true,
                textStyle: TextStyle(fontWeight: FontWeight.w700),
              )
            : Text(
                "Not Measured",
                softWrap: true,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                    color: ColorPallet.kPrimaryTextColor,
                    fontSize: 19 * FCStyle.fem,
                    fontWeight: FontWeight.w600),
              ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DeviceStatusIndicator(
              connected: wellness.connected,
              size: 19.0 * FCStyle.fem,
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              wellness.connected
                  ? VitalsAndWellnessStrings.connected.tr()
                  : VitalsAndWellnessStrings.disconnected.tr(),
              softWrap: true,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                color: Colors.black,
                fontSize: (20 * FCStyle.fem),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        )
      ],
    );
  }
}
