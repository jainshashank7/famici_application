import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livecare/livecare.dart';

import '../../../../utils/barrel.dart';
import '../entity/vital.dart';
import '../entity/wellness_entity.dart';

class WellnessTypeIcon extends StatelessWidget {
  WellnessTypeIcon(
      {Key? key, this.type = VitalType.unknown, double? size, Color? color})
      : size = size ?? FCStyle.largeFontSize * 4,
        color = color ?? ColorPallet.kPrimary,
        super(key: key);

  final VitalType type;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (type == VitalType.activity) {
      return SvgPicture.asset(VitalIcons.activity, height: size, color: color);
    }
    if (type == VitalType.sleep) {
      return SvgPicture.asset(VitalIcons.sleepHour, height: size, color: color);
    }
    if (type == VitalType.ws) {
      return SvgPicture.asset(VitalIcons.weight, height: size, color: color);
    }
    if (type == VitalType.feelingToday) {
      return Image(
          image: AssetImage(
            AssetIconPath.feelingEmojiIcon,
          ),
          height: size,
          color: color);
    }
    return Image(
        image: AssetImage(
          AssetIconPath.feelingEmojiIcon,
        ),
        height: size,
        color: color);
  }
}
