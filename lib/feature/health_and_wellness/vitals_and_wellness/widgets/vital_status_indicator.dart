import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../../../shared/time_ago_text.dart';
import '../../../../utils/config/color_pallet.dart';
import '../../../../utils/config/famici.theme.dart';
import '../../../../utils/strings/vitals_and_wellness_strings.dart';
import '../entity/vital.dart';
import 'device_status_indicator.dart';

class VitalStatusIndicator extends StatelessWidget {
  const VitalStatusIndicator({
    Key? key,
    required this.vital,
  }) : super(key: key);

  final Vital vital;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        vital.count > 0
            ? TimeAgoText(
                startTime: vital.reading.readAt,
                multiLine: true,
                textStyle: TextStyle(fontWeight: FontWeight.w700),
              )
            : Text(
                "Not Measured",
                softWrap: true,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 19.0 * FCStyle.fem,
                    fontWeight: FontWeight.w700),
              ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DeviceStatusIndicator(
              connected: vital.connected,
              size: 19.0 * FCStyle.fem,
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              vital.connected
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
