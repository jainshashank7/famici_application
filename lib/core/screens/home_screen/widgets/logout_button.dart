import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/core/blocs/auth_bloc/auth_bloc.dart';

import '../../../../feature/health_and_wellness/vitals_and_wellness/blocs/vitals_and_wellness_bloc.dart';
import '../../../../shared/fc_confirm_dialog.dart';
import '../../../../utils/config/color_pallet.dart';
import '../../../../utils/config/famici.theme.dart';
import '../../../../utils/constants/assets_paths.dart';
import '../../../../utils/helpers/events_track.dart';
import '../../../blocs/theme_bloc/theme_cubit.dart';
import '../../../blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../router/router_delegate.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
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

                  TrackEvents().trackEvents('Logout Clicked', properties);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FCConfirmDialog(
                          height: 400,
                          width: 660,
                          subText: 'Hope to see you back soon',
                          submitText: 'Confirm',
                          cancelText: 'Cancel',
                          icon: VitalIcons.logoutIcon,
                          message: "Are you sure you want to logout?",
                        );
                      }).then((value) {
                    if (value) {
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

                      TrackEvents().trackEvents(
                          'User Logged Out', properties);
                      context.read<AuthBloc>().add(SignOutAuthEvent());
                      fcRouter.removeUntil((route) => false);
                      fcRouter.navigate(MultipleUserRoute());
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      14.59 * FCStyle.fem, 13.39 * FCStyle.fem,
                      11.41 * FCStyle.fem, 12.61 * FCStyle.fem),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xfffefeff),
                    borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x03294898),
                        offset: Offset(
                            0 * FCStyle.fem, 1.8518518209 * FCStyle.fem),
                        blurRadius: 1.5740740299 * FCStyle.fem,
                      ),
                    ],
                  ),
                  child: Center(
                    child: SizedBox(
                        width: 34 * FCStyle.fem,
                        height: 34 * FCStyle.fem,
                        child: state.templateId == 2 ?
                        SvgPicture.asset(
                          "assets/images/logout_button.svg",
                          width: 34 * FCStyle.fem,
                          height: 34 * FCStyle.fem,
                        ) : SvgPicture.asset(
                          AssetIconPath.logoutIcon,
                          width: 34 * FCStyle.fem,
                          height: 34 * FCStyle.fem,
                        )
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
