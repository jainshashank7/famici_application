import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../repositories/user_pin_repository.dart';
import '../../../shared/fc_bottom_status_bar.dart';
import '../../../shared/fc_material_button.dart';
import '../../../shared/fc_text.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../../utils/constants/assets_paths.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../offline/local_database/users_db.dart';
import 'entity/fc_text_form_field.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  String password1 = "";
  String password2 = "";
  final PinRepository pins = PinRepository();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Stack(children: [
          Positioned.fill(child: Container(child:
              BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
                  builder: (context, stateM) {
            if (stateM.themeData.background != '') {
              return CachedNetworkImage(
                imageUrl: stateM.themeData.background,
                // imageUrl:
                //     'https://images.pexels.com/photos/262713/pexels-photo-262713.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                // imageUrl:
                //     'https://images.pexels.com/photos/370799/pexels-photo-370799.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                fit: BoxFit.cover,
              );
            } else {
              return Container(
                  decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(AssetImagePath.backgroundImage),
                ),
              ));
            }
          }))),
          Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            bottomNavigationBar: FCBottomStatusBar(),
            // showAppbar: false,
            // isLoading: state.status == AuthStatus.loading,
            // leading: SizedBox(),
            body: Container(
              margin: EdgeInsets.fromLTRB(25 * FCStyle.fem, 15 * FCStyle.fem,
                  25 * FCStyle.fem, 15 * FCStyle.fem),
              padding: EdgeInsets.fromLTRB(45 * FCStyle.fem, 15 * FCStyle.fem,
                  24 * FCStyle.fem, 20 * FCStyle.fem),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xe5ffffff),
                borderRadius: BorderRadius.circular(10 * FCStyle.fem),
              ),
              height: double.infinity,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Align(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100 * FCStyle.fem,
                      ),
                      FCText(
                        text: "Hello ${state.user.name}",
                        fontSize: FCStyle.xLargeFontSize,
                        fontWeight: FontWeight.w900,
                        textColor: ColorPallet.kBlack,
                      ),
                      SizedBox(
                        height: FCStyle.blockSizeVertical * 3,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: FCStyle.blockSizeHorizontal * 5),
                        child: FCText(
                          text: "Please create a new pin for your account",
                          fontSize: FCStyle.mediumFontSize,
                          textColor: ColorPallet.kBlack,
                        ),
                      ),
                      SizedBox(height: FCStyle.blockSizeVertical * 6),
                      SizedBox(
                          width: FCStyle.screenWidth * 0.75,
                          child: FCTextFormField(
                            textInputFormatters: [
                              LengthLimitingTextInputFormatter(8),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLines: 1,
                            hintText: "New pin",
                            hintStyle: FCStyle.textStyle.copyWith(
                              color: ColorPallet.kPrimaryColor.withOpacity(0.7),
                            ),
                            fillColor: ColorPallet.kPrimaryGrey,
                            keyboardType: TextInputType.number,
                            // hasError: state.password.isNotValid,
                            // error: state.password.error?.message,
                            obscureText: hidePassword1,
                            suffix: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                setState(() => hidePassword1 = !hidePassword1);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: FCStyle.blockSizeHorizontal * 2),
                                child: Icon(hidePassword1
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                            onChanged: (value) {
                              // context
                              //     .read<AuthBloc>()
                              //     .add(PasswordChanged(value));
                              setState(() {
                                password1 = value.toString();
                              });
                            },
                          )),
                      SizedBox(
                        height: FCStyle.blockSizeVertical * 3,
                      ),
                      // const PasswordCheckList(),
                      SizedBox(height: FCStyle.blockSizeVertical * 3),
                      SizedBox(
                        width: FCStyle.screenWidth * 0.75,
                        child: FCTextFormField(
                          textInputFormatters: [
                            LengthLimitingTextInputFormatter(8),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          maxLines: 1,
                          hintText: "Confirm pin",
                          // hasError: state.reEnterPassword.isNotValid,
                          // error: state.reEnterPassword.error?.message,
                          keyboardType: TextInputType.number,
                          fillColor: ColorPallet.kPrimaryGrey,
                          obscureText: hidePassword2,
                          hintStyle: FCStyle.textStyle.copyWith(
                            color: ColorPallet.kPrimaryColor.withOpacity(0.7),
                          ),
                          suffix: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              setState(() => hidePassword2 = !hidePassword2);
                            },
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: FCStyle.blockSizeHorizontal * 2),
                                child: Icon(hidePassword2
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              password2 = value.toString();
                            });
                            // context
                            //     .read<AuthBloc>()
                            //     .add(ReEnterPasswordChanged(value));
                          },
                        ),
                      ),
                      SizedBox(
                        height: FCStyle.blockSizeVertical * 2,
                      ),
                      FCText(
                        text: password1 != ""
                            ? password1.length >= 4
                                ? password1 == password2
                                    ? "Correct"
                                    : "The two pins do not match"
                                : "Your pin must be a minimum of 4 digits and a maximum of 8 digits in length"
                            : "",
                        textStyle: TextStyle(
                            color:
                                password1 == password2 && password1.length >= 4
                                    ? ColorPallet.kBrightGreen2
                                    : ColorPallet.kRed,
                            fontSize: FCStyle.mediumFontSize),
                      ),
                      password1 == password2 &&
                              password2 != "" &&
                              password1.length >= 4
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: FCStyle.blockSizeHorizontal),
                              child: Icon(
                                Icons.check_rounded,
                                color: ColorPallet.kBrightGreen,
                                size: FCStyle.blockSizeVertical * 2,
                              ),
                            )
                          : const SizedBox.shrink(),
                      password1 != password2 ||
                              password1.length < 4 && password1 != ""
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: FCStyle.blockSizeHorizontal,
                                  top: FCStyle.smallFontSize),
                              child: Icon(
                                Icons.close,
                                color: ColorPallet.kRed,
                                size: FCStyle.blockSizeVertical * 4,
                              ),
                            )
                          : const SizedBox.shrink(),
                      SizedBox(
                        height: FCStyle.blockSizeVertical * 3,
                      ),
                      FCMaterialButton(
                        color: password1 != ""
                            ? password1 == password2
                                ? ColorPallet.kGreen
                                : ColorPallet.kGrey
                            : ColorPallet.kGrey,
                        defaultSize: false,
                        onPressed: () async {
                          if (password1 != "" &&
                              password1.length >= 4 &&
                              password1 == password2) {
                            if (state.status == AuthStatus.pinUpdate) {
                              await pins.updatePin(state.user.email, password1);
                            } else {
                              await pins.createPin(state.user.email, password1);
                            }

                            final DatabaseHelperForUsers userDetails =
                                DatabaseHelperForUsers();
                            await userDetails.insertPinDetails(
                                state.user.email ?? "invalid", password1);

                            context.read<AuthBloc>().add(AuthenticatedEvent());
                            // fcRouter.replaceAll([HomeRoute()]);
                          }
                        },
                        child: SizedBox(
                          width: 200.w,
                          height: 65.h,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Submit",
                                style: FCStyle.textStyle.copyWith(
                                  color: ColorPallet.kLightBackGround,
                                  fontSize: 36.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: FCStyle.blockSizeVertical * 3,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]);
      },
    );
  }
}
