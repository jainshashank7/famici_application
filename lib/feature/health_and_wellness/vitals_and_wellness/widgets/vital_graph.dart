import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livecare/livecare.dart';

import '../../../../utils/config/color_pallet.dart';
import '../../../../utils/config/famici.theme.dart';
import '../../../../utils/constants/assets_paths.dart';
import '../entity/vital.dart';

class VitalGraphIcon extends StatelessWidget {
  VitalGraphIcon({
    Key? key,
    this.type = VitalType.unknown,
    double? size,
    Color? color,
  })  : size = size ?? 150 * FCStyle.fem,
        color = color ?? ColorPallet.kPrimary,
        super(key: key);

  final VitalType type;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (type == VitalType.bp) {
      return SvgPicture.asset(
        AssetIconPath.bloodPressureGraph,
        width: size,
        color: color,
      );
      // return Image(
      //   image: AssetImage(
      //     VitalIcons.bloodPressure,
      //   ),
      //   width: size * 1.2,
      // );
    }
    if (type == VitalType.spo2) {
      return SvgPicture.asset(
        AssetIconPath.pulseGraph,
        width: size,
        color: color,
      );
    }
    if (type == VitalType.gl) {
      return SvgPicture.asset(
        AssetIconPath.bloodSugarGraph,
        width: size,
        color: color,
      );
    }
    if (type == VitalType.heartRate) {
      return SvgPicture.asset(
        AssetIconPath.heartRateGraph,
        width: size,
        color: color,
      );
    }
    if (type == VitalType.temp) {
      return SvgPicture.asset(
        AssetIconPath.bodyTempratureGraph,
        width: size,
        color: color,
      );
    }
    if (type == VitalType.fallDetection) {
      return SvgPicture.asset(
        AssetIconPath.fallDetectionGraph,
        width: size,
        color: color,
      );
    }
    return Image(
      image: AssetImage(
        AssetIconPath.watchIconDark,
      ),
      width: size,
      color: color,
    );
  }
}
