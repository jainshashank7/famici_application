import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livecare/livecare.dart';

import '../../../../utils/config/famici.theme.dart';
import '../../../../utils/constants/assets_paths.dart';
import '../entity/vital.dart';

class DeviceTypeIcon extends StatelessWidget {
  DeviceTypeIcon({
    Key? key,
    this.type = VitalType.unknown,
    double? size,
    Color? this.color,
  })  : size = size ?? FCStyle.largeFontSize * 4,
        super(key: key);

  final VitalType type;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (type == VitalType.bp) {
      return SvgPicture.asset(
        VitalIcons.bloodPressure,
        height: size * 1.2,
        color: color ?? color,
      );
      // return Image(
      //   image: AssetImage(
      //     VitalIcons.bloodPressure,
      //   ),
      //   height: size * 1.2,
      // );
    }
    if (type == VitalType.spo2) {
      return SvgPicture.asset(
        VitalIcons.pulseRate,
        height: size * 1.2,
        color: color ?? color,
      );
    }
    if (type == VitalType.gl) {
      return SvgPicture.asset(
        VitalIcons.bloodSugar,
        height: size * 1.2,
        color: color ?? color,
      );
    }
    if (type == VitalType.heartRate) {
      return SvgPicture.asset(
        VitalIcons.heartRate,
        height: size * 1.2,
        color: color ?? color,
      );
    }
    if (type == VitalType.temp) {
      return SvgPicture.asset(
        VitalIcons.temprature,
        height: size * 1.2,
        color: color ?? color,
      );
    }
    if (type == VitalType.fallDetection) {
      return SvgPicture.asset(
        VitalIcons.fallDetection,
        height: size * 1.2,
        color: color ?? color,
      );
    }
    if (type == VitalType.ws) {
      return Image(
        image: AssetImage(
          AssetIconPath.wellnessWeight,
        ),
        height: size,
        color: color ?? color,
      );
    }
    if (type == VitalType.activity) {
      return Image(
        image: AssetImage(
          AssetIconPath.activityIcon,
        ),
        height: size,
        color: color ?? color,
      );
    }
    if (type == VitalType.sleep) {
      return Image(
        image: AssetImage(
          AssetIconPath.wellnessSleep,
        ),
        height: size,
        color: color ?? color,
      );
    }
    return Image(
      image: AssetImage(
        AssetIconPath.watchIconDark,
      ),
      height: size,
      color: color ?? color,
    );
  }
}
