import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/feature/calander/blocs/manage_reminders/manage_reminders_bloc.dart';
import 'package:famici/feature/care_team/profile_photo_bloc/profile_photo_bloc.dart';
import 'package:famici/utils/barrel.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../feature/maintenance/screeen/maintainance_screen.dart';
import '../../../blocs/auth_bloc/auth_bloc.dart';
import '../../../blocs/theme_builder_bloc/theme_builder_bloc.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
        builder: (context, stateM) {
      return Container(
        margin: EdgeInsets.fromLTRB(0 * FCStyle.fem, 0 * FCStyle.fem,
            0 * FCStyle.fem, 17 * FCStyle.fem),
        padding: EdgeInsets.fromLTRB(25 * FCStyle.fem, 21 * FCStyle.fem,
            30 * FCStyle.fem, 15 * FCStyle.fem),
        width: 595 * FCStyle.fem,
        height: 130 * FCStyle.fem,
        decoration: BoxDecoration(
          color: ColorPallet.kPrimary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60 * FCStyle.fem),
            topRight: Radius.circular(10 * FCStyle.fem),
            bottomRight: Radius.circular(10 * FCStyle.fem),
            bottomLeft: Radius.circular(10 * FCStyle.fem),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x286c6974),
              offset: Offset(0 * FCStyle.fem, 10 * FCStyle.fem),
              blurRadius: 15 * FCStyle.fem,
            ),
          ],
        ),
        child: BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (prv, next) => prv.user.givenName != next.user.givenName,
            builder: (context, authState) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                        0 * FCStyle.fem, 12 * FCStyle.fem, 13 * FCStyle.fem),
                    width: 77 * FCStyle.fem,
                    height: 79 * FCStyle.fem,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0 * FCStyle.fem,
                          top: 9 * FCStyle.fem,
                          child: Container(
                            width: 70 * FCStyle.fem,
                            height: 70 * FCStyle.fem,
                            decoration: BoxDecoration(
                              color: Color(0xfffefeff),
                              borderRadius:
                                  BorderRadius.circular(10 * FCStyle.fem),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x03294898),
                                  offset: Offset(0 * FCStyle.fem,
                                      1.8518518209 * FCStyle.fem),
                                  blurRadius: 1.5740740299 * FCStyle.fem,
                                ),
                              ],
                            ),
                            child: BlocBuilder<ProfilePhotoBloc,
                                    ProfilePhotoState>(
                                builder: (context, profileState) {
                              return Center(
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(10 * FCStyle.fem),
                                  child: profileState.status
                                      ? CachedNetworkImage(
                                          height: 70 * FCStyle.fem,
                                          width: 70 * FCStyle.fem,
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              profileState.profilePhotoUrl ??
                                                  "",
                                          placeholder: (context, url) =>
                                              SizedBox(
                                            height: 70 * FCStyle.fem,
                                            child: Shimmer.fromColors(
                                                baseColor: ColorPallet.kWhite,
                                                highlightColor:
                                                    ColorPallet.kPrimaryGrey,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.photo,
                                                      size: 70 * FCStyle.fem,
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              SizedBox(
                                            height: 70 * FCStyle.fem,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.broken_image,
                                                  size: 70 * FCStyle.fem,
                                                  color: ColorPallet
                                                      .kPrimaryTextColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                          fadeInCurve: Curves.easeIn,
                                          fadeInDuration:
                                              const Duration(milliseconds: 100),
                                        )
                                      : SvgPicture.asset(
                                          AssetIconPath.avatarIcon,
                                          excludeFromSemantics: true,
                                          height: 70 * FCStyle.fem,
                                          color: Color(0xFF5057C3),
                                        ),
                                ),
                              );
                            }),
                          ),
                        ),
                        Positioned(
                          left: 57 * FCStyle.fem,
                          top: 0 * FCStyle.fem,
                          child: Align(
                            child: SizedBox(
                              width: 20 * FCStyle.fem,
                              height: 20 * FCStyle.fem,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(10 * FCStyle.fem),
                                  border: Border.all(color: Color(0xff48efba)),
                                  color: Color(0xff59ba9c),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                        14 * FCStyle.fem, 20 * FCStyle.fem, 21 * FCStyle.fem),
                    height: double.infinity,
                    width: 350 * FCStyle.fem,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<AuthBloc, AuthState>(
                          buildWhen: (prv, next) =>
                              prv.user.givenName != next.user.givenName,
                          builder: (context, authState) {
                            return Container(
                              // width: 310 * FCStyle.fem,
                              margin: EdgeInsets.fromLTRB(
                                  0 * FCStyle.fem,
                                  0 * FCStyle.fem,
                                  0 * FCStyle.fem,
                                  10 * FCStyle.fem),
                              child: Text(
                                "Hi, ${authState.user.name ?? " "}",
                                style: TextStyle(
                                  fontSize: 30 * FCStyle.ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1 * FCStyle.ffem / FCStyle.fem,
                                  color: ColorPallet.kPrimaryText,
                                ),
                              ),
                            );
                          },
                        ),
                        Text(
                          'Welcome back',
                          style: TextStyle(
                            fontSize: 22 * FCStyle.ffem,
                            fontWeight: FontWeight.w400,
                            height: 1 * FCStyle.ffem / FCStyle.fem,
                            color: ColorPallet.kPrimaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //
                  //     // fcRouter.navigate(VitalsAndWellnessRoute());
                  //     // context
                  //     //     .read<ChatProfilesBloc>()
                  //     //     .add(FetchingChatProfiles());
                  //
                  //     fcRouter.pushWidget(MaintenanceScreen());
                  //
                  //
                  //
                  //   },
                  //   style: TextButton.styleFrom(
                  //     padding: EdgeInsets.zero,
                  //   ),
                  //   child: Container(
                  //     padding: EdgeInsets.fromLTRB(8 * FCStyle.fem, 7 * FCStyle.fem,
                  //         23 * FCStyle.fem, 7 * FCStyle.fem),
                  //     height: double.infinity,
                  //     decoration: BoxDecoration(
                  //       color: Color(0x99686be6),
                  //       borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                  //     ),
                  //     child: Row(
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         Container(
                  //           margin: EdgeInsets.fromLTRB(
                  //               0 * FCStyle.fem,
                  //               0 * FCStyle.fem,
                  //               16.54 * FCStyle.fem,
                  //               13.37 * FCStyle.fem),
                  //           width: 54.46 * FCStyle.fem,
                  //           height: 66.63 * FCStyle.fem,
                  //           child: Stack(
                  //             children: [
                  //               Positioned(
                  //                 left: 12.46484375 * FCStyle.fem,
                  //                 top: 14.9342651367 * FCStyle.fem,
                  //                 child: Align(
                  //                   child: SizedBox(
                  //                     width: 42 * FCStyle.fem,
                  //                     height: 51.69 * FCStyle.fem,
                  //                     child: SvgPicture.asset(
                  //                       AssetIconPath.documentsIcon,
                  //                       width: 42 * FCStyle.fem,
                  //                       height: 51.69 * FCStyle.fem,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               Positioned(
                  //                 left: 0 * FCStyle.fem,
                  //                 top: 0 * FCStyle.fem,
                  //                 child: Align(
                  //                   child: SizedBox(
                  //                     width: 28 * FCStyle.fem,
                  //                     height: 28 * FCStyle.fem,
                  //                     child: Container(
                  //                       decoration: BoxDecoration(
                  //                         borderRadius:
                  //                             BorderRadius.circular(14 * FCStyle.fem),
                  //                         color: Color(0xffeabe66),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               Positioned(
                  //                 left: 8 * FCStyle.fem,
                  //                 top: 5 * FCStyle.fem,
                  //                 child: Align(
                  //                   child: SizedBox(
                  //                     width: 11 * FCStyle.fem,
                  //                     height: 18 * FCStyle.fem,
                  //                     child: Text(
                  //                       '2',
                  //                       textAlign: TextAlign.center,
                  //                       style: TextStyle(
                  //                         fontSize: 18 * FCStyle.ffem,
                  //                         fontWeight: FontWeight.w600,
                  //                         height: 1 * FCStyle.ffem / FCStyle.fem,
                  //                         color: Color(0xffffffff),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         Container(
                  //           margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                  //               5 * FCStyle.fem, 0 * FCStyle.fem, 2 * FCStyle.fem),
                  //           constraints: BoxConstraints(
                  //             maxWidth: 123 * FCStyle.fem,
                  //           ),
                  //           child: Text(
                  //             'Clinical \nDocuments',
                  //             style: TextStyle(
                  //               fontSize: 24 * FCStyle.ffem,
                  //               fontWeight: FontWeight.w600,
                  //               height: 1.2 * FCStyle.ffem / FCStyle.fem,
                  //               color: Color(0xffffffff),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              );
            }),
      );
    });
  }
}
