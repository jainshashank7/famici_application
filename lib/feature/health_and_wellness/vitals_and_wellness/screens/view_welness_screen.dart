import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livecare/livecare.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/blocs/vitals_and_wellness_bloc.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/entity/vital.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/screens/barrel.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/device_type_icon.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/vital_device_list_item.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/vital_reading.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/wellness_reading.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/wellness_type_icon.dart';
import 'package:famici/feature/vitals/blocs/vital_sync_bloc/vital_sync_bloc.dart';
import 'package:famici/feature/vitals/entities/vital_device.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/strings/vitals_and_wellness_strings.dart';

import '../../../../core/router/router_delegate.dart';
import '../../../../shared/close_icon_button.dart';
import '../../../../shared/popup_scaffold.dart';
import '../../../../utils/barrel.dart';
import '../../../../utils/helpers/events_track.dart';
import '../../../vitals/blocs/vital_history_bloc/vital_history_bloc.dart';

class ViewWellnessScreen extends StatelessWidget {
  const ViewWellnessScreen({
    Key? key,
    required this.vital,
  }) : super(key: key);

  final Vital vital;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VitalsAndWellnessScreen(),
        PopupScaffold(
          bodyColor: Color.fromARGB(255, 255, 255, 255),
          constrained: false,
          width: 996 * FCStyle.fem,
          height: 630 * FCStyle.fem,
          backgroundColor: Color.fromARGB(138, 0, 0, 0),
          child: BlocBuilder<VitalsAndWellnessBloc, VitalsAndWellnessState>(
              builder: (context, vitalState) {
            Vital _vital = vitalState.wellnessList.firstWhere(
              (el) => el.vitalType == vital.vitalType,
            );
            return Container(
              // child: Stack(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 16.0,
              //         vertical: 24.0,
              //       ),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               BlocBuilder<VitalsAndWellnessBloc,
              //                   VitalsAndWellnessState>(
              //                 builder: (context, vitalState) {
              //                   Vital _vital =
              //                       vitalState.wellnessList.firstWhere(
              //                     (el) => el.vitalType == vital.vitalType,
              //                   );
              //                   if (_vital.connectedDevices.isEmpty) {
              //                     return DeviceListItem(
              //                       device: VitalDevice(
              //                         deviceName: VitalsAndWellnessStrings
              //                             .disconnected
              //                             .tr(),
              //                         deviceType: vital.vitalType,
              //                       ),
              //                       connected: false,
              //                       isSelection: false,
              //                     );
              //                   }
              //                   return DeviceListItem(
              //                     device: _vital.connectedDevices.first,
              //                     connected:
              //                         _vital.connectedDevices.first.connected,
              //                   );
              //                 },
              //               ),
              //               SizedBox(height: 24.0),
              //               FCMaterialButton(
              //                 onPressed: () {
              //                   fcRouter.navigate(AddDevicesRoute());
              //                 },
              //                 child: Padding(
              //                   padding: EdgeInsets.symmetric(
              //                     horizontal: 32.w,
              //                   ),
              //                   child: Column(
              //                     children: [
              //                       Icon(
              //                         Icons.add_circle,
              //                         color: ColorPallet.kPrimaryTextColor,
              //                       ),
              //                       Text(
              //                         'Add a device',
              //                         style: FCStyle.textStyle,
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               )
              //             ],
              //           ),
              //           BlocBuilder<VitalsAndWellnessBloc,
              //               VitalsAndWellnessState>(
              //             builder: (context, vitalState) {
              //               Vital _vital = vitalState.wellnessList.firstWhere(
              //                 (el) => el.vitalType == vital.vitalType,
              //               );
              //               return Column(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text(
              //                     _vital.name!,
              //                     style: FCStyle.textStyle.copyWith(
              //                       fontSize: FCStyle.largeFontSize,
              //                     ),
              //                   ),
              //                   WellnessVitalSubtitle(vital: _vital),
              //                   SizedBox(height: 12.0),
              //                   Transform.scale(
              //                     child: WellnessTypeIcon(
              //                       type: _vital.vitalType,
              //                       size: FCStyle.largeFontSize * 4,
              //                     ),
              //                     scale: 1.4,
              //                   ),
              //                   SizedBox(height: 12.0),
              //                   WellnessReading(
              //                     wellness: _vital,
              //                     forceSingleLine: true,
              //                   ),
              //                   WellnessViewTimeAgoWithError(vital: _vital),
              //                 ],
              //               );
              //             },
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(right: 16.0),
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 FCMaterialButton(
              //                   onPressed: () {
              //                     fcRouter
              //                         .navigate(ManualEntryRoute(vital: vital));
              //                   },
              //                   child: Text(
              //                     'Manual Entry',
              //                     style: FCStyle.textStyle,
              //                   ),
              //                 ),
              //                 SizedBox(height: 24.0),
              //                 FCMaterialButton(
              //                   onPressed: () {
              //                     context
              //                         .read<VitalHistoryBloc>()
              //                         .add(SyncSelectedVital(vital.vitalType));
              //                     fcRouter.replace(HistoryDataRoute());
              //                   },
              //                   child: Text(
              //                     'Historic Data',
              //                     style: FCStyle.textStyle,
              //                   ),
              //                 )
              //               ],
              //             ),
              //           )
              //         ],
              //       ),
              //     ),

              //   ],

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      width: 996 * FCStyle.fem,
                      height: 140 * FCStyle.fem,
                      padding: EdgeInsets.only(left: 20, right: 20, top: 0),
                      decoration: BoxDecoration(
                        color: ColorPallet.kPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _vital.name!,
                                style: FCStyle.textStyle.copyWith(
                                    fontSize: 45 * FCStyle.fem,
                                    fontWeight: FontWeight.w600),
                              ),
                              // ViewVitalSubtitle(vital: _vital),
                            ],
                          ),
                          Container(
                            child: TextButton(
                              onPressed: () {
                                fcRouter.pop();
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: CircleAvatar(
                                backgroundColor: const Color(0xFFAC2734),
                                radius: 25 * FCStyle.fem,
                                child: SvgPicture.asset(
                                  AssetIconPath.closeIcon,
                                  width: 30 * FCStyle.fem,
                                  height: 30 * FCStyle.fem,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 45.0, horizontal: 25),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (vital.vitalType != VitalType.fallDetection)
                                FCMaterialButton(
                                  elevation: 0,
                                  color: Colors.white,
                                  isBorder: true,
                                  borderColor: ColorPallet.kPrimary,
                                  defaultSize: true,
                                  borderRadius: BorderRadius.circular(8),
                                  onPressed: () {
                                    var properties = TrackEvents()
                                        .setProperties(
                                            fromDate: '',
                                            toDate: '',
                                            reading: '',
                                            readingDateTime: '',
                                            vital: vital.name,
                                            appointmentDate: '',
                                            appointmentTime: '',
                                            appointmentCounselors: '',
                                            appointmentType: '',
                                            callDuration: '',
                                            readingType: '');

                                    TrackEvents().trackEvents(
                                        'Manual Entry Clicked', properties);
                                    fcRouter.navigate(
                                        ManualEntryRoute(vital: vital));
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            VitalIcons.manualEntry,
                                            width: 25 * FCStyle.fem,
                                            color: ColorPallet.kPrimary,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Manual Entry',
                                            style: FCStyle.textStyle.copyWith(
                                                fontSize: 20 * FCStyle.fem,
                                                color: ColorPallet.kPrimary,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      )),
                                ),
                              if (vital.vitalType != VitalType.fallDetection)
                                SizedBox(height: 16.0),
                              FCMaterialButton(
                                elevation: 0,
                                isBorder: false,
                                color: ColorPallet.kPrimary,
                                defaultSize: true,
                                borderRadius: BorderRadius.circular(8),
                                onPressed: () {
                                  var properties = TrackEvents().setProperties(
                                      fromDate: '',
                                      toDate: '',
                                      reading: '',
                                      readingDateTime: '',
                                      vital: vital.name,
                                      appointmentDate: '',
                                      appointmentTime: '',
                                      appointmentCounselors: '',
                                      appointmentType: '',
                                      callDuration: '',
                                      readingType: '');

                                  TrackEvents().trackEvents(
                                      'Historic Data Clicked', properties);
                                  context.read<VitalHistoryBloc>().add(
                                      SyncSelectedVital(vital.vitalType,
                                          isRefreshed: false));
                                  fcRouter.replace(HistoryDataRoute());
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          VitalIcons.histoicData,
                                          width: 25 * FCStyle.fem,
                                          color: ColorPallet.kPrimaryText,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Historic Data',
                                          style: FCStyle.textStyle.copyWith(
                                              fontSize: 20 * FCStyle.fem,
                                              color: ColorPallet.kPrimaryText,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Text(
                              //   _vital.name!,
                              //   style: FCStyle.textStyle.copyWith(
                              //     fontSize: FCStyle.largeFontSize,
                              //   ),
                              // ),
                              // ViewVitalSubtitle(vital: _vital),
                              // SizedBox(height: 12.0),
                              // Transform.scale(
                              DeviceTypeIcon(
                                  type: _vital.vitalType,
                                  size: 141 * FCStyle.fem,
                                  color: ColorPallet.kPrimary),
                              // scale: 1.4,
                              // ),
                              SizedBox(height: 12.0),
                              WellnessReading(
                                wellness: _vital,
                                unitTextStyle: TextStyle(
                                  color: ColorPallet.kPrimary,
                                  fontFamily: 'roboto',
                                  fontSize: 60 * FCStyle.fem,
                                  fontWeight: FontWeight.w700,
                                ),
                                forceSingleLine: true,
                                textStyle: TextStyle(
                                    color: ColorPallet.kPrimary,
                                    fontFamily: 'roboto',
                                    fontSize: 60 * FCStyle.fem,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              WellnessViewTimeAgoWithError(
                                vital: _vital,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              bottom: 40 * FCStyle.fem, left: 8, right: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(20 * FCStyle.fem),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(30, 108, 106, 116),
                                    spreadRadius: 10,
                                    blurRadius: 30)
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BlocBuilder<VitalsAndWellnessBloc,
                                  VitalsAndWellnessState>(
                                builder: (context, vitalState) {
                                  Vital _vital =
                                      vitalState.wellnessList.firstWhere(
                                    (el) => el.vitalType == vital.vitalType,
                                  );
                                  if (_vital.connectedDevices.isEmpty) {
                                    return DeviceListItem(
                                      device: VitalDevice(
                                        deviceName: VitalsAndWellnessStrings
                                            .disconnected
                                            .tr(),
                                        deviceType: vital.vitalType,
                                      ),
                                      connected: false,
                                      isSelection: false,
                                    );
                                  }
                                  return DeviceListItem(
                                    device: _vital.connectedDevices.first,
                                    connected:
                                        _vital.connectedDevices.first.connected,
                                  );
                                },
                              ),
                              FCMaterialButton(
                                elevation: 0,
                                isBorder: false,
                                color: ColorPallet.kPrimary,
                                defaultSize: true,
                                borderRadius: BorderRadius.circular(8),
                                onPressed: () {
                                  var properties = TrackEvents().setProperties(
                                      fromDate: '',
                                      toDate: '',
                                      reading: '',
                                      readingDateTime: '',
                                      vital: vital.name,
                                      appointmentDate: '',
                                      appointmentTime: '',
                                      appointmentCounselors: '',
                                      appointmentType: '',
                                      callDuration: '',
                                      readingType: '');

                                  TrackEvents().trackEvents(
                                      'Add a Device Clicked', properties);
                                  fcRouter.navigate(AddDevicesRoute());
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25.w, vertical: 5),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        VitalIcons.addDevice,
                                        color: ColorPallet.kPrimaryText,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Add a device',
                                        style: FCStyle.textStyle.copyWith(
                                          color: ColorPallet.kPrimaryText,
                                          fontSize: 18 * FCStyle.fem,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  //   Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       BlocBuilder<VitalsAndWellnessBloc,
                  //           VitalsAndWellnessState>(
                  //         builder: (context, vitalState) {
                  //           Vital _vital = vitalState.vitalList.firstWhere(
                  //             (el) => el.vitalType == vital.vitalType,
                  //           );
                  //           if (_vital.connectedDevices.isEmpty) {
                  //             return DeviceListItem(
                  //               device: VitalDevice(
                  //                 deviceName: VitalsAndWellnessStrings
                  //                     .disconnected
                  //                     .tr(),
                  //                 deviceType: vital.vitalType,
                  //               ),
                  //               connected: false,
                  //               isSelection: false,
                  //             );
                  //           }
                  //           return DeviceListItem(
                  //             device: _vital.connectedDevices.first,
                  //             connected:
                  //                 _vital.connectedDevices.first.connected,
                  //           );
                  //         },
                  //       ),
                  //       SizedBox(height: 24.0),
                  //       FCMaterialButton(
                  //         onPressed: () {
                  //           fcRouter.navigate(AddDevicesRoute());
                  //         },
                  //         child: Padding(
                  //           padding: EdgeInsets.symmetric(horizontal: 32.w),
                  //           child: Column(
                  //             children: [
                  //               Icon(
                  //                 Icons.add_circle,
                  //                 color: ColorPallet.kPrimaryTextColor,
                  //                 size: FCStyle.mediumFontSize,
                  //               ),
                  //               Text(
                  //                 'Add a device',
                  //                 style: FCStyle.textStyle,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  //   BlocBuilder<VitalsAndWellnessBloc,
                  //       VitalsAndWellnessState>(
                  //     builder: (context, vitalState) {
                  //       Vital _vital = vitalState.vitalList.firstWhere(
                  //         (el) => el.vitalType == vital.vitalType,
                  //       );
                  //       return Column(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           // Text(
                  //           //   _vital.name!,
                  //           //   style: FCStyle.textStyle.copyWith(
                  //           //     fontSize: FCStyle.largeFontSize,
                  //           //   ),
                  //           // ),
                  //           ViewVitalSubtitle(vital: _vital),
                  //           SizedBox(height: 12.0),
                  //           Transform.scale(
                  //             child: DeviceTypeIcon(
                  //               type: _vital.vitalType,
                  //               size: FCStyle.largeFontSize * 4,
                  //             ),
                  //             scale: 1.4,
                  //           ),
                  //           SizedBox(height: 12.0),
                  //           VitalReading(
                  //             vital: _vital,
                  //             forceSingleLine: true,
                  //           ),
                  //           VitalViewTimeAgoWithError(vital: _vital),
                  //         ],
                  //       );
                  //     },
                  //   ),
                  //   Padding(
                  //     padding: const EdgeInsets.only(right: 16.0),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         if (vital.vitalType != VitalType.fallDetection)
                  //           FCMaterialButton(
                  //             onPressed: () {
                  //               fcRouter
                  //                   .navigate(ManualEntryRoute(vital: vital));
                  //             },
                  //             child: Text(
                  //               'Manual Entry',
                  //               style: FCStyle.textStyle,
                  //             ),
                  //           ),
                  //         if (vital.vitalType != VitalType.fallDetection)
                  //           SizedBox(height: 24.0),
                  //         FCMaterialButton(
                  //           onPressed: () {
                  //             context
                  //                 .read<VitalHistoryBloc>()
                  //                 .add(SyncSelectedVital(vital.vitalType));
                  //             fcRouter.replace(HistoryDataRoute());
                  //           },
                  //           child: Text(
                  //             'Historic Data',
                  //             style: FCStyle.textStyle,
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   )
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class WellnessViewTimeAgoWithError extends StatelessWidget {
  const WellnessViewTimeAgoWithError({
    Key? key,
    required this.vital,
  }) : super(key: key);

  final Vital vital;

  int get timeDifferance {
    int dif = DateTime.now().millisecondsSinceEpoch - vital.time!;
    return Duration(milliseconds: dif).inMinutes;
  }

  bool get isConnected => vital.connected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: FCStyle.largeFontSize * 4,
      // width: FCStyle.xLargeFontSize * 6,
      child: Builder(builder: (context) {
        // if (isConnected || timeDifferance < 1) {
        //   return Column(
        //     children: [
        //       vital.count > 0
        //           ? Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   'Measured ',
        //                   style: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                   ),
        //                 ),
        //                 TimeAgoText(
        //                   startTime: vital.reading.readAt,
        //                   textStyle: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                   ),
        //                 ),
        //               ],
        //             )
        //           : Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   'Not Measured',
        //                   style: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //     ],
        //   );
        // } else if (1 < timeDifferance && timeDifferance < 3) {
        //   return Column(
        //     children: [
        //       vital.count > 0
        //           ? Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   'Measured ',
        //                   style: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                   ),
        //                 ),
        //                 TimeAgoText(
        //                   startTime: vital.reading.readAt,
        //                   textStyle: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                   ),
        //                 ),
        //               ],
        //             )
        //           : Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   'Not Measured',
        //                   style: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //     ],
        //   );
        // } else if (timeDifferance > 3) {
        //   return Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       vital.count > 0
        //           ? Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   'Measured ',
        //                   style: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                   ),
        //                 ),
        //                 TimeAgoText(
        //                   startTime: vital.reading.readAt,
        //                   textStyle: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                     color: ColorPallet.kPrimaryTextColor,
        //                   ),
        //                 ),
        //               ],
        //             )
        //           : Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   'Not Measured',
        //                   style: FCStyle.textStyle.copyWith(
        //                     fontSize: 30 * FCStyle.fem,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //       SizedBox(height: 16.0),
        //       //   Text(
        //       //     'Please Connect a Device to Measure or Manually Enter a Value',
        //       //     textAlign: TextAlign.center,
        //       //     style: FCStyle.textStyle.copyWith(
        //       //       color: ColorPallet.kDarkRed,
        //       //       fontSize: FCStyle.defaultFontSize,
        //       //     ),
        //       //   )
        //     ],
        //   );
        // }
        return Container(
          child: vital.count > 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      Text(
                        'Measured ',
                        style: TextStyle(
                          fontSize: 30 * FCStyle.fem,
                        ),
                      ),
                      TimeAgoText(
                        startTime: vital.reading.readAt,
                        multiLine: true,
                        textStyle: TextStyle(
                          fontSize: 30 * FCStyle.fem,
                        ),
                      )
                    ])
              : Text(
                  "Not Measured",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30 * FCStyle.fem,
                  ),
                ),
        );
      }),
    );
  }
}

class WellnessVitalSubtitle extends StatelessWidget {
  const WellnessVitalSubtitle({
    Key? key,
    required this.vital,
  }) : super(key: key);

  final Vital vital;

  int get timeDifferance {
    int dif = DateTime.now().millisecondsSinceEpoch - vital.time!;
    return Duration(milliseconds: dif).inMinutes;
  }

  bool get isConnected => vital.connected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: FCStyle.largeFontSize * 2,
      child: Builder(builder: (context) {
        if (isConnected || timeDifferance < 1) {
          return SizedBox.shrink();
        } else if (1 < timeDifferance && timeDifferance < 5) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Old Information',
                style: FCStyle.textStyle.copyWith(
                  color: ColorPallet.kPrimaryTextColor,
                  fontSize: FCStyle.defaultFontSize,
                ),
              ),
              Text(
                'Please Connect a Device To Measure Again',
                style: FCStyle.textStyle.copyWith(
                  color: ColorPallet.kPrimaryTextColor,
                  fontSize: FCStyle.defaultFontSize,
                ),
              ),
            ],
          );
        } else if (timeDifferance > 5) {
          return Column(
            children: [
              Text(
                'Device Disconnected',
                style: FCStyle.textStyle.copyWith(
                  color: ColorPallet.kRed,
                  fontSize: FCStyle.defaultFontSize,
                ),
              ),
            ],
          );
        }
        return SizedBox.shrink();
      }),
    );
  }
}
