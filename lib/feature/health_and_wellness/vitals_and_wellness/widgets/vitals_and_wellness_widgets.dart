import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livecare/livecare.dart';
import 'package:famici/core/blocs/time_ago_bloc/count_down_bloc.dart';
import 'package:famici/core/router/router_delegate.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/entity/vital.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/vital_graph.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/vital_reading.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/vital_status_indicator.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/wellness_graph.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/wellness_reading.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/wellness_status_indicator.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/wellness_type_icon.dart';
import 'package:famici/feature/vitals/blocs/vital_sync_bloc/vital_sync_bloc.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/config/famici.theme.dart';
import 'package:famici/utils/strings/vitals_and_wellness_strings.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../shared/barrel.dart';
import '../../../../utils/constants/assets_paths.dart';
import '../../../../utils/helpers/events_track.dart';
import '../entity/wellness_entity.dart';
import 'device_status_indicator.dart';
import 'device_type_icon.dart';

extension VitalsAndWellnessExt on BuildContext {
  Widget myDevicesButton() {
    return ElevatedButton(
      // borderRadius: BorderRadius.circular(10),
      // color: Colors.white,
      onPressed: () {
        var properties = TrackEvents().setProperties(
            fromDate: '',
            toDate: '',
            reading: '',
            readingDateTime: '',
            vital: '',
            appointmentDate: '',
            appointmentTime: '',
            appointmentCounselors: '',
            appointmentType: '',
            callDuration: '',
            readingType: '');

        TrackEvents().trackEvents('Vitals - My Devices Clicked', properties);
        fcRouter.navigate(MyDevicesRoute());
      },
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          )),
          elevation: MaterialStatePropertyAll(20),
          shadowColor:
              MaterialStatePropertyAll(Color.fromARGB(87, 41, 72, 152)),
          alignment: Alignment.center,
          backgroundColor: MaterialStatePropertyAll(Colors.white)),
      // defaultSize: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 13),
        child: Text(
          VitalsAndWellnessStrings.myDevices.tr(),
          textAlign: TextAlign.center,
          style: FCStyle.textStyle.copyWith(
              fontFamily: 'roboto',
              fontSize: 20 * FCStyle.fem,
              fontWeight: FontWeight.bold,
              color: ColorPallet.kPrimary),
        ),
      ),
    );
  }

  Widget vitalItem(Vital vital) {
    return NeumorphicButton(
        key: ValueKey('vitalItemButton+${vital.vitalId}'),
        style: FCStyle.buttonCardStyleWithBorderRadius(
            borderRadius: FCStyle.mediumFontSize, color: Colors.white),
        minDistance: 3,
        padding: EdgeInsets.all(FCStyle.defaultFontSize),
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

          TrackEvents().trackEvents('Vital Clicked', properties);

          fcRouter.navigate(ViewVitalRoute(vital: vital));
        },
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       vital.name!,
        //       maxLines: 2,
        //       softWrap: true,
        //       textAlign: TextAlign.center,
        //       style: TextStyle(
        //         color: ColorPallet.kPrimaryTextColor,
        //         fontSize: FCStyle.mediumFontSize,
        //         fontWeight: FontWeight.w700,
        //       ),
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.only(right: 12.0),
        //           child: DeviceTypeIcon(
        //             type: vital.vitalType,
        //             size: FCStyle.largeFontSize * 2,
        //           ),
        //         ),
        //         VitalReading(vital: vital)
        //       ],
        //     ),
        //     BlocBuilder<VitalSyncBloc, VitalSyncState>(
        //       builder: (context, vitalState) {
        //         return VitalStatusIndicator(vital: vital);
        //       },
        //     ),
        //   ],
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vital.name!,
                        maxLines: 1,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'roboto',
                            fontSize: 29 * FCStyle.fem,
                            fontWeight: FontWeight.w600),
                      ),
                      VitalReading(
                        unitTextStyle: TextStyle(
                          color: ColorPallet.kPrimary,
                          fontFamily: 'roboto',
                          fontSize: 25 * FCStyle.fem,
                          fontWeight: FontWeight.w700,
                        ),
                        textStyle: TextStyle(
                            color: ColorPallet.kPrimary,
                            fontFamily: 'roboto',
                            fontSize: 45 * FCStyle.fem,
                            fontWeight: FontWeight.w700),
                        vital: vital,
                        forceSingleLine: true,
                      ),
                      VitalGraphIcon(type: vital.vitalType),
                    ],
                  ),
                  // Stack(
                  //   children: [
                  //     Container(
                  //       width: 116 * FCStyle.fem,
                  //       height: 116 * FCStyle.fem,
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(100),
                  //           color: Color.fromARGB(25, 81, 85, 195)),
                  //     ),
                  //     DeviceTypeIcon(
                  //       type: vital.vitalType,
                  //       size: 53 * FCStyle.fem,
                  //     ),
                  //   ],
                  // )
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          //photo
                          CircleAvatar(
                            radius: 60 * FCStyle.fem,
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(100),
                            //     color: Color.fromARGB(25, 81, 85, 195)),
                            backgroundColor:
                                ColorPallet.kPrimary.withOpacity(0.14),
                          ),
                          CircleAvatar(
                            radius: 50 * FCStyle.fem,
                            backgroundColor:
                                ColorPallet.kPrimary.withOpacity(0.2),
                          ),
                          DeviceTypeIcon(
                            type: vital.vitalType,
                            color: ColorPallet.kPrimary,
                            size: 44 * FCStyle.fem,
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            BlocBuilder<VitalSyncBloc, VitalSyncState>(
              builder: (context, vitalState) {
                return VitalStatusIndicator(vital: vital);
              },
            )
          ],
        ));

    // child: Text('hello'));
  }

  Widget wellnessItem(Vital wellness) {
    return NeumorphicButton(
        key: ValueKey('wellnessItemButton+${wellness.vitalId}'),
        style: FCStyle.buttonCardStyleWithBorderRadius(
            borderRadius: FCStyle.mediumFontSize, color: Colors.white),
        minDistance: 3,
        onPressed: () {
          var properties = TrackEvents().setProperties(
              fromDate: '',
              toDate: '',
              reading: '',
              readingDateTime: '',
              vital: wellness.name,
              appointmentDate: '',
              appointmentTime: '',
              appointmentCounselors: '',
              appointmentType: '',
              callDuration: '',
              readingType: '');

          TrackEvents().trackEvents('Wellness Clicked', properties);
          if (wellness.vitalType != VitalType.feelingToday) {
            fcRouter.navigate(ViewWellnessRoute(vital: wellness));
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wellness.name!,
                        maxLines: 1,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'roboto',
                            fontSize: 29 * FCStyle.fem,
                            fontWeight: FontWeight.w600),
                      ),
                      WellnessReading(
                        unitTextStyle: TextStyle(
                          color: ColorPallet.kPrimary,
                          fontFamily: 'roboto',
                          fontSize: 25 * FCStyle.fem,
                          fontWeight: FontWeight.w700,
                        ),
                        textStyle: TextStyle(
                            color: ColorPallet.kPrimary,
                            fontFamily: 'roboto',
                            fontSize: 45 * FCStyle.fem,
                            fontWeight: FontWeight.w700),
                        wellness: wellness,
                        forceSingleLine: true,
                      ),
                      WellnessGraphIcon(type: wellness.vitalType),
                    ],
                  ),
                  // Stack(
                  //   children: [
                  //     Container(
                  //       width: 116 * FCStyle.fem,
                  //       height: 116 * FCStyle.fem,
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(100),
                  //           color: Color.fromARGB(25, 81, 85, 195)),
                  //     ),
                  //     DeviceTypeIcon(
                  //       type: vital.vitalType,
                  //       size: 53 * FCStyle.fem,
                  //     ),
                  //   ],
                  // )
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          //photo
                          CircleAvatar(
                            radius: 60 * FCStyle.fem,
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(100),
                            //     color: Color.fromARGB(25, 81, 85, 195)),
                            backgroundColor:
                                ColorPallet.kPrimary.withOpacity(0.14),
                          ),
                          CircleAvatar(
                            radius: 50 * FCStyle.fem,
                            backgroundColor:
                                ColorPallet.kPrimary.withOpacity(0.2),
                          ),
                          WellnessTypeIcon(
                            type: wellness.vitalType,
                            size: 50 * FCStyle.fem,
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            BlocBuilder<VitalSyncBloc, VitalSyncState>(
              builder: (context, vitalState) {
                return WellnessStatusIndicator(wellness: wellness);
              },
            )
          ],
        ));

    // child: Column(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text(
    //       wellness.name!,
    //       maxLines: 1,
    //       softWrap: true,
    //       textAlign: TextAlign.center,
    //       style: TextStyle(
    //           color: Colors.black,
    //           fontFamily: 'roboto',
    //           fontSize: 27 * FCStyle.fem,
    //           fontWeight: FontWeight.w600),
    //     ),
    //     if (wellness.vitalType == VitalType.feelingToday)
    //       SizedBox(height: 16.0),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.only(right: 12.0),
    //           child: WellnessTypeIcon(
    //             type: wellness.vitalType,
    //             size: FCStyle.largeFontSize * 2,
    //           ),
    //         ),
    //         WellnessReading(wellness: wellness)
    //       ],
    //     ),
    //     if (wellness.vitalType != VitalType.feelingToday &&
    //         wellness.vitalType != VitalType.unknown)
    //       BlocBuilder<VitalSyncBloc, VitalSyncState>(
    //         builder: (context, vitalState) {
    //           return WellnessStatusIndicator(wellness: wellness);
    //         },
    //       )
    //   ],
    // ),
  }
}
