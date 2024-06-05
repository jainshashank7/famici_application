import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:famici/core/enitity/weather.dart';
import 'package:famici/repositories/barrel.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WheatherEvent, WheatherState> {
  WeatherBloc() : super(WheatherState.initial()) {
    on<StartTimeAndLocationStream>(_mapStartTimeAndLocationStreamToState);
    on<FetchWeather>(_mapFetchWeatherEventToState);
    add(StartTimeAndLocationStream());
  }

  Future getAllPermissions() async {
    print("Requesting for permissions");

    try {
      var cameraStatus = await Permission.camera.status;
      var microPhoneStatus = await Permission.microphone.status;
      var notificationStatus = await Permission.notification.status;

      if (cameraStatus.isDenied ||
          microPhoneStatus.isDenied ||
          notificationStatus.isDenied ||
          await Permission.bluetoothScan.isDenied ||
          await Permission.bluetooth.isDenied ||
          await Permission.location.isDenied) {
        await [
          Permission.camera,
          Permission.microphone,
          Permission.notification,
          Permission.location,
          Permission.bluetoothScan,
          Permission.bluetooth,
          Permission.bluetoothConnect,
          Permission.locationAlways,
          Permission.locationWhenInUse,
        ].request();
      }
    } on Exception catch (e) {
      DebugLogger.error(e);
    }

    // Change Start - himesh.maurya

    // print("Microphone permission Status");
    // print(await Permission.microphone.status);

    // await Permission.microphone.request();
    //
    // await Permission.camera.request();

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    //
    // List<Permission> permissions = [
    //   Permission.notification,
    //   Permission.camera,
    //   Permission.microphone,
    //   Permission.location,
    //   Permission.bluetoothScan,
    //   Permission.bluetooth,
    //   Permission.bluetoothConnect,
    //   Permission.locationAlways,
    //   Permission.locationWhenInUse,
    // ];
    //
    //
    //
    // for (var permission in permissions) {
    //   try {
    //     if(await permission.isDenied) {
    //       await permission.request();
    //     }
    //   } catch(err){
    //     DebugLogger.error(err);
    //   }
    // }

    // Change End - himesh.maurya
  }

  StreamSubscription? _timeSubscription;
  final WeatherRepository _weatherRepository = WeatherRepository();

  void _mapStartTimeAndLocationStreamToState(
    WheatherEvent event,
    Emitter<WheatherState> emit,
  ) async {
    await getAllPermissions();

    try {
      bool isLocationEnabled =
          await GeolocatorPlatform.instance.isLocationServiceEnabled();
      LocationPermission permission;
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      bool hasPermission = permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;

      //Change Start - himesh.maurya
      // await getAllPermissions();
      //Change End - himesh.maurya

      if (isLocationEnabled && hasPermission) {
        add(FetchWeather());
      } else {
        throw Exception('Unable to fin location');
      }
    } catch (e) {
      DebugLogger.error(e.toString());
    }
  }

  void _mapFetchWeatherEventToState(
    FetchWeather event,
    Emitter<WheatherState> emit,
  ) async {
    try {
      emit(state.copyWith(status: WeatherStatus.loading));

      Position? position = await GeolocatorPlatform.instance.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );

      Weather _current = await _weatherRepository.fetchWeather(
        lat: position.latitude,
        lon: position.longitude,
      );
      emit(state.copyWith(weather: _current, status: WeatherStatus.success));
    } catch (err) {
      emit(state.copyWith(status: WeatherStatus.failure));
    }
  }

  @override
  Future<void> close() {
    _timeSubscription?.cancel();
    return super.close();
  }
}
