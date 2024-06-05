import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/calander/blocs/manage_appointment/manage_appointment_bloc.dart';
import 'package:famici/feature/connect_with_family/blocs/family_member/family_member_cubit.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/fc_square_button.dart';
import 'package:famici/utils/barrel.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:famici/utils/strings/appointment_strings.dart';
import 'dart:math' as math;

class AppointmentGuestsScreen extends StatefulWidget {
  const AppointmentGuestsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AppointmentGuestsScreenState createState() =>
      _AppointmentGuestsScreenState();
}

class _AppointmentGuestsScreenState extends State<AppointmentGuestsScreen> {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 48.0);
  final TextEditingController _controller = TextEditingController();

  late FamilyMemberCubit _familyMemberCubit;

  bool isTopOfList = true;
  bool isBottomOfList = true;

  late ManageAppointmentBloc _manageAppointment;

  @override
  void initState() {
    _manageAppointment = context.read<ManageAppointmentBloc>();
    _controller.text = context.read<ManageAppointmentBloc>().state.guestEmail;
    _familyMemberCubit = context.read<FamilyMemberCubit>();
    _familyMemberCubit.fetchExistingFamilyMembers();
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        isBottomOfList = true;
      });
    } else {
      setState(() {
        isBottomOfList = false;
      });
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        isTopOfList = true;
      });
    } else {
      setState(() {
        isTopOfList = false;
      });
    }
  }

  showControlsOnInit() {
    setState(() {
      isBottomOfList = false;
      isTopOfList = false;
    });
    Future.delayed(Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      setState(() {
        isBottomOfList = true;
        isTopOfList = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageAppointmentBloc, ManageAppointmentState>(
        bloc: _manageAppointment,
        builder: (context, state) {
          return Column(
            children: [
              Text(
                AppointmentStrings.addGuests.tr(),
                style: TextStyle(
                    color: ColorPallet.kPrimaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: FCStyle.largeFontSize),
              ),
              SizedBox(height: 16.0),
              BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return BlocConsumer(
                    listener:
                        (BuildContext context, FamilyMemberState memberState) {
                      if (memberState.existingMembers.isNotEmpty) {
                        showControlsOnInit();
                      }
                    },
                    bloc: _familyMemberCubit,
                    builder: (context, FamilyMemberState state) {
                      if (state.isLoading) {
                        return Center(child: LoadingScreen());
                      }

                      if (state.existingMembers.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 2 / 3,
                              padding: EdgeInsets.symmetric(vertical: 24.0),
                              child: Text(
                                AppointmentStrings.noContacts.tr(),
                                maxLines: 3,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: FCStyle.mediumFontSize,
                                  color: ColorPallet.kPrimaryTextColor,
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      List<User> members = List.from(state.existingMembers);
                      members.retainWhere((user) => user.allowToSeeReminders);

                      return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: FCStyle.largeFontSize * 8,
                                  alignment: Alignment.center,
                                  child: BlocBuilder(
                                    bloc: _familyMemberCubit,
                                    builder: (
                                      context,
                                      FamilyMemberState state,
                                    ) {
                                      return Center(
                                        child: ShaderMask(
                                          shaderCallback: (Rect rect) {
                                            return LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                ColorPallet.kBackground,
                                                Colors.transparent,
                                                Colors.transparent,
                                                ColorPallet.kBackground,
                                              ],
                                              stops: [0.0, 0.1, 0.9, 1.0],
                                            ).createShader(rect);
                                          },
                                          blendMode: BlendMode.dstOut,
                                          child: AnimationLimiter(
                                            child: ListView.builder(
                                              itemCount: members.length,
                                              shrinkWrap: true,
                                              controller: _scrollController,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 48.0,
                                              ),
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemBuilder: (
                                                BuildContext context,
                                                int idx,
                                              ) {
                                                bool alreadyAdded =
                                                    _manageAppointment
                                                        .state.guests
                                                        .any((u) =>
                                                            u.id ==
                                                            members[idx].id);

                                                User member =
                                                    members[idx].copyWith(
                                                  isSelected: alreadyAdded,
                                                );

                                                return AnimationConfiguration
                                                    .staggeredList(
                                                  position: idx,
                                                  delay: Duration(
                                                      milliseconds: 100),
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  child: SlideAnimation(
                                                    horizontalOffset: 100.0,
                                                    child: FadeInAnimation(
                                                      child: UserAvatar(
                                                        user: member,
                                                        showName: true,
                                                        showNotificationBadge:
                                                            false,
                                                        height: 128,
                                                        width: 128,
                                                        onTap: () {
                                                          _manageAppointment.add(
                                                              AppointmentToggleGuest(
                                                            member,
                                                          ));
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              scrollDirection: Axis.horizontal,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  top: FCStyle.mediumFontSize * 5,
                                  left: 32,
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 500),
                                    opacity: isTopOfList ? 0.0 : 0.9,
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: ColorPallet.kPrimaryTextColor,
                                      size: 48,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: FCStyle.mediumFontSize * 5,
                                  right: 32,
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 500),
                                    opacity: isBottomOfList ? 0.0 : 0.9,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: ColorPallet.kPrimaryTextColor,
                                      size: 48,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ]);
                    },
                  );
                },
              ),
              // Text(
              //   AppointmentStrings.typeGuestEmail.tr(),
              //   style: TextStyle(
              //       color: ColorPallet.kPrimaryTextColor,
              //       fontWeight: FontWeight.bold,
              //       fontSize: FCStyle.largeFontSize),
              // ),
              // SizedBox(height: 16.0),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 64),
              //   child: FCTextFormField(
              //     textEditingController: _controller,
              //     onChanged: (value) => {},
              //     hintText: AppointmentStrings.exampleText.tr(),
              //     hintFontSize: FCStyle.largeFontSize,
              //   ),
              // )
            ],
          );
        });
  }
}
