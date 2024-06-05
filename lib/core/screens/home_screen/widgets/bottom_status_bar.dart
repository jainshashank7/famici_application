import 'package:battery_indicator/battery_indicator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_app_settings/open_app_settings.dart';
import '../../../../utils/config/color_pallet.dart';
import '../../../../utils/config/famici.theme.dart';
import '../../../../utils/strings/home_strings.dart';
import '../../../blocs/app_bloc/app_bloc.dart';
import '../../../blocs/battery_cubit/battery_cubit.dart';
import '../../../blocs/connectivity_bloc/connectivity_bloc.dart';
import '../../../blocs/theme_bloc/theme_cubit.dart';
import '../../../blocs/weather_bloc/weather_bloc.dart';
import '../../../enitity/weather.dart';

class BottomStatusBar extends StatefulWidget {
  const BottomStatusBar({super.key});

  @override
  State<BottomStatusBar> createState() => _BottomStatusBarState();
}

class _BottomStatusBarState extends State<BottomStatusBar> {
  @override

  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height:
      0.08 * height,
      padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.01),
      decoration: BoxDecoration(
        // color: Colors.white.withOpacity(0.7),
        image: DecorationImage(
          image: AssetImage(
            'assets/images/bottom_status_bar_bg.png',
          ),
          fit: BoxFit.fill,
        ),
        border: Border.all(width: 2,color:const Color(0xffFFFFFF))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: width * 0.40,
            child: StatusBarWeatherSection(),
          ),
          BlocBuilder<ConnectivityBloc, ConnectivityState>(
            builder: (context, state) {
              return Container(
                width: width * 0.38,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    BatteryStatusIndicator()
                  ],
                ),
              );
            },
          ),

        ],
      ),
    );
  }
}

class StatusBarWeatherSection extends StatelessWidget {
  const StatusBarWeatherSection({
    Key? key,
    bool? isExpanded,
  })  : isExpanded = isExpanded ?? false,
        super(key: key);

  final bool isExpanded;

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

  @override
  Widget build(BuildContext context) {
    return isExpanded
        ? SizedBox.shrink()
        : BlocBuilder<WeatherBloc, WheatherState>(
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
      );
  }
}

class WeatherLabel extends StatelessWidget {
  WeatherLabel({Key? key, required this.weather})
      : super(key: key);
  final Weather weather;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: (weather.location?.name ?? '').isNotEmpty
          ? [
        Container(
          width: 0.045 * MediaQuery.of(context).size.width,
          height: 0.06 * MediaQuery.of(context).size.height,
          child : Image.asset(
              weather.current?.condition?.icon
                  ?.replaceFirst(
                  '//cdn.weatherapi.com/', 'assets/icons/')
                  .toString() ??
                  '',
            fit: BoxFit.fitWidth,
            ),
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.005),
            child: FittedBox(
              child: Text(
                "${weather.current?.tempF ?? ''}ºF ${weather.current?.condition?.text ?? ''}, ${weather.location?.name ?? ''}  ${weather.location?.region ?? ''} ",
                style: TextStyle(
                  color: Color(0xff0A233E),
                fontFamily: 'roboto',
                fontSize: MediaQuery.of(context).size.height * 0.02785,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        ),
      ]
          : [
        Padding(
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.01),
          child: FittedBox(
            child: Text(
              "Unable to retrieve weather!",
              style: TextStyle(
                color: Color(0xff0A233E),
                fontFamily: 'roboto',
                fontSize: MediaQuery.of(context).size.height * 0.02785,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
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
        alignment: Alignment.center,
        child: BlocBuilder<BatteryCubit, BatteryState>(
          buildWhen: (prv, curr) => prv.percentage != curr.percentage,
          builder: (context, state) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.034,
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
                  padding: const EdgeInsets.only(left: 12.0,),
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
        child: InkWell(
          onTap: onPressed,
          child: Stack(
            children: [
              Positioned(
                top: !isBottomBadge ? 0.002 * MediaQuery.of(context).size.height : null,
                bottom: isBottomBadge ? 0.002 * MediaQuery.of(context).size.height : null,
                left:  0.025 * MediaQuery.of(context).size.width,
                right: 0,
                child: getBadgeIcon(),
              ),
              Container(
                padding: EdgeInsets.only(right: 5),
                width: 0.035 * MediaQuery.of(context).size.width,
                height: 0.05 * MediaQuery.of(context).size.height,
                child: SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Icon(
                      icon,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
