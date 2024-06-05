import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/blocs/auth_bloc/auth_bloc.dart';
import '../../../../core/router/router_delegate.dart';
import '../../../../shared/popup_scaffold.dart';
import '../../../../utils/config/color_pallet.dart';
import '../../../../utils/config/famici.theme.dart';
import '../../../../utils/helpers/widget_key.dart';
import '../../../../utils/strings/common_strings.dart';
import '../blocs/medication_popup_cubit/medication_notify_cubit.dart';
import '../entity/selected_medication_details.dart';

import 'package:awesome_notifications/awesome_notifications.dart';

class LocalMedicationNotifyScreen extends StatefulWidget {
  const LocalMedicationNotifyScreen({Key? key, required this.medicationDetails})
      : super(key: key);

  final SelectedMedicationDetails medicationDetails;

  @override
  State<LocalMedicationNotifyScreen> createState() =>
      _LocalMedicationNotifyScreenState();
}

class _LocalMedicationNotifyScreenState
    extends State<LocalMedicationNotifyScreen> {
  SelectedMedicationDetails get medicationDetails => widget.medicationDetails;

  late DateTime _now = DateTime.now();
  final MedicationNotifyCubit _notifyCubit = MedicationNotifyCubit();

  @override
  void dispose() {
    AwesomeNotifications().dismissNotificationsByGroupKey(
      medicationDetails.medicationId ?? "",
    );
    super.dispose();
  }

  String message(String type, String time, int quantity) {
    Map<String, String> messages = {
      "Cream": "Did you apply cream at $time?",
      "Inhaler": "Did you take puffs at $time?",
      "Capsule": "Did you take quantity pills at $time?",
      "Oral": "Did you take drops at $time?",
      "Pill":
          "Did you take $quantity ${quantity > 1 ? 'pills' : 'pill'} at $time?",
      "Injection": "Did you take injections at $time?",
      "Tablet":
          "Did you take $quantity ${quantity > 1 ? 'pills' : 'pill'} at $time?",
      "Suppository":
          "Did you take $quantity ${quantity > 1 ? 'suppositories' : 'suppository'}  at $time?",
    };

    return messages[type] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    print('this is ntofifcation body ' + medicationDetails.toString());

    return PopupScaffold(
      height: MediaQuery.of(context).size.height - 100,
      width: MediaQuery.of(context).size.width - 100,
      onTapOutside: () {
        fcRouter.pop();
      },
      child: Stack(
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return BlocBuilder<MedicationNotifyCubit, MedicationNotifyState>(
                  bloc: _notifyCubit,
                  builder: (context, MedicationNotifyState medicNotification) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50, right: 20, top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //       children: [
                              //         Text(
                              //           DateFormat('hh:mm a').format(_now),
                              //           maxLines: 2,
                              //           softWrap: true,
                              //           textAlign: TextAlign.center,
                              //           style: TextStyle(
                              //               color:
                              //                   ColorPallet.kPrimaryTextColor,
                              //               fontSize: FCStyle.largeFontSize,
                              //               fontWeight: FontWeight.w500),
                              //         ),
                              //         Text(
                              //           DateFormat.yMMMd().format(_now),
                              //           maxLines: 2,
                              //           softWrap: true,
                              //           textAlign: TextAlign.center,
                              //           style: TextStyle(
                              //               color:
                              //                   ColorPallet.kPrimaryTextColor,
                              //               fontSize: FCStyle.mediumFontSize,
                              //               fontWeight: FontWeight.w400),
                              //         ),
                              //       ],
                              //     ),
                              //   ],
                              // ),
                              InkWell(
                                onTap: () {
                                  fcRouter.pop();
                                },
                                child: Icon(Icons.close,
                                    color: ColorPallet.kPrimaryTextColor,
                                    size: FCStyle.blockSizeVertical * 10),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: FCStyle.blockSizeVertical * 3,
                        ),
                        CachedNetworkImage(
                          height: FCStyle.blockSizeVertical * 15,
                          fit: BoxFit.fitHeight,
                          imageUrl:
                              medicationDetails.medicationTypeImageUrl ?? "",
                          //httpHeaders: {"Authorization": "Bearer $token}"},
                          placeholder: (context, url) => Container(
                            child: Shimmer.fromColors(
                                baseColor: ColorPallet.kWhite,
                                highlightColor: ColorPallet.kPrimaryGrey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Icon(
                                        Icons.photo,
                                        size: FCStyle.blockSizeVertical * 15,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          errorWidget: (context, url, error) => Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: FCStyle.blockSizeVertical * 15,
                                    color: ColorPallet.kWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          fadeInCurve: Curves.easeIn,
                          fadeInDuration: const Duration(milliseconds: 100),
                        ),
                        SizedBox(
                          height: FCStyle.blockSizeVertical * 2,
                        ),
                        Text(
                          "Have you taken ${medicationDetails.medicationName} ?" ??
                              "",
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorPallet.kPrimaryTextColor,
                              fontSize: FCStyle.largeFontSize,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: FCStyle.blockSizeVertical * 5,
                        ),
                        // Text(
                        //   message(
                        //     medicationDetails.medicationType ?? "",
                        //     DateFormat("hh:mm a").format(
                        //       DateFormat("HH:mm").parse(
                        //           medicationDetails.dosageList?[0].time ??
                        //               "12:00"),
                        //     ),
                        //     int.parse(medicationDetails
                        //             .dosageList?[0].quantity.value ??
                        //         '1'),
                        //   ),
                        //   maxLines: 2,
                        //   softWrap: true,
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //       color: ColorPallet.kPrimaryTextColor,
                        //       fontSize: FCStyle.largeFontSize + 5,
                        //       fontWeight: FontWeight.w700),
                        // ),
                        // SizedBox(
                        //   height: FCStyle.blockSizeVertical * 3,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            NeumorphicButton(
                              key: FCElementID.yesButton,
                              onPressed: () {
                                _notifyCubit.updateTakenStatusLocal(
                                    state.user.familyId ?? "",
                                    medicationDetails.medicationId ?? "",
                                    medicationDetails.dosageList?[0].id ?? "",
                                    true);

                                List<RouteData> routeData = fcRouter.stackData;
                                for (var route in routeData) {
                                  if ("MedicationDetailsRoute" == route.name) {
                                    fcRouter.popUntilRouteWithName(
                                        "MedicationDetailsRoute");
                                    break;
                                  }
                                }

                                fcRouter.popAndPush(MedicationDetailsRoute());
                              },
                              style: FCStyle.greenButtonStyle,
                              child: Container(
                                width: 120,
                                height: 48.0,
                                alignment: Alignment.center,
                                child: Text(
                                  CommonStrings.yes.tr(),
                                  style: TextStyle(
                                    color: ColorPallet.kBackButtonTextColor,
                                    fontSize: FCStyle.mediumFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 96.0),
                            NeumorphicButton(
                              key: FCElementID.noButton,
                              onPressed: () async {
                                _notifyCubit.updateTakenStatusLocal(
                                    state.user.familyId ?? "",
                                    medicationDetails.medicationId ?? "",
                                    medicationDetails.dosageList?[0].id ?? "",
                                    false);
                                List<RouteData> routeData = fcRouter.stackData;
                                for (var route in routeData) {
                                  if ("MedicationDetailsRoute" == route.name) {
                                    fcRouter.popUntilRouteWithName(
                                        "MedicationDetailsRoute");
                                    break;
                                  }
                                }

                                fcRouter.popAndPush(MedicationDetailsRoute());
                              },
                              style: FCStyle.redButtonStyle,
                              child: Container(
                                width: 120,
                                height: 48.0,
                                alignment: Alignment.center,
                                child: Text(
                                  CommonStrings.no.tr(),
                                  style: TextStyle(
                                    color: ColorPallet.kBackButtonTextColor,
                                    fontSize: FCStyle.mediumFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        BlocBuilder<MedicationNotifyCubit,
                            MedicationNotifyState>(
                          bloc: _notifyCubit,
                          builder: (context,
                              MedicationNotifyState medicNotification) {
                            return Text(
                              medicNotification.dosage.detail,
                              maxLines: 2,
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorPallet.kPrimaryTextColor,
                                  fontSize: FCStyle.mediumFontSize + 6,
                                  fontWeight: FontWeight.w400),
                            );
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
          // Container(
          //   alignment: Alignment.bottomRight,
          //   margin: EdgeInsets.all(20),
          //   child: NeumorphicButton(
          //     style: FCStyle.primaryButtonStyle,
          //     onPressed: () {
          //       fcRouter.pop();
          //
          //       fcRouter.navigate(MedicationDetailsRoute());
          //     },
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         SizedBox(
          //           width: FCStyle.blockSizeHorizontal * 15,
          //           height: FCStyle.blockSizeVertical * 10,
          //           child: Center(
          //             child: Text(
          //               MedicationStrings.viewMedicationDetails.tr(),
          //               textAlign: TextAlign.center,
          //               style: TextStyle(
          //                 color: ColorPallet.kPrimaryTextColor,
          //                 fontWeight: FontWeight.w400,
          //                 fontSize: FCStyle.mediumFontSize,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
