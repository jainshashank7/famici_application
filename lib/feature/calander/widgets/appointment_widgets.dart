import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famici/feature/calander/blocs/manage_appointment/manage_appointment_bloc.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:famici/utils/strings/appointment_strings.dart';

class Summary extends StatelessWidget {
  const Summary({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageAppointmentBloc, ManageAppointmentState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 32),
              child: Text(
                AppointmentStrings.summary.tr(),
                style: FCStyle.textHeaderStyle,
              ),
            ),
            SizedBox(height: 24.r),
            Expanded(
              child: ConcaveCard(
                  radius: 40.r,
                  child: SizedBox(
                    height: double.infinity,
                    width: FCStyle.screenWidth / 3 + FCStyle.mediumFontSize,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: FCStyle.mediumFontSize,
                        horizontal: FCStyle.largeFontSize,
                      ),
                      child: BlocBuilder<ManageAppointmentBloc,
                          ManageAppointmentState>(
                        builder: (context, state) {
                          return SizedBox(
                            height: double.infinity,
                            width: FCStyle.screenWidth / 3 +
                                FCStyle.mediumFontSize,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: FCStyle.mediumFontSize,
                                horizontal: FCStyle.largeFontSize,
                              ),
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: state.summary.length,
                                shrinkWrap: true,
                                itemBuilder: (context, int idx) {
                                  return Padding(
                                      padding: EdgeInsets.only(bottom: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.summary[idx].keys.first,
                                            style: FCStyle.textStyle.copyWith(
                                                fontSize:
                                                    FCStyle.defaultFontSize,
                                                color: ColorPallet
                                                    .kPrimaryTextColor),
                                          ),
                                          Text(
                                            state.summary[idx].values.first,
                                            style: FCStyle.textStyle.copyWith(
                                                fontSize:
                                                    FCStyle.defaultFontSize,
                                                color: ColorPallet
                                                    .kPrimaryTextColor,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ));
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )),
            )
          ],
        );
      },
    );
  }
}
