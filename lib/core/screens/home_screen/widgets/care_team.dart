part of 'barrel.dart';

class CareTeam extends StatefulWidget {
  final bool isWebView;

  const CareTeam({Key? key, required this.isWebView}) : super(key: key);

  @override
  State<CareTeam> createState() => _CareTeamState();
}

class _CareTeamState extends State<CareTeam> {
  int membersHeight = 318;
  List<bool> _widgetStates = List.generate(30, (index) => true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
        builder: (connectivityContext, connectivityState) {
      return SizedBox(
        width: 398 * FCStyle.fem,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                  19.22 * FCStyle.fem,
                  26.66 * FCStyle.fem,
                  19.22 * FCStyle.fem,
                  26.34 * FCStyle.fem),
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorPallet.kPrimary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10 * FCStyle.fem),
                  topRight: Radius.circular(10 * FCStyle.fem),
                ),
              ),
              child: Text(
                'Care Team',
                style: TextStyle(
                  // 'Roboto',
                  fontSize: 30 * FCStyle.ffem,
                  fontWeight: FontWeight.w600,
                  height: 1 * FCStyle.ffem / FCStyle.fem,
                  color: ColorPallet.kPrimaryText,
                ),
              ),
            ),
            BlocBuilder<CareTeamBloc, CareTeamState>(
                buildWhen: (prv, curr) =>
                    prv.members.length != curr.members.length,
                builder: (context, state) {
                  TrackEvents().initEventsTrack(state, connectivityState);
                  return Container(
                    padding: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                        0 * FCStyle.fem, 0 * FCStyle.fem, 14.5 * FCStyle.fem),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xe5ffffff),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10 * FCStyle.fem),
                        bottomLeft: Radius.circular(10 * FCStyle.fem),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        state.members.isEmpty
                            ? SizedBox(
                                height: membersHeight * FCStyle.fem,
                                child: Center(
                                  child: Text(
                                    "No service coordinator assigned",
                                    style: TextStyle(
                                        fontSize: 24 * FCStyle.ffem,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(
                                      0 * FCStyle.fem,
                                      0 * FCStyle.fem,
                                      0 * FCStyle.fem,
                                      21.5 * FCStyle.fem),
                                  width: 398 * FCStyle.fem,
                                  height: membersHeight * FCStyle.fem,
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      // controller: scrollController,
                                      itemCount: state.members.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return _widgetStates[index]
                                            ? TextButton(
                                                onPressed: () {
                                                  var properties = TrackEvents()
                                                      .setProperties(
                                                          fromDate: '',
                                                          toDate: '',
                                                          reading: '',
                                                          readingDateTime: '',
                                                          vital: '',
                                                          appointmentDate: '',
                                                          appointmentTime: '',
                                                          appointmentCounselors:
                                                              '',
                                                          appointmentType: '',
                                                          callDuration: '',
                                                          readingType: '');

                                                  TrackEvents().trackEvents(
                                                      'Care Team Clicked',
                                                      properties);
                                                  setState(() {
                                                    _widgetStates[index] =
                                                        !_widgetStates[index];
                                                  });
                                                },
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: MemberCloseItem(
                                                  member: state.members[index],
                                                ),
                                              )
                                            : TextButton(
                                                onPressed: () {
                                                  var properties = TrackEvents()
                                                      .setProperties(
                                                          fromDate: '',
                                                          toDate: '',
                                                          reading: '',
                                                          readingDateTime: '',
                                                          vital: '',
                                                          appointmentDate: '',
                                                          appointmentTime: '',
                                                          appointmentCounselors:
                                                              '',
                                                          appointmentType: '',
                                                          callDuration: '',
                                                          readingType: '');

                                                  TrackEvents().trackEvents(
                                                      'Care Team Clicked',
                                                      properties);
                                                  setState(() {
                                                    _widgetStates[index] =
                                                        !_widgetStates[index];
                                                  });
                                                },
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: MemberOpenItem(
                                                  member: state.members[index],
                                                ),
                                              );
                                      }),
                                ),
                              ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              membersHeight = 318 - membersHeight;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                1.25 * FCStyle.fem,
                                0 * FCStyle.fem,
                                0 * FCStyle.fem,
                                0 * FCStyle.fem),
                            width: 38.25 * FCStyle.fem,
                            height: 33 * FCStyle.fem,
                            child: Image.asset(
                              AssetImagePath.downArrowIcon,
                              width: 38.25 * FCStyle.fem,
                              height: 17 * FCStyle.fem,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      );
    });
  }
}

