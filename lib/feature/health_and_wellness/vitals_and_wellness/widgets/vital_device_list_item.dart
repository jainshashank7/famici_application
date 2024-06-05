import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/utils/barrel.dart';

import '../../../../shared/concave_card.dart';
import '../../../../shared/fc_confirm_dialog.dart';
import '../../../vitals/entities/vital_device.dart';
import 'device_status_indicator.dart';
import 'device_type_icon.dart';

class DeviceListItem extends StatelessWidget {
  const DeviceListItem({
    Key? key,
    required VitalDevice device,
    this.isSelected = false,
    this.isSelection = false,
    this.connected = false,
    this.onPressed,
    this.onSwipeUp,
    this.isDismissible = false,
  })  : _device = device,
        super(key: key);

  final VitalDevice _device;
  final bool isSelected;
  final bool connected;
  final bool isSelection;
  final bool isDismissible;
  final VoidCallback? onPressed;
  final VoidCallback? onSwipeUp;

  Widget dismissibleContainer({required Widget child}) {
    if (isDismissible) {
      return Container(
        child: Dismissible(
            direction: DismissDirection.up,
            onDismissed: onSwipeUp != null
                ? (direction) {
                    if (direction == DismissDirection.up) {
                      onSwipeUp!.call();
                    }
                  }
                : null,
            key: Key(
              _device.hardwareId ??
                  DateTime.now().millisecondsSinceEpoch.toString(),
            ),
            child: child),
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: dismissibleContainer(
        child: NeumorphicButton(
          onPressed: onPressed,
          minDistance: 1,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          style: FCStyle.buttonCardStyle.copyWith(
            depth: 1,
          ),
          child: Container(
            color: Colors.white,
            // depth: 6,
            // borderRadius: BorderRadius.circular(32.0),
            child: SizedBox(
              // height: FCStyle.largeFontSize * 7,
              // width: FCStyle.largeFontSize * 6,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: DeviceTypeIcon(
                              color: ColorPallet.kPrimary,
                              type: _device.deviceType,
                              size: 70)),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isDismissible)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: DeviceStatusIndicator(
                                  connected: connected,
                                ),
                              ),
                            Text(
                              _device.deviceName ?? '',
                              style: FCStyle.textStyle.copyWith(
                                  color: ColorPallet.kPrimary,
                                  fontSize: 20 * FCStyle.fem,
                                  fontWeight: FontWeight.w800),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            if (isSelection)
                              isSelected
                                  ? DeviceStatusIndicator(
                                      connected: isSelected,
                                      size: 25 * FCStyle.fem)
                                  : DeviceStatusIndicator(
                                      connected: false, size: 25 * FCStyle.fem)
                            else
                              isDismissible
                                  ? InkWell(
                                      onTap: () {
                                        onSwipeUp?.call();
                                      },
                                      customBorder: CircleBorder(),
                                      child: Container(
                                        width: 25 * FCStyle.fem,
                                        padding: EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorPallet.kRed,
                                        ),
                                        child: Icon(
                                          Icons.delete,
                                          color: ColorPallet.kWhite,
                                        ),
                                      ),
                                    )
                                  : DeviceStatusIndicator(
                                      connected: connected,
                                      size: 25 * FCStyle.fem),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeviceListItemDummy extends StatelessWidget {
  const DeviceListItemDummy({
    Key? key,
    required VitalDevice device,
    this.isSelected = false,
    this.isSelection = false,
    this.connected = false,
    this.onPressed,
    this.onSwipeUp,
    this.isDismissible = false,
  })  : _device = device,
        super(key: key);

  final VitalDevice _device;
  final bool isSelected;
  final bool connected;
  final bool isSelection;
  final bool isDismissible;
  final VoidCallback? onPressed;
  final VoidCallback? onSwipeUp;

  Widget dismissibleContainer({required Widget child}) {
    // if (isDismissible) {
    //   return Dismissible(
    //       direction: DismissDirection.up,
    //       onDismissed: onSwipeUp != null
    //           ? (direction) {
    //               if (direction == DismissDirection.up) {
    //                 onSwipeUp!.call();
    //               }
    //             }
    //           : null,
    //       key: Key(
    //         _device.hardwareId ??
    //             DateTime.now().millisecondsSinceEpoch.toString(),
    //       ),
    //       child: child);
    // }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 9.5 * FCStyle.fem),
      child: dismissibleContainer(
        child: NeumorphicButton(
          onPressed: onPressed,
          minDistance: 1,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          style: FCStyle.buttonCardStyle.copyWith(
              color: Colors.white,
              borderRadius: 20 * FCStyle.fem,
              depth: 6,
              shadowLightColor: Color.fromARGB(242, 207, 195, 225),
              shadowDarkColorEmboss: Color.fromARGB(154, 225, 223, 228),
              shadowDarkColor: Color.fromARGB(193, 181, 180, 183)),
          child: SizedBox(
            height: isSelection ? 274 * FCStyle.fem : 300 * FCStyle.fem,
            width: 216 * FCStyle.fem,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isSelection
                        ? Transform.scale(
                            scale: 1.3,
                            child: GestureDetector(
                              onTap: onPressed,
                              child: Checkbox(
                                value: isSelected,
                                onChanged: (value) {
                                  onPressed!();
                                },
                                activeColor: Colors.green,
                                fillColor:
                                    MaterialStateProperty.all(Colors.green),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    Center(
                      child: Container(
                          height: 70,
                          child: DeviceTypeIcon(
                              color: ColorPallet.kPrimary,
                              type: _device.deviceType,
                              size: 70)),
                    ),
                    Padding(
                      padding: isSelected
                          ? const EdgeInsets.only(top: 10)
                          : const EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              _device.deviceName ?? '',
                              style: TextStyle(
                                fontSize: 23 * FCStyle.fem,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: isSelection
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                              softWrap: true,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (isDismissible)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  connected ? 'Connected' : 'Disconnected',
                                  style: TextStyle(
                                    fontSize: 23 * FCStyle.fem,
                                    color: ColorPallet.kPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                DeviceStatusIndicator(
                                    connected: connected,
                                    size: 24 * FCStyle.fem),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isSelection)
                  //   isSelected
                  //       ? Positioned(
                  //           top: FCStyle.mediumFontSize,
                  //           right: FCStyle.mediumFontSize,
                  //           child: DeviceStatusIndicator(connected: isSelected),
                  //         )
                  //       : SizedBox.shrink()
                  // else
                  Positioned(
                    top: 5,
                    right: 5,
                    child: isDismissible
                        ? InkWell(
                            onTap: () {
                              showDialog(
                                  barrierColor:
                                      Color.fromARGB(0, 255, 252, 252),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor:
                                          Color.fromARGB(0, 0, 0, 0),
                                      child: FCConfirmDialog(
                                        width: 620,
                                        height: 350,
                                        message:
                                            "Are you sure you want to delete the device?",
                                      ),
                                    );
                                  }).then((value) {
                                if (value) {
                                  onSwipeUp?.call();
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorPallet.kRed,
                              ),
                              child: Icon(
                                Icons.delete,
                                color: ColorPallet.kWhite,
                              ),
                            ),
                          )
                        : DeviceStatusIndicator(connected: connected),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
