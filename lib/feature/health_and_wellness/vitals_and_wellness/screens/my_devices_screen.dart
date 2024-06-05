import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/core/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/screens/barrel.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/vital_device_list_item.dart';
import 'package:famici/feature/vitals/blocs/vital_sync_bloc/vital_sync_bloc.dart';
import 'package:famici/feature/vitals/entities/vital_device.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

import '../../../../core/router/router_delegate.dart';
import '../widgets/device_status_indicator.dart';
import '../widgets/wifi_bluetooth_connectivity.dart';

class MyDevicesScreen extends StatelessWidget {
  const MyDevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VitalsAndWellnessScreen(),
        PopupScaffold(
          width: 1128 * FCStyle.fem,
          backgroundColor: Color.fromARGB(176, 0, 0, 0),
          bodyColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(10 * FCStyle.fem),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: ConnectivityStatusWidget(),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(43 * FCStyle.fem,
                      24 * FCStyle.fem, 15 * FCStyle.fem, 16 * FCStyle.fem),
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
                        margin: EdgeInsets.fromLTRB(
                            0 * FCStyle.fem,
                            0 * FCStyle.fem,
                            420 * FCStyle.fem,
                            0 * FCStyle.fem),
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
                    //   'My Devices',
                    //   style: FCStyle.textStyle.copyWith(
                    //     fontSize: FCStyle.largeFontSize,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    Container(
                      alignment: Alignment.center,
                      height: FCStyle.xLargeFontSize * 7,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: MyDevicesList(),
                      ),
                    ),
                    Container(
                      width: 230,
                      child: FCMaterialButton(
                        elevation: 0,
                        isBorder: false,
                        color: ColorPallet.kPrimary,
                        defaultSize: true,
                        borderRadius: BorderRadius.circular(8),
                        onPressed: () {
                          fcRouter.navigate(AddDevicesRoute());
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                VitalIcons.addDevice,
                                color: ColorPallet.kPrimaryText,
                                width: 28,
                              ),
                              SizedBox(
                                width: 14,
                              ),
                              Text(
                                'Add New Device',
                                style: FCStyle.textStyle.copyWith(
                                  color: ColorPallet.kPrimaryText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 23 * FCStyle.fem,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )

                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: FCPrimaryButton(
                    //     label: 'Add New Device',
                    //     onPressed: () {
                    //       fcRouter.navigate(AddDevicesRoute());
                    //     },
                    //     prefixIcon: Icons.add_circle,
                    //     prefixIconSize: FCStyle.xLargeFontSize,
                    //     padding: EdgeInsets.symmetric(
                    //       vertical: 12.0,
                    //       horizontal: 24.0,
                    //     ),
                    //     defaultSize: false,
                    //   ),
                    // ),
                  ],
                ),
                // Align(
                //   alignment: Alignment.topRight,
                //   child: CloseIconButton(
                //     size: FCStyle.largeFontSize * 2,
                //     onTap: () async {
                //       fcRouter.pop();
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MyDevicesList extends StatelessWidget {
  const MyDevicesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController _deviceListScrollController = ScrollController();
    return BlocBuilder<VitalSyncBloc, VitalSyncState>(
      builder: (context, syncState) {
        if (syncState.myDevices.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(VitalIcons.noDeviceFound),
              SizedBox(
                height: 20,
              ),
              Text(
                'No Device Yet',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 45 * FCStyle.fem,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "You don’t have any device connect yet",
                style: FCStyle.textStyle.copyWith(
                  fontSize: 25 * FCStyle.fem,
                ),
              ),
            ],
          );
        }

        return AnimationLimiter(
            child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              syncState.myDevices.length > 4
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
                  shrinkWrap: true,
                  controller: _deviceListScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: syncState.myDevices.length,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  itemBuilder: (context, int idx) {
                    VitalDevice _device =
                        syncState.myDevices.values.toList()[idx];
                    return Center(
                      child: AnimationConfiguration.staggeredList(
                        position: idx,
                        delay: Duration(milliseconds: 100),
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          horizontalOffset: 100.0,
                          child: FadeInAnimation(
                            child: DeviceListItemDummy(
                              isDismissible: true,
                              device: _device,
                              onPressed: () {},
                              onSwipeUp: () {
                                context
                                    .read<VitalSyncBloc>()
                                    .add(RemoveDeviceFromMyDevices(_device));
                              },
                              connected: _device.connected,
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
              syncState.myDevices.length > 4
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
            ]),
          ),
        ));
      },
    );
  }
}
