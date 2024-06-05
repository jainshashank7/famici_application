import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../../../utils/config/color_pallet.dart';

class DeviceStatusIndicator extends StatelessWidget {
  const DeviceStatusIndicator({Key? key, this.connected, this.size})
      : super(key: key);
  final bool? connected;
  final double? size;
  @override
  Widget build(BuildContext context) {
    if (connected == null) {
      return SizedBox.shrink();
    } else if (connected!) {
      return Container(
        padding: EdgeInsets.all(2.0),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: ColorPallet.kGreen),
        child: Icon(
          Icons.check,
          color: ColorPallet.kWhite,
          size: size,
        ),
      );
    }
    return Container(
      padding: EdgeInsets.all(2.0),
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: ColorPallet.kRed),
      child: Icon(
        Icons.close,
        color: ColorPallet.kWhite,
        size: size,
      ),
    );
  }
}