class MemberCloseItem extends StatelessWidget {
  const MemberCloseItem({Key? key, required this.member}) : super(key: key);

  final CareTeamMember member;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(17 * FCStyle.fem, 33 * FCStyle.fem,
              21.83 * FCStyle.fem, 28.32 * FCStyle.fem),
          width: 398 * FCStyle.fem,
          height: 116 * FCStyle.fem,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 55 * FCStyle.fem,
                    height: 54.68 * FCStyle.fem,
                    child: member.profileUrl == null
                        ? Image.asset(
                            AssetImagePath.avatarImage,
                            width: 55 * FCStyle.fem,
                            height: 54.68 * FCStyle.fem,
                          )
                        : CachedNetworkImage(
                            height: 70 * FCStyle.fem,
                            width: 70 * FCStyle.fem,
                            fit: BoxFit.cover,
                            imageUrl: member.profileUrl ?? "",
                            placeholder: (context, url) => SizedBox(
                              height: 70 * FCStyle.fem,
                              child: Shimmer.fromColors(
                                  baseColor: ColorPallet.kWhite,
                                  highlightColor: ColorPallet.kPrimaryGrey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.photo,
                                        size: 50 * FCStyle.fem,
                                      ),
                                    ],
                                  )),
                            ),
                            errorWidget: (context, url, error) => SizedBox(
                              height: 50 * FCStyle.fem,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.broken_image,
                                    size: 50 * FCStyle.fem,
                                    color: ColorPallet.kPrimaryTextColor,
                                  ),
                                ],
                              ),
                            ),
                            fadeInCurve: Curves.easeIn,
                            fadeInDuration: const Duration(milliseconds: 100),
                          ),
                  ),
                  Container(
                    width: 170 * FCStyle.fem,
                    margin: EdgeInsets.only(
                        top: 2 * FCStyle.fem, left: 10 * FCStyle.fem),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.firstName ?? member.lastName ?? "",
                          style: TextStyle(
                            fontSize: 22 * FCStyle.ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.1725 * FCStyle.ffem / FCStyle.fem,
                            color: Color(0xff383946),
                          ),
                        ),
                        Text(
                          member.role ?? "",
                          style: TextStyle(
                            fontSize: 18 * FCStyle.ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.1725 * FCStyle.ffem / FCStyle.fem,
                            color: Color(0xff5b5b5b),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 45 * FCStyle.fem,
                margin: EdgeInsets.only(right: 5 * FCStyle.fem),
                padding: EdgeInsets.fromLTRB(29.5 * FCStyle.fem,
                    12 * FCStyle.fem, 25.13 * FCStyle.fem, 11 * FCStyle.fem),
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(100 * FCStyle.fem),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x28000000),
                      offset: Offset(0 * FCStyle.fem, 4 * FCStyle.fem),
                      blurRadius: 2 * FCStyle.fem,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                            0 * FCStyle.fem,
                            0 * FCStyle.fem,
                            6.5 * FCStyle.fem,
                            0 * FCStyle.fem),
                        child: Text(
                          'Detail',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18 * FCStyle.ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.1725 * FCStyle.ffem / FCStyle.fem,
                            color: ColorPallet.kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // vectorLXi (I697:2015;697:1565)
                      margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                          0 * FCStyle.fem, 0 * FCStyle.fem, 1.1 * FCStyle.fem),
                      width: 10 * FCStyle.fem,
                      height: 11.51 * FCStyle.fem,
                      child: SvgPicture.asset(
                        AssetIconPath.upArrowIcon,
                        width: 10 * FCStyle.fem,
                        height: 11.51 * FCStyle.fem,
                        color: ColorPallet.kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1 * FCStyle.fem,
          width: double.infinity,
          color: const Color(0xDBDBDBDB),
        )
      ],
    );
  }
}

class MemberOpenItem extends StatelessWidget {
  const MemberOpenItem({Key? key, required this.member}) : super(key: key);

