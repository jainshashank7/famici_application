import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/feature/care_team/blocs/care_team_bloc.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/famici_scaffold.dart';

import '../../../../shared/fc_back_button.dart';
import '../../../../utils/config/famici.theme.dart';
import '../../../../utils/constants/assets_paths.dart';
import '../../../blocs/theme_builder_bloc/theme_builder_bloc.dart';
import 'bottom_status_bar.dart';
import 'logout_button.dart';

class CareTeamScreen extends StatelessWidget {
  const CareTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return BlocBuilder<CareTeamBloc, CareTeamState>(
      builder: (context, state) {
        return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
  builder: (context, stateM) {
    return FamiciScaffold(
          leading: const FCBackButton(),
          topRight: const LogoutButton(),
          title: Center(
            child: Text(
              'Care Team',
              style: FCStyle.textStyle.copyWith(
                  fontSize: 45 * FCStyle.fem, fontWeight: FontWeight.w600),
            ),
          ),
          bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.02),
              width: double.infinity,
              height: 0.76 * height,
              color: Colors.white.withOpacity(0.95),
              child: state.members.isEmpty
                  ? Center(
                      child: Text(
                        "No Counselor Assigned !!!",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: height * 0.06,
                        ),
                        maxLines: 1,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 0.01 * height, horizontal: 0.03 * width),
                      child: Column(
                        children: [
                          Container(
                            height: 0.07 * height,
                            margin: EdgeInsets.fromLTRB(
                                0.02 * width, 0, 0.02 * width, 0.02 * height),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: width * 0.22,
                                  // color: Colors.yellow,
                                  child: Text(
                                    "Name",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: height * 0.03,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width * 0.15,
                                  // color: Colors.black,
                                  child: Text(
                                    "Role",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: height * 0.03,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width * 0.30,
                                  // color: Colors.blue,
                                  child: Text(
                                    "Email Address",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: height * 0.03,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  width: width * 0.13,
                                  // color: Colors.purpleAccent,
                                  child: Text(
                                    "Phone Number",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: height * 0.03,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                                child: ListView.separated(
                                    separatorBuilder: (context, index) {
                                      return Container(
                                        height: height * 0.01,
                                      );
                                    },
                                    itemCount: state.members.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Color(0xffD9D9D9),
                                                  width: 2),
                                            )),
                                        height: 0.11 * height,
                                        // color: Colors.deepOrange,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.02),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: width * 0.22,
                                                // color: Colors.yellow,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: width * 0.025,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      child: state
                                                                  .members[
                                                                      index]
                                                                  .profileUrl ==
                                                              null
                                                          ? SvgPicture.asset(
                                                              "assets/images/generic_avatar.svg")
                                                          : Image.network(state
                                                              .members[index]
                                                              .profileUrl
                                                              .toString()),
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.01,
                                                    ),
                                                    Container(
                                                      width: 0.16 * width,
                                                      // color: Colors.deepOrange,
                                                      child: Text(
                                                        "${state.members[index].firstName}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              height * 0.03,
                                                        ),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: width * 0.15,
                                                // color: Colors.black,
                                                child: Text(
                                                  state.members[index].role!,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: height * 0.03,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: width * 0.30,
                                                // color: Colors.blue,
                                                child: Text(
                                                  state.members[index].email!,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: height * 0.025,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Container(
                                                width: width * 0.13,
                                                // color: Colors.purpleAccent,
                                                child: Text(
                                                  state.members[index]
                                                                  .phoneNumber ==
                                                              "" ||
                                                          state.members[index]
                                                                  .phoneNumber ==
                                                              null
                                                      ? "NA"
                                                      : state.members[index]
                                                          .phoneNumber!,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: height * 0.03,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })),
                          )
                        ],
                      ),
                    ),
            ),
          ),
        );
  },
);
      },
    );
  }
}
