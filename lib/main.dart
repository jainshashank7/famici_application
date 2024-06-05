import 'dart:async';
import 'dart:developer' as developer;

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:famici/core/local_database/local_db.dart';
import 'package:famici/famici_app.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/helpers/audio_player_handler.dart';
import 'package:timezone/data/latest.dart';
import 'core/blocs/bloc_observer.dart';
import 'core/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'core/offline/local_database/users_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  connectivityBloc.add(ListenToConnectivityStatus());
  connectivityBloc.add(CheckInternetConnectivity());

  await EasyLocalization.ensureInitialized();

  await LocalDatabaseFactory.createDatabase();
  await DatabaseHelperForUsers.initDb();

  await FCAmplify.initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  NotificationHelper.initializeNotificationsPlugin();
  initializeTimeZones();
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationSupportDirectory(),
  );
  print("hi this is storage " + getApplicationSupportDirectory().toString());

  await FirebaseHelper.initializeFirebasePlugins();
  await AudioServiceHandler.initialize();
  // await initialize(IsolatedBlocManager.isolateInitializer);

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);

    final charts = await rootBundle.loadString('license/fl_charts.txt');
    yield LicenseEntryWithLineBreaks(['fl_charts'], charts);
  });

  runZonedGuarded(() async => bootstrap(storage: storage), onError);
}

void bootstrap({required HydratedStorage storage}) {
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  BlocOverrides.runZoned(
        () => HydratedBlocOverrides.runZoned(
          () => runApp(
        EasyLocalization(
          path: 'assets/langs',
          supportedLocales: supportedLocales,
          fallbackLocale: supportedLocales.first,
          saveLocale: true,
          child: const FamiciApp(),
        ),
      ),
      blocObserver: BlocDelegateObserver(),
      storage: storage,
    ),
    blocObserver: BlocDelegateObserver(),
  );
}

void onError(dynamic error, StackTrace stack) {
  developer.log(error.toString());
  developer.log(stack.toString());
  FirebaseCrashlytics.instance.recordError(error, stack);
}