  final CareTeamMember member;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(17 * FCStyle.fem, 20 * FCStyle.fem,
              21.83 * FCStyle.fem, 22 * FCStyle.fem),
          width: 398 * FCStyle.fem,
          height: 170 * FCStyle.fem,
          color: ColorPallet.kWhite,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 55 * FCStyle.fem,
                        height: 54.68 * FCStyle.fem,
                        child: member.profileUrl == null
                            ? Image.asset(
                                AssetImagePath.avatarImage,
                                width: 55 * FCStyle.fem,
                                height: 54.68 * FCStyle.fem,
                              )
                            : CircleAvatar(
                                radius: 30,
                                child: CachedNetworkImage(
                                  height: 70 * FCStyle.fem,
                                  width: 70 * FCStyle.fem,
                                  fit: BoxFit.cover,
                                  imageUrl: member.profileUrl ?? "",
                                  placeholder: (context, url) => SizedBox(
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
                                              size: 50 * FCStyle.fem,
                                            ),
                                          ],
                                        )),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      SizedBox(
                                    height: 50 * FCStyle.fem,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.broken_image,
                                          size: 50 * FCStyle.fem,
                                          color: ColorPallet.kPrimaryTextColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  fadeInCurve: Curves.easeIn,
                                  fadeInDuration:
                                      const Duration(milliseconds: 100),
                                ),
                              ),
                      ),
                      Container(
                        width: 170 * FCStyle.fem,
                        margin: EdgeInsets.only(
                            top: 2 * FCStyle.fem, left: 10 * FCStyle.fem),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.firstName ?? member.lastName ?? "",
                              style: TextStyle(
                                fontSize: 22 * FCStyle.ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.1725 * FCStyle.ffem / FCStyle.fem,
                                color: Color(0xff383946),
                              ),
                            ),
                            Text(
                              member.role ?? "",
                              style: TextStyle(
                                fontSize: 18 * FCStyle.ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.1725 * FCStyle.ffem / FCStyle.fem,
                                color: Color(0xff5b5b5b),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 45 * FCStyle.fem,
                    margin: EdgeInsets.only(right: 5 * FCStyle.fem),
                    padding: EdgeInsets.fromLTRB(29.5 * FCStyle.fem,
                        12 * FCStyle.fem, 25.13 * FCStyle.fem, 8 * FCStyle.fem),
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(100 * FCStyle.fem),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x28000000),
                          offset: Offset(0 * FCStyle.fem, 4 * FCStyle.fem),
                          blurRadius: 2 * FCStyle.fem,
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                0 * FCStyle.fem,
                                0 * FCStyle.fem,
                                6.5 * FCStyle.fem,
                                0 * FCStyle.fem),
                            child: Text(
                              'Detail',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18 * FCStyle.ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.1725 * FCStyle.ffem / FCStyle.fem,
                                color: ColorPallet.kPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          // vectorLXi (I697:2015;697:1565)
                          margin: EdgeInsets.fromLTRB(
                              0 * FCStyle.fem,
                              0 * FCStyle.fem,
                              0 * FCStyle.fem,
                              1.1 * FCStyle.fem),
                          width: 10 * FCStyle.fem,
                          height: 11.51 * FCStyle.fem,
                          child: SvgPicture.asset(
                            AssetIconPath.downArrowIcon,
                            width: 10 * FCStyle.fem,
                            height: 11.51 * FCStyle.fem,
                            color: ColorPallet.kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                    top: 10.15 * FCStyle.fem, left: 30 * FCStyle.fem),
                child: Row(
                  children: [
                    member.email != ""
                        ? SvgPicture.asset(
                            AssetIconPath.mailIcon,
                            width: 19 * FCStyle.fem,
                            height: 17.87 * FCStyle.fem,
                          )
                        : SizedBox(),
                    Container(
                        margin: EdgeInsets.only(left: 15 * FCStyle.fem),
                        width: 290 * FCStyle.fem,
                        child: Text(
                          member.email ?? "",
                          style: TextStyle(
                              fontSize: 18 * FCStyle.ffem,
                              color: ColorPallet.kPrimaryColor),
                        ))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: 3 * FCStyle.fem, left: 30 * FCStyle.fem),
                child: Row(
                  children: [
                    member.phoneNumber != ""
                        ? SvgPicture.asset(
                            AssetIconPath.phoneIcon,
                            width: 19 * FCStyle.fem,
                            height: 17.87 * FCStyle.fem,
                          )
                        : SizedBox(),
                    Container(
                        margin: EdgeInsets.only(left: 15 * FCStyle.fem),
                        width: 290 * FCStyle.fem,
                        child: Text(
                          member.phoneNumber ?? "",
                          // state
                          //         .members[
                          //             index]
                          //         .phoneNumber ??
                          //     "",
                          style: TextStyle(
                              fontSize: 18 * FCStyle.ffem,
                              color: ColorPallet.kPrimaryColor),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1 * FCStyle.fem,
          width: double.infinity,
          color: const Color(0xDBDBDBDB),
        )
      ],
    );
  }
}
