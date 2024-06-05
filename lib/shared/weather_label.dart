import 'package:flutter/material.dart';
import 'package:famici/core/enitity/weather.dart';
import 'package:famici/utils/barrel.dart';

class WeatherLabel extends StatelessWidget {
  WeatherLabel({Key? key, required this.weather, TextStyle? textStyle})
      : textStyle = textStyle ??
      FCStyle.textStyle.copyWith(
        color: Colors.black,
        fontFamily: 'roboto',
        fontSize: 14,
      ),
        super(key: key);
  final Weather weather;
  TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: (weather.location?.name ?? '').isNotEmpty
          ? [
        Image(
          image: AssetImage(
            weather.current?.condition?.icon
                ?.replaceFirst(
                '//cdn.weatherapi.com/', 'assets/icons/')
                .toString() ??
                '',
          ),
          height: FCStyle.xLargeFontSize * 2,
          fit: BoxFit.cover,
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: FittedBox(
              child: Text(
                "${weather.current?.tempF ?? ''}ºF ${weather.current?.condition?.text ?? ''}, ${weather.location?.name ?? ''}  ${weather.location?.region ?? ''} ",
                style: textStyle,
              ),
            ),
          ),
        ),
      ]
          : [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: FittedBox(
            child: Text(
              "Unable to retrieve weather!",
              style: TextStyle(
                fontSize: FCStyle.defaultFontSize,
              ),
            ),
          ),
        ),
      ],
    );
  }
}