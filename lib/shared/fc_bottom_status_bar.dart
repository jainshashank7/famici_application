import 'package:battery_indicator/battery_indicator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_app_settings/open_app_settings.dart';
import 'package:famici/core/blocs/battery_cubit/battery_cubit.dart';
import 'package:famici/core/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:famici/core/blocs/weather_bloc/weather_bloc.dart';
import 'package:famici/core/enitity/weather.dart';
import 'package:famici/shared/weather_label.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/constants/assets_paths.dart';
import 'package:famici/utils/strings/home_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/blocs/app_bloc/app_bloc.dart';
import '../core/blocs/auth_bloc/auth_bloc.dart';
import '../core/blocs/theme_bloc/theme_cubit.dart';

class FCBottomStatusBar extends StatelessWidget {
  const FCBottomStatusBar({
    Key? key,
    bool? isExpanded,
  })  : _isExpanded = isExpanded ?? false,
        super(key: key);

  final bool _isExpanded;

  final double marginWidth = 40;
  final double barHeight = 36.0;
  final double barRadius = 36;

  EdgeInsetsGeometry? get getStatusBarMargin {
    return _isExpanded
        ? null
        : EdgeInsets.symmetric(horizontal: marginWidth / 2);
  }

  BoxDecoration? get statusBarBackDecoration {
    return BoxDecoration(
      color: _isExpanded ? ColorPallet.kCardBackground : null,
      borderRadius: statusBarBorderRadius,
    );
  }

  BorderRadius? get statusBarBorderRadius {
    return !_isExpanded
        ? BorderRadius.only(
      topRight: Radius.circular(10),
      topLeft: Radius.circular(10),
    )
        : BorderRadius.zero;
  }

  BoxDecoration? get statusBarForegroundDecoration {
    return _isExpanded
        ? BoxDecoration(color: ColorPallet.kBottomStatusBarColor)
        : BoxDecoration(
      borderRadius: statusBarBorderRadius,
      boxShadow: statusBarShadow,
    );
  }

  List<BoxShadow>? get statusBarShadow {
    return [
      BoxShadow(color: Color.fromARGB(110, 0, 0, 0)),
      BoxShadow(
        color: ColorPallet.kBackground,
        spreadRadius: -6,
        blurRadius: 10,
        offset: Offset(6, 6),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - marginWidth;
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, themeState) {
      return Container(
        height: barHeight,
        margin: getStatusBarMargin,
        width: width,
        decoration: BoxDecoration(
          color: _isExpanded ? Colors.white : null,
          borderRadius: statusBarBorderRadius,
        ),
        child: Container(
            height: barHeight,
            decoration: BoxDecoration(
              color: _isExpanded ? null : Colors.white,
              borderRadius: _isExpanded ? null : statusBarBorderRadius,
              boxShadow: statusBarShadow,
            ),
            child: ClipRRect(
              borderRadius: statusBarBorderRadius,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatusBarWeatherSection(
                    statusBarBorderRadius: statusBarBorderRadius,
                    isExpanded: _isExpanded,
                    width: (width / 4) + (width / 8),
                    height: barHeight,
                  ),
                  Container(
                    width: width - ((width / 4) + (width / 8)),
                    padding: const EdgeInsets.only(
                      // top: 12.0,
                      // bottom: 12.0,
                      // left: 4.0,
                      // horizontal: 32.0,
                        right: 70,
                        left: 36),
                    child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
                      builder: (context, state) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            StatusBarIcon(
                              icon: Icons.bluetooth,
                              isAvailable: state.isBluetoothOn,
                              isConnected: state.isBluetoothOn,
                              onPressed: () {
                                OpenAppSettings.openBluetoothSettings();
                              },
                            ),
                            StatusBarIcon(
                              icon: Icons.wifi,
                              isAvailable: state.isWifiOn,
                              isBottomBadge: true,
                              isConnected: state.hasInternet &&
                                  state.connection == ConnectivityResult.wifi,
                              onPressed: () {
                                OpenAppSettings.openWIFISettings();
                              },
                            ),
                            StatusBarIcon(
                              icon: Icons.lock,
                              showBadge: false,
                              onPressed: () {
                                context.read<AppBloc>().add(EnableLock());
                              },
                            ),
                            OnlineIndicator(),
                            BatteryStatusIndicator()
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            )),
      );
    });
  }
}

class StatusBarWeatherSection extends StatelessWidget {
  const StatusBarWeatherSection({
    Key? key,
    required this.statusBarBorderRadius,
    required this.width,
    double? height,
    bool? isExpanded,
  })  : isExpanded = isExpanded ?? false,
        height = height ?? 80,
        super(key: key);

  final bool isExpanded;
  final double width;
  final double height;
  final BorderRadius? statusBarBorderRadius;

  bool buildWhen(
      WheatherState previous,
      WheatherState current,
      ) {
    if (previous.status != current.status) {
      return true;
    }
    Current? currentWeather = current.weather.current;
    Current? previousWeather = previous.weather.current;
    bool notNull = currentWeather?.tempF != null;
    bool hasChanged = currentWeather?.tempF != previousWeather?.tempF ||
        previous.status != current.status;
    return notNull && hasChanged;
  }

