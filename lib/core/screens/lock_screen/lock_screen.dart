import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:famici/core/blocs/auth_bloc/auth_bloc.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/core/blocs/weather_bloc/weather_bloc.dart';
import 'package:famici/core/enitity/weather.dart';
import 'package:famici/core/models/barrel.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/maintenance/bloc/maintenance_bloc.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/weather_label.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/helpers/widget_key.dart';

import '../../blocs/app_bloc/app_bloc.dart';
import '../../blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../multiple_user_screen/enter_pin_screen.dart';
import '../multiple_user_screen/entity/window_obsever.dart';

class LockScreen extends StatefulWidget {
  LockScreen({Key? key}) : super(key: key);

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
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
    return BlocBuilder<MaintenanceBloc, MaintenanceState>(
      builder: (context, maintenanceState) {
        return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
          return BlocBuilder<AuthBloc, AuthState>(
            buildWhen: updateNameWhen,
            builder: (context, stateAuth) {
              return Stack(children: [
                stateAuth.user.name == null || stateAuth.user.name == ""
                    // ? Positioned.fill(child: Container(color: Colors.white))
                    ? Positioned.fill(
                        child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white,
                              Color(0xFFCBCBCB),
                            ],
                          ),
                        ),
                      ))
                    : Positioned.fill(child: Container(child:
                        BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
                            builder: (context, stateM) {
                        if (stateM.themeData.background != '') {
                          return CachedNetworkImage(
                            imageUrl: stateM.themeData.background,
                            placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    AssetImage(AssetImagePath.backgroundImage),
                              ),
                            )),
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
                  backgroundColor:
                      stateAuth.user.name == null || stateAuth.user.name == ""
                          ? Colors.transparent
                          : Color.fromARGB(60, 12, 12, 12),
                  body: Stack(
                    children: [
                      // MediaQuery.of(context).viewInsets.bottom > 0.0
                      if (MediaQuery.of(context).viewInsets.bottom == 0.0)
                        stateAuth.user.name == null || stateAuth.user.name == ""
                            ? Align(
                                alignment: Alignment(0, -0.5),
                                child: Container(
                                  height: FCStyle.screenHeight / 4,
                                  child: Image(
                                    image: AssetImage(themeState.isDark
                                        ? DashboardIcons.mobexNewLogoHorizontal
                                        : DashboardIcons
                                            .mobexNewLogoHorizontal),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
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
                                  padding: const EdgeInsets.only(
                                      top: 30, left: 50, right: 50, bottom: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            ' ${stateAuth.user.name?.split(" ").first != null && stateAuth.user.name!.split(" ").first.isNotEmpty ? CommonStrings.hi.tr(
                                                args: [
                                                  stateAuth.user.name
                                                          ?.split(" ")
                                                          .first ??
                                                      ''
                                                ],
                                              ) : ''}',
                                            key: FCElementID
                                                .lockScreenGreetingKey,
                                            style: FCStyle.textStyle.copyWith(
                                                fontSize: 55,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                          Spacer(),
                                          BlocBuilder<AppBloc, AppState>(
                                            builder: (context, state) {
                                              return Text(
                                                state.time,
                                                key: FCElementID
                                                    .lockScreenTimeKey,
                                                style: FCStyle.textStyle
                                                    .copyWith(
                                                        fontSize: 35,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: stateAuth.user
                                                                    .name ==
                                                                null
                                                            ? Colors.black
                                                            : Colors.white),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      stateAuth.user.name == null ||
                                              stateAuth.user.name == ""
                                          ? Container()
                                          : BlocBuilder<WeatherBloc,
                                              WheatherState>(
                                              buildWhen: updateWeatherWhen,
                                              builder: (context, state) {
                                                if (state.status ==
                                                    WeatherStatus.success) {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          WeatherLabel(
                                                            textStyle: TextStyle(
                                                                fontFamily:
                                                                    'roboto',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 22),
                                                            weather:
                                                                state.weather,
                                                            key: FCElementID
                                                                .lockScreenWeatherKey,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                } else if (state.status ==
                                                    WeatherStatus.loading) {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        height: FCStyle
                                                            .largeFontSize,
                                                        width: FCStyle
                                                            .largeFontSize,
                                                        child: LoadingScreen(),
                                                      )
                                                    ],
                                                  );
                                                }
                                                return Row();
                                              },
                                            )
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
                              const Align(
                                alignment: Alignment.bottomCenter,
                                child: UnlockVerifiedUser(),
                              ),
                              if (stateAuth.user.name == null ||
                                  stateAuth.user.name == "")
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Visibility(
                                      visible: (WidgetsBinding.instance.window
                                                          .viewInsets.bottom ??
                                                      0) >
                                                  0 &&
                                              maintenanceState
                                                      .currentPackage.version !=
                                                  ""
                                          ? false
                                          : true,
                                      child: Container(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          "Version: ${maintenanceState.currentPackage.version}",
                                          textAlign: TextAlign.center,
                                          style: FCStyle.textStyle.copyWith(
                                            color: ColorPallet.kBlack,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]);
            },
          );
        });
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print("user state bro: ${state.status}");
        if (state.status == AuthStatus.authenticated) {
          return UnlockButton();
        } else if (state.status == AuthStatus.pinRequired ||
            state.status == AuthStatus.pinUpdate) {
          return SetPasswordScreen();
        } else if (state.status == AuthStatus.confirmationRequired ||
            state.status == AuthStatus.confirmFailed ||
            state.status == AuthStatus.confirming ||
            state.status == AuthStatus.unauthenticated) {
          return Builder(builder: (context) {
            return SizedBox(
              width: FCStyle.xLargeFontSize * 9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FCTextFormField(
                    enabled: state.status != AuthStatus.confirming,
                    textEditingController: _emailController,
                    hasError: state.status == AuthStatus.confirmFailed ||
                        emailValidator.invalid,
                    hintText: "Enter Email",
                    error: state.status != AuthStatus.confirmFailed
                        ? "Invalid Email"
                        : null,
                    hintTextStyle: FCStyle.textStyle.copyWith(
                      color: ColorPallet.kGrey,
                    ),
                    textAlign: TextAlign.start,
                    textInputFormatters: [LengthLimitingTextInputFormatter(50)],
                    maxLines: 1,
                    minLines: 1,
                    onChanged: (value) {
                      setState(() {
                        emailValidator = EmailInput.dirty(value: value.trim());
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
                      hasError: state.status == AuthStatus.confirmFailed,
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
                                  inviteCode: _passwordController.text.trim(),
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
                          fcRouter.navigate(MultipleUserRoute());
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
                        return SizedBox(height: FCStyle.xLargeFontSize * 2);
                      }
                    },
                    child: const Placeholder(),
                  ),
                ],
              ),
            );
          });
        }
        return const Center(child: LoadingScreen());
      },
    );
  }
}

class UnlockButton extends StatelessWidget {
  const UnlockButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
            buildWhen: (prev, cur) =>
            prev.templateId != cur.templateId ||
                prev.dashboardBuilder != cur.dashboardBuilder || prev.status != cur.status,
            builder: (context, themeState) {

              // print("this is current data ${themeState.templateId}  ${themeState.status}");
              if (themeState.templateId == 0) {
                return LoadingScreen();
              } else {
                return Padding(
                  padding: EdgeInsets.all(
                      (FCStyle.screenHeight > 0 ? FCStyle.screenHeight : 0) *
                          10 /
                          100),
                  child: NeumorphicButton(
                    // key: FCElementID.lockScreenUnlockBtnKey,
                    minDistance: 4,
                    padding: EdgeInsets.symmetric(
                      vertical: FCStyle.defaultFontSize,
                      horizontal: FCStyle.mediumFontSize * 2,
                    ),
                    style: FCStyle.backButtonStyle
                        .copyWith(color: ColorPallet.kPrimary),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlocBuilder<AppBloc, AppState>(
                          builder: (context, AppState state) {
                            if (state.initialized) {
                              return SvgPicture.asset(
                                AssetIconPath.lockIcon,
                                height: FCStyle.largeFontSize,
                              );
                            }

                            return Container(
                              child: CircularProgressIndicator(
                                color: ColorPallet.kLightBackGround,
                              ),
                              width: FCStyle.largeFontSize,
                              height: FCStyle.largeFontSize,
                              alignment: Alignment.center,
                            );
                          },
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          CommonStrings.unlock.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: FCStyle.largeFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      context.read<AppBloc>().add(DisableLock());

                      // Navigate to the screen based on template
                      if (themeState.templateId == 1) {
                        fcRouter.replaceAll([HomeRoute()]);
                      } else if (themeState.templateId == 2) {
                        fcRouter.replaceAll([FCHomeRoute()]);
                      }
                    },
                  ),
                );
              }
            });
      },
    );
  }
}
