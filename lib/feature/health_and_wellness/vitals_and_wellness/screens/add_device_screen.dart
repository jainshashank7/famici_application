import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livecare/livecare.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/screens/barrel.dart';
import 'package:famici/feature/vitals/blocs/vital_sync_bloc/vital_sync_bloc.dart';
import 'package:famici/feature/vitals/entities/vital_device.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

import '../../../../core/router/router_delegate.dart';
import '../widgets/vital_device_list_item.dart';
import '../widgets/wifi_bluetooth_connectivity.dart';

class AddDevicesScreen extends StatefulWidget {
  const AddDevicesScreen({Key? key}) : super(key: key);

  @override
  State<AddDevicesScreen> createState() => _AddDevicesScreenState();
}

class _AddDevicesScreenState extends State<AddDevicesScreen> {
  @override
  void initState() {
    context.read<VitalSyncBloc>().add(SelectDeviceToAdd(VitalDevice()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VitalsAndWellnessScreen(),
        PopupScaffold(
          width: 1128 * FCStyle.fem,
          backgroundColor: Color.fromARGB(147, 0, 0, 0),
          bodyColor: Colors.white,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: ConnectivityStatusWidget(),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(43 * FCStyle.fem, 24 * FCStyle.fem,
                    15 * FCStyle.fem, 16 * FCStyle.fem),
                width: double.infinity,
                height: 95 * FCStyle.fem,
                decoration: BoxDecoration(
                  color: ColorPallet.kPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                          0 * FCStyle.fem, 420 * FCStyle.fem, 0 * FCStyle.fem),
                      child: Text(
                        'My Devices',
                        style: TextStyle(
                          fontSize: 45 * FCStyle.ffem,
                          fontWeight: FontWeight.w600,
                          height: 1 * FCStyle.ffem / FCStyle.fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                          0 * FCStyle.fem, 0 * FCStyle.fem, 1 * FCStyle.fem),
                      child: TextButton(
                        onPressed: () {
                          fcRouter.pop();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFFAC2734),
                          radius: 35 * FCStyle.fem,
                          child: SvgPicture.asset(
                            AssetIconPath.closeIcon,
                            width: 35 * FCStyle.fem,
                            height: 35 * FCStyle.fem,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text(
                  //   'Select A Device',
                  //   style: FCStyle.textStyle.copyWith(
                  //     fontSize: FCStyle.largeFontSize,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // SizedBox(height: 24.0),
                  Container(
                    alignment: Alignment.center,
                    height: FCStyle.xLargeFontSize * 7,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: AvailableDevices(),
                    ),
                  ),
                  BlocBuilder<VitalSyncBloc, VitalSyncState>(
                    builder: (context, vitalSyncState) {
                      if (vitalSyncState.selectedAvailableDevice.hardwareId ==
                          null) {
                        // return Container(
                        //   width: 165,
                        //   child: FCMaterialButton(
                        //     elevation: 0,
                        //     isBorder: false,
                        //     color: ColorPallet.kPrimary,
                        //     defaultSize: true,
                        //     borderRadius: BorderRadius.circular(8),
                        //     onPressed: () {
                        //       fcRouter.navigate(AddDevicesRoute());
                        //     },
                        //     child: Padding(
                        //       padding: EdgeInsets.symmetric(
                        //           horizontal: 25, vertical: 15),
                        //       child: Row(
                        //         children: [
                        //           Text(
                        //             'Add Device',
                        //             style: FCStyle.textStyle.copyWith(
                        //               color: Colors.white,
                        //               fontWeight: FontWeight.w700,
                        //               fontSize: 23 * FCStyle.fem,
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 5,
                        //           ),
                        //           Icon(
                        //             Icons.arrow_forward_ios_outlined,
                        //             color: Colors.white,
                        //             size: 26,
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // );

                        return SizedBox.shrink();

                        // Padding(
                        //   padding: const EdgeInsets.all(16.0),
                        //   child: FCPrimaryButton(
                        //     label: CommonStrings.done.tr(),
                        //     color: ColorPallet.kGrey.withOpacity(0.4),
                        //     labelColor: ColorPallet.kGrey.withOpacity(0.8),
                        //     padding: EdgeInsets.symmetric(
                        //       vertical: 12.0,
                        //       horizontal: 24.0,
                        //     ),
                        //     defaultSize: false,
                        //   ),
                        // );
                      } else
                        return Container(
                          width: 160,
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          child: FCMaterialButton(
                            elevation: 0,
                            isBorder: false,
                            color: ColorPallet.kPrimary,
                            defaultSize: true,
                            borderRadius: BorderRadius.circular(8),
                            onPressed: () async {
                              context
                                  .read<VitalSyncBloc>()
                                  .add(AddToMyDevice());
                              fcRouter.pop();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              child: Row(
                                children: [
                                  Text(
                                    'Add Device',
                                    style: FCStyle.textStyle.copyWith(
                                      color: ColorPallet.kPrimaryText,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 23 * FCStyle.fem,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: ColorPallet.kPrimaryText,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );

                      // Padding(
                      //   padding: const EdgeInsets.all(16.0),
                      //   child: FCPrimaryButton(
                      //     label: CommonStrings.done.tr(),
                      //     onPressed: () async {
                      //       context.read<VitalSyncBloc>().add(AddToMyDevice());
                      //       fcRouter.pop();
                      //     },
                      //     color: ColorPallet.kGreen,
                      //     labelColor: ColorPallet.kWhite,
                      //     padding: EdgeInsets.symmetric(
                      //       vertical: 12.0,
                      //       horizontal: 24.0,
                      //     ),
                      //     defaultSize: false,
                      //   ),
                      // );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AvailableDevices extends StatefulWidget {
  const AvailableDevices({
    Key? key,
  }) : super(key: key);

  @override
  State<AvailableDevices> createState() => _AvailableDevicesState();
}

class _AvailableDevicesState extends State<AvailableDevices>
    with TickerProviderStateMixin {
  bool isScanning = true;
  Timer? _scanTimer;
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    _scanTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        isScanning = !isScanning;
      });
    });
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    super.dispose();
  }

  // List<VitalDevice> _deice = [
  //   VitalDevice(
  //       contactId: 'contactId',
  //       deviceName: 'deviceNamed',
  //       deviceType: VitalType.bp,
  //       connected: true,
  //       hardwareId: 'ww11'),
  //   VitalDevice(
  //       contactId: 'contactId2',
  //       deviceName: 'deviceName2',
  //       deviceType: VitalType.spo2,
  //       connected: true,
  //       hardwareId: 'ww'),
  //   VitalDevice(
  //       contactId: 'contactId2',
  //       deviceName: 'deviceName32',
  //       deviceType: VitalType.heartRate,
  //       connected: true,
  //       hardwareId: 'w1'),
  //   VitalDevice(
  //       contactId: 'contactId2',
  //       deviceName: 'deviceName3',
  //       deviceType: VitalType.sleep,
  //       connected: false,
  //       hardwareId: 'ss'),
  //   VitalDevice(
  //       contactId: 'contactId21',
  //       deviceName: 'deviceName31',
  //       deviceType: VitalType.sleep,
  //       connected: false,
  //       hardwareId: 'ss1')
  // ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VitalSyncBloc, VitalSyncState>(
        builder: (context, vitalSyncState) {
      if (vitalSyncState.availableDevices.isEmpty) {
        return Center(
          heightFactor: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isScanning)
                Text(
                  "Searching Devices...",
                  style: FCStyle.textStyle.copyWith(
                      fontSize: 35 * FCStyle.fem,
                      color: Color.fromARGB(255, 169, 174, 176)),
                ),
              SizedBox(height: 32.0),
              if (isScanning)
                Container(
                  height: 160,
                  width: 160,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ScaleTransition(
                        scale: animation,
                        child: CircleAvatar(
                          child: CircleAvatar(
                              radius: 108 * FCStyle.fem,
                              // decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(100),
                              //     color: Color.fromARGB(25, 81, 85, 195)),
                              backgroundColor:
                                  ColorPallet.kPrimary.withOpacity(0.2)),
                          radius: 113 * FCStyle.fem,
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(100),
                          //     color: Color.fromARGB(25, 81, 85, 195)),
                          backgroundColor:
                              ColorPallet.kPrimary.withOpacity(0.1),
                        ),
                      ),
                      CircleAvatar(
                        radius: 35,
                        child: Icon(
                          size: 35,
                          Icons.bluetooth,
                          color: ColorPallet.kPrimaryText,
                          weight: 700,
                        ),
                        backgroundColor: ColorPallet.kPrimary,
                      )
                    ],
                  ),
                )
              else
                Text(
                  "New Devices Not Found!",
                  style: FCStyle.textStyle.copyWith(
                    fontSize: FCStyle.mediumFontSize,
                  ),
                ),
            ],
          ),
        );
      }
      ScrollController _deviceListScrollController = ScrollController();
      return Column(
        children: [
          Text(
            "Select Your Device",
            style: FCStyle.textStyle.copyWith(
                fontSize: 35 * FCStyle.fem,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 169, 174, 176)),
          ),
          SizedBox(
            height: 20,
          ),
          AnimationLimiter(
            child: Container(
              width: double.infinity,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    vitalSyncState.availableDevices.values.toList().length > 4
                        ? GestureDetector(
                            child: SvgPicture.asset(VitalIcons.arrowLargeRight),
                            onTap: () {
                              _deviceListScrollController.animateTo(
                                  _deviceListScrollController.position.pixels -
                                      230 * FCStyle.fem,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.linear);
                            },
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      width: 20 * FCStyle.fem,
                    ),
                    Container(
                      width: 660,
                      alignment: Alignment.center,
                      child: ListView.builder(
                        controller: _deviceListScrollController,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: vitalSyncState.availableDevices.values
                            .toList()
                            .length,
                        itemBuilder: (context, int idx) {
                          Map available = vitalSyncState.availableDevices;
                          VitalDevice _device = available.values.toList()[idx];
                          VitalDevice _selected =
                              vitalSyncState.selectedAvailableDevice;
                          return Center(
                            child: AnimationConfiguration.staggeredList(
                              position: idx,
                              delay: Duration(milliseconds: 100),
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                horizontalOffset: 100.0,
                                child: FadeInAnimation(
                                  child: DeviceListItemDummy(
                                    device: _device,
                                    isSelection: true,
                                    isSelected: _selected.hardwareId ==
                                        _device.hardwareId,
                                    onPressed: () async {
                                      context
                                          .read<VitalSyncBloc>()
                                          .add(SelectDeviceToAdd(_device));
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20 * FCStyle.fem,
                    ),
                    vitalSyncState.availableDevices.values.toList().length > 4
                        ? GestureDetector(
                            onTap: () {
                              _deviceListScrollController.animateTo(
                                  _deviceListScrollController.position.pixels +
                                      230 * FCStyle.fem,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.linear);
                            },
                            child: SvgPicture.asset(VitalIcons.arrowLargeLeft))
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
