import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famici/shared/barrel.dart';

import '../../../feature/maintenance/bloc/maintenance_bloc.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../../utils/constants/assets_paths.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/helpers/widget_key.dart';
import '../../blocs/app_bloc/app_bloc.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/theme_bloc/theme_cubit.dart';
import '../../blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../blocs/weather_bloc/weather_bloc.dart';
import '../../enitity/weather.dart';
import '../../models/email_input.dart';
import '../../router/router_delegate.dart';
import '../loading_screen/loading_screen.dart';
import 'enter_pin_screen.dart';
import 'entity/window_obsever.dart';

class AddUserLoginScreen extends StatefulWidget {
  const AddUserLoginScreen({Key? key}) : super(key: key);

  @override
  State<AddUserLoginScreen> createState() => _AddUserLoginScreenState();
}

class _AddUserLoginScreenState extends State<AddUserLoginScreen> {
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
                                      return Text(
                                        "",
                                      );
                                    },
                                  ),
                                  Spacer(),
                                  BlocBuilder<AppBloc, AppState>(
                                    builder: (context, state) {
                                      return Text(
                                        state.time,
                                        key: FCElementID.lockScreenTimeKey,
                                        style: FCStyle.textStyle.copyWith(
                                          fontSize: 35,
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
                      //         color: ColorPallet.kBlack.withOpacity(0.8),
                      //       )),
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
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: BlocBuilder<MaintenanceBloc, MaintenanceState>(
                          builder: (context, state) {
                            return Visibility(
                              visible: (WidgetsBinding.instance.window
                                              .viewInsets.bottom ??
                                          0) >
                                      0
                                  ? false
                                  : true,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
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

  bool isEnable() {
    return (_passwordController.text.isNotEmpty) &&
        (_emailController.text.isNotEmpty) &&
        (emailValidator.valid);
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
    return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
      buildWhen: (prev, cur) =>
          prev.templateId != cur.templateId ||
          prev.dashboardBuilder != cur.dashboardBuilder,
      builder: (context, themeState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              // Navigate to the screen based on template
              if (themeState.status != Status.completed) {
                return LoadingScreen();
              } else if (themeState.templateId == 1) {
                fcRouter.replaceAll([HomeRoute()]);
              } else if (themeState.templateId == 2) {
                fcRouter.replaceAll([FCHomeRoute()]);
              }
              return const SizedBox();
            } else if (state.status == AuthStatus.pinRequired) {
              return SetPasswordScreen();
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
                            enabled: state.status != AuthStatus.confirming,
                            textEditingController: _emailController,
                            hasError:
                                state.status == AuthStatus.confirmFailed ||
                                    emailValidator.invalid,
                            hintText: "Enter Email",
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
                                emailValidator =
                                    EmailInput.dirty(value: value.trim());
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
                              hintText: "Enter Password",
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
                              FCMaterialButton(
                                defaultSize: false,
                                borderRadius: BorderRadius.circular(5),
                                color: ColorPallet.kPrimary,
                                onPressed: () {
                                  context.read<AuthBloc>().add(
                                      ConfirmUserSignInAuthEvent(
                                          inviteCode:
                                              _passwordController.text.trim(),
                                          email: _emailController.text.trim()));
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
                                  fcRouter.navigate(const MultipleUserRoute());
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
                          KeyboardVisibilityBuilder(
                            builder: (context, child, isKeyboardVisible) {
                              if (isKeyboardVisible) {
                                return const SizedBox(height: 16.0);
                              } else {
                                return SizedBox(
                                    height: FCStyle.xLargeFontSize * 2);
                              }
                            },
                            child: const Placeholder(),
                          ),
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
