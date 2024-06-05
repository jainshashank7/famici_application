import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famici/core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../feature/maintenance/bloc/maintenance_bloc.dart';
import '../../../shared/custom_snack_bar/fc_alert.dart';
import '../../../shared/fc_material_button.dart';
import '../../../shared/fc_text_form_field.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../../utils/constants/assets_paths.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/helpers/widget_key.dart';
import '../../blocs/app_bloc/app_bloc.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/theme_bloc/theme_cubit.dart';
import '../../blocs/weather_bloc/weather_bloc.dart';
import '../../enitity/weather.dart';
import '../../models/email_input.dart';
import '../../offline/local_database/users_db.dart';
import '../../router/router_delegate.dart';
import '../loading_screen/loading_screen.dart';
import 'Reset_pin_screen.dart';
import 'enter_pin_screen.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({Key? key}) : super(key: key);

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  bool updateWeatherWhen(WheatherState previous, WheatherState current) {
    if (previous.status != current.status) {
      return true;
    }
    Current? currentWeather = current.weather.current;
    Current? prevWeather = previous.weather.current;
    bool notNull = currentWeather?.tempF != null;
    bool hasChanged = currentWeather?.tempF != prevWeather?.tempF;
    return notNull && hasChanged;
  }

  bool updateNameWhen(AuthState previous, AuthState current) {
    return previous.user.givenName != current.user.givenName;
  }

  final FocusScopeNode _node = FocusScopeNode();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return Scaffold(
              body: Stack(
                children: [
                  Positioned.fill(
                      child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          ColorPallet.kBackGroundGradientColor1,
                          ColorPallet.kBackGroundGradientColor2
                        ],
                      ),
                    ),
                  )),
                  MediaQuery.of(context).viewInsets.bottom > 0.0
                      ? SizedBox.shrink()
                      : Align(
                          alignment: Alignment(0, -0.5),
                          child: Container(
                            height: FCStyle.screenHeight / 4,
                            child: Image(
                              image: AssetImage(themeState.isDark
                                  ? DashboardIcons.mobexNewLogoHorizontal
                                  : DashboardIcons.mobexNewLogoHorizontal),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                  FocusScope(
                    node: _node,
                    child: GestureDetector(
                      onTap: () async {
                        _node.unfocus();
                      },
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(48.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      BlocBuilder<AuthBloc, AuthState>(
                                        buildWhen: updateNameWhen,
                                        builder: (context, state) {
                                          return Text("");
                                        },
                                      ),
                                      Spacer(),
                                      BlocBuilder<AppBloc, AppState>(
                                        builder: (context, state) {
                                          return Text(
                                            state.time,
                                            key: FCElementID.lockScreenTimeKey,
                                            style: FCStyle.textStyle.copyWith(
                                              fontSize: FCStyle.largeFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  // BlocBuilder<WeatherBloc, WheatherState>(
                                  //   buildWhen: updateWeatherWhen,
                                  //   builder: (context, state) {
                                  //     if (state.status == WeatherStatus.success) {
                                  //       return Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.start,
                                  //         children: [
                                  //           Column(
                                  //             crossAxisAlignment:
                                  //                 CrossAxisAlignment.start,
                                  //             children: [
                                  //               WeatherLabel(
                                  //                 weather: state.weather,
                                  //                 key: FCElementID
                                  //                     .lockScreenWeatherKey,
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ],
                                  //       );
                                  //     } else if (state.status ==
                                  //         WeatherStatus.loading) {
                                  //       return Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.start,
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.center,
                                  //         children: [
                                  //           SizedBox(
                                  //             height: FCStyle.largeFontSize,
                                  //             width: FCStyle.largeFontSize,
                                  //             child: LoadingScreen(),
                                  //           )
                                  //         ],
                                  //       );
                                  //     }
                                  //     return Row();
                                  //   },
                                  // )
                                ],
                              ),
                            ),
                          ),
                          // if (MediaQuery.of(context).viewInsets.bottom > 0.0)
                          //   Positioned.fill(
                          //       child: Container(
                          //     color: ColorPallet.kBlack.withOpacity(0.8),
                          //   )),
                          InkWell(
                            onTap: () async {
                              _node.unfocus();
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: UnlockVerifiedUser(),
                          ),
                          if (AuthStatus.pinUpdate != authState.status)
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: BlocBuilder<MaintenanceBloc,
                                  MaintenanceState>(
                                builder: (context, state) {
                                  return Visibility(
                                    visible: (WidgetsBinding.instance.window
                                                    .viewInsets.bottom ??
                                                0) >
                                            0
                                        ? false
                                        : true,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 0, 8),
                                      child: Text(
                                        "Version : ${state.currentPackage.version}",
                                        style: FCStyle.textStyle.copyWith(
                                          fontSize: FCStyle.mediumFontSize,
                                          // fontWeight: FontWeight.bold,
                                          // color: const Color(0xFF7A7979)
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class UnlockVerifiedUser extends StatefulWidget {
  const UnlockVerifiedUser({
    Key? key,
  }) : super(key: key);

  @override
  State<UnlockVerifiedUser> createState() => _UnlockVerifiedUserState();
}

class _UnlockVerifiedUserState extends State<UnlockVerifiedUser> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isEnabled = false;
  bool isPasswordHidden = true;
  EmailInput emailValidator = const EmailInput.pure();

  String pin = '';
  String password = "";
  String email = "";
  String name = "";

  bool isPin = true;
  bool isReset = false;

  getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email')!;

    final DatabaseHelperForUsers userDetails = DatabaseHelperForUsers();
    List<Map<String, dynamic>>? data = await userDetails.getCredentials(email);

    setState(() {
      email;
      _emailController.text = email;

      if (data != null) {
        password = data[0]["password"];
        pin = data[0]['pin'];
        name = data[0]['name'];
      }
    });
  }

  bool isEnable() {
    return (_passwordController.text.isNotEmpty) && (emailValidator.valid);
  }

  @override
  void initState() {
    if (context.read<AuthBloc>().state.status == AuthStatus.confirmFailed) {
      context.read<AuthBloc>().add(ResetConfirmUserFailedAuthEvent());
    }
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getUserEmail();
    return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
      buildWhen: (prev, cur) =>
          prev.templateId != cur.templateId ||
          prev.dashboardBuilder != cur.dashboardBuilder,
      builder: (context, themeState) {
        return BlocBuilder<AuthBloc, AuthState>(
          // buildWhen: (prev, cur) => prev.user != cur.user,
          builder: (context, state) {
            // print("enterered here sdf ${state.status}");
            if (state.status == AuthStatus.pinRequired ||
                state.status == AuthStatus.pinUpdate) {
              return SetPasswordScreen();
            } else if (state.status == AuthStatus.authenticated) {
              if (!isReset) {
                // Navigate to the screen based on template
                // print("enterered here ${themeState.templateId}  ${themeState.status}");
                if (themeState.status != Status.completed) {
                  return LoadingScreen();
                } else if (themeState.templateId == 1) {
                  fcRouter.replaceAll([HomeRoute()]);
                } else if (themeState.templateId == 2) {
                  fcRouter.replaceAll([FCHomeRoute()]);
                }
              }
              return SizedBox();
            } else if (state.status == AuthStatus.confirmationRequired ||
                state.status == AuthStatus.confirmFailed ||
                state.status == AuthStatus.confirming ||
                state.status == AuthStatus.unauthenticated) {
              return BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Builder(builder: (context) {
                    return SizedBox(
                      width: FCStyle.xLargeFontSize * 8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FCTextFormField(
                            readOnly: true,
                            enabled: state.status != AuthStatus.confirming,
                            textEditingController: _emailController,
                            hasError:
                                state.status == AuthStatus.confirmFailed ||
                                    emailValidator.invalid,
                            hintText: email,
                            label: email,
                            error: state.status != AuthStatus.confirmFailed
                                ? "Invalid Email"
                                : null,
                            hintTextStyle: FCStyle.textStyle.copyWith(
                              color: ColorPallet.kGrey,
                            ),
                            textAlign: TextAlign.start,
                            textInputFormatters: [
                              LengthLimitingTextInputFormatter(50)
                            ],
                            maxLines: 1,
                            minLines: 1,
                            onChanged: (value) {
                              setState(() {
                                emailValidator = EmailInput.dirty(value: email);
                                if (context.read<AuthBloc>().state.status ==
                                    AuthStatus.confirmFailed) {
                                  context
                                      .read<AuthBloc>()
                                      .add(ResetConfirmUserFailedAuthEvent());
                                }
                              });
                            },
// onSubmit: (value) {
//   context.read<AuthBloc>().add(
//       ConfirmUserSignInAuthEvent(inviteCode: value.trim()));
// },
                          ),
                          SizedBox(height: FCStyle.blockSizeVertical * 2),
                          Flexible(
                            child: FCTextFormField(
                              enabled: state.status != AuthStatus.confirming,
                              obscureText: isPasswordHidden,
                              textEditingController: _passwordController,
                              hasError:
                                  state.status == AuthStatus.confirmFailed,
                              hintText: isPin && !isReset
                                  ? "Enter pin"
                                  : "Enter password",
                              hintTextStyle: FCStyle.textStyle.copyWith(
                                color: ColorPallet.kGrey,
                              ),
                              textAlign: TextAlign.start,
                              textInputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              // keyboardType: isPin
                              //     ? isReset
                              //         ? TextInputType.text
                              //         : TextInputType.number
                              //     : TextInputType.text,
                              maxLines: 1,
                              minLines: 1,
                              onChanged: (value) {
                                setState(() {
                                  if (context.read<AuthBloc>().state.status ==
                                      AuthStatus.confirmFailed) {
                                    context
                                        .read<AuthBloc>()
                                        .add(ResetConfirmUserFailedAuthEvent());
                                  }
                                });
                              },
                              suffix: Container(
                                padding: EdgeInsets.only(
                                    right: FCStyle.blockSizeHorizontal * 2),
                                child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isPasswordHidden = !isPasswordHidden;
                                      });
                                    },
                                    child: Icon(
                                      !isPasswordHidden
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: FCStyle.largeFontSize,
                                      color: ColorPallet.kGrey,
                                    )),
                              ),
// onSubmit: (value) {
//   context.read<AuthBloc>().add(
//       ConfirmUserSignInAuthEvent(
//           inviteCode: value.trim()));
// },
                            ),
                          ),
                          if (state.status == AuthStatus.confirmFailed)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Invalid email or password',
                                textAlign: TextAlign.center,
                                style: FCStyle.textStyle.copyWith(
                                  color: ColorPallet.kRed,
                                ),
                              ),
                            ),
                          SizedBox(height: FCStyle.mediumFontSize),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              isReset
                                  ? const SizedBox()
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isPin = !isPin;
                                        });
                                      },
                                      child: Text(
                                        isPin || isReset
                                            ? "Use Password"
                                            : "Use pin",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize:
                                                FCStyle.smallFontSize * 1.7,
                                            decoration:
                                                TextDecoration.underline,
                                            color: ColorPallet.kBlack),
                                      ),
                                    ),
                              SizedBox(
                                width: 40 * FCStyle.fem,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isReset = true;
                                  });
                                },
                                child: Text(
                                  isPin
                                      ? isReset
                                          ? "Enter password to reset pin "
                                          : "Reset pin"
                                      : "",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: FCStyle.smallFontSize * 1.7,
                                      decoration: isReset
                                          ? TextDecoration.none
                                          : TextDecoration.underline,
                                      color: ColorPallet.kBlack),
                                ),
                              ),
                              SizedBox(
                                width: 40 * FCStyle.fem,
                              ),
                            ],
                          ),
                          SizedBox(height: FCStyle.mediumFontSize),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FCMaterialButton(
                                defaultSize: false,
                                borderRadius: BorderRadius.circular(5),
                                color: ColorPallet.kPrimary,
                                onPressed: () async {
                                  if (isReset) {
                                    if (_passwordController.text.trim() ==
                                        password) {
                                      context.read<AuthBloc>().add(
                                          ConfirmUserSignInAuthEvent(
                                              inviteCode: password,
                                              email: email));
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      fcRouter.pushWidget(ResetPasswordScreen(
                                        password: password,
                                        email: email,
                                        name: name,
                                      ));
                                    } else {
                                      FCAlert.showError("Invalid password",
                                          duration: const Duration(seconds: 1));
                                    }
                                  } else {
                                    if (isPin) {
                                      if (_passwordController.text.trim() ==
                                          pin) {
                                        context.read<AuthBloc>().add(
                                            ConfirmUserSignInAuthEvent(
                                                inviteCode: password,
                                                email: _emailController.text
                                                    .trim()));
                                      } else {
                                        FCAlert.showError("Invalid pin",
                                            duration: Duration(seconds: 1));
                                      }
                                    } else {
                                      context.read<AuthBloc>().add(
                                          ConfirmUserSignInAuthEvent(
                                              inviteCode: _passwordController
                                                  .text
                                                  .trim(),
                                              email: _emailController.text
                                                  .trim()));
                                    }
                                  }
                                },
                                child: Text(
                                  state.status == AuthStatus.confirming
                                      ? "Submitting"
                                      : "Submit",
                                  style: FCStyle.textStyle.copyWith(
                                    color: ColorPallet.kWhite,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              FCMaterialButton(
                                isBorder: true,
                                defaultSize: false,
                                borderColor: Color(0xFF963209),
                                borderRadius: BorderRadius.circular(5),
                                color: ColorPallet.kWhite,
                                onPressed: () {
                                  fcRouter.replaceAll([MultipleUserRoute()]);
                                },
                                child: Text(
                                  "Cancel",
                                  style: FCStyle.textStyle.copyWith(
                                    color: Color(0xFF963209),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if ((WidgetsBinding
                                  .instance.window.viewInsets.bottom) >
                              0)
                            SizedBox(height: 16.0)
                          else
                            SizedBox(height: FCStyle.largeFontSize * 2)
                        ],
                      ),
                    );
                  });

// return Center(child: LoadingScreen());
                },
              );
            }
            return Center(child: LoadingScreen());
          },
        );
      },
    );
  }
}