  BoxDecoration? get backGroundDecoration {
    return BoxDecoration(
      color: Colors.white,
      image: DecorationImage(
        image: AssetImage(
          AssetImagePath.weatherImage,
        ),
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isExpanded
        ? SizedBox.shrink()
        : ClipRRect(
      borderRadius: statusBarBorderRadius,
      child: Container(
        decoration: backGroundDecoration,
        width: width,
        height: height,
        padding: EdgeInsets.only(
          // left: 16.0,
          // top: 8.0,
          // right: 16.0,
        ),
        child: BlocBuilder<WeatherBloc, WheatherState>(
          buildWhen: buildWhen,
          builder: (context, state) {
            if (state.status == WeatherStatus.success) {
              return WeatherLabel(
                weather: state.weather,
              );
            } else if (state.status == WeatherStatus.loading) {
              return Center(child: CircularProgressIndicator());
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class OnlineIndicator extends StatefulWidget {
  const OnlineIndicator({Key? key}) : super(key: key);

  @override
  State<OnlineIndicator> createState() => _OnlineIndicatorState();
}

class _OnlineIndicatorState extends State<OnlineIndicator> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, themeState) {
      return Container(
        // margin: const EdgeInsets.only(
        //   top: 12.0,
        // ),
        // width: 200,
        alignment: Alignment.center,
        child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
          buildWhen: (prv, curr) => prv.connection != curr.connection,
          builder: (context, state) {
            if (state.hasInternet) {
              authenticateUser(context);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(
                //   width: FCStyle.largeFontSize ,
                //   child:
                //
                //   // Image(
                //   //   image: AssetImage(AssetIconPath.onlineIcon),
                //   //   width: 20,
                //   //   height: 20,
                //   // ),
                // ),

                // Image.asset(state.connection != ConnectivityResult.none
                //     ? AssetIconPath.onlineIcon : AssetIconPath.offlineIcon),
                Container(
                  padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                  child: FittedBox(
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          state.connection != ConnectivityResult.none
                              ? AssetIconPath.onlineIcon
                              : AssetIconPath.offlineIcon,
                          height: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          state.connection == ConnectivityResult.none
                              ? "Offline"
                              : "Online",
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontFamily: 'roboto',
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }
}

Future<void> authenticateUser(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  var authRequired = prefs.getBool("authenticate");

  if (authRequired == true) {
    var username = prefs.getString("user_name");
    var password = prefs.getString("user_password");

    if (username != null && password != null) {
      context.read<AuthBloc>().add(SignOutAuthEvent());
      context
          .read<AuthBloc>()
          .add(SignInAuthEvent(username: username, password: password));
    }
  }
}

class BatteryStatusIndicator extends StatelessWidget {
  const BatteryStatusIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, themeState) {
      return Container(
        margin: const EdgeInsets.only(
          // top: 12.0,
          // left: 12.0,
          // right: 12.0,
        ),
        // width: 200,
        alignment: Alignment.center,
        child: BlocBuilder<BatteryCubit, BatteryState>(
          buildWhen: (prv, curr) => prv.percentage != curr.percentage,
          builder: (context, state) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  child: BatteryIndicator(
                    batteryFromPhone: false,
                    batteryLevel: state.percentage,
                    colorful: true,
                    showPercentNum: false,
                    mainColor: Color(0xFF333333),
                    size: 20.0,
                    ratio: 100.0,
                    showPercentSlide: true,
                    style: BatteryIndicatorStyle.skeumorphism,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                  child: FittedBox(
                    child: Text(
                      ' ${HomeStrings.batteryPercentage.tr(args: [
                        state.percentage.toString()
                      ])} Battery',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }
}

class StatusBarIcon extends StatelessWidget {
  const StatusBarIcon({
    Key? key,
    required this.icon,
    bool? isAvailable,
    bool? isConnected,
    bool? isBottomBadge,
    bool? showBadge,
    this.onPressed,
  })  : isAvailable = isAvailable ?? false,
        isConnected = isConnected ?? false,
        isBottomBadge = isBottomBadge ?? false,
        showBadge = showBadge ?? true,
        super(key: key);

  final IconData icon;
  final bool isAvailable;
  final bool isConnected;
  final bool isBottomBadge;
  final bool showBadge;
  final VoidCallback? onPressed;

  Widget getBadgeIcon() {
    if (!showBadge) {
      return SizedBox.shrink();
    }
    if (isConnected) {
      return Icon(
        Icons.check_circle,
        size: 15,
        color: ColorPallet.kLightGreen,
      );
    } else if (isAvailable && !isConnected) {
      return Icon(
        Icons.error,
        size: 15,
        color: ColorPallet.kOrange,
      );
    }
    return Icon(
      Icons.cancel,
      size: 15,
      color: ColorPallet.kRed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: InkWell(
          onTap: onPressed,
          child: Stack(
            children: [
              Positioned(
                top: !isBottomBadge ? 5 : null,
                bottom: isBottomBadge ? 3 : null,
                right: 0,
                child: getBadgeIcon(),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  size: 22,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}