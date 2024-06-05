import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:famici/utils/config/api_config.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:version/version.dart';

import '../../../utils/constants/regexp.dart';
import '../entity/contact_config.dart';
import '../entity/maintenance_config.dart';
import '../screeen/update_popup.dart';

part 'maintenance_event.dart';

part 'maintenance_state.dart';

class MaintenanceBloc extends Bloc<MaintenanceEvent, MaintenanceState> {
  MaintenanceBloc() : super(MaintenanceState.initial()) {
    on<MaintenanceInitializedMaintenanceEvent>(
      _onMaintenanceInitializedMaintenanceEvent,
    );
    on<ConfigChangedMaintenanceEvent>(
      _onConfigChangedMaintenanceEvent,
    );
    on<ContactConfigChangedMaintenanceEvent>(
      _onContactConfigChangedMaintenanceEvent,
    );
    on<GoToUpdateFromStoreMaintenanceEvent>(
      _onGoToUpdateFromStoreMaintenanceEvent,
    );
    on<CheckUpdates>(
      _onCheckUpdatesEvent,
    );
  }

  StreamSubscription? _configStream;
  StreamSubscription? _contactStream;
  StreamSubscription? _updateStream;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  _onMaintenanceInitializedMaintenanceEvent(
    MaintenanceInitializedMaintenanceEvent event,
    emit,
  ) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      emit(state.copyWith(currentPackage: packageInfo));
    } catch (err) {
      DebugLogger.error(err);
    }

    _configStream = _fireStore
        .collection('config')
        .doc('famici_app')
        .snapshots()
        .listen((docSnap) {
      MaintenanceConfig config = MaintenanceConfig.fromJson(docSnap.data());
      add(ConfigChangedMaintenanceEvent(config: config));
    });
    _contactStream = _fireStore
        .collection('config')
        .doc('contact')
        .snapshots()
        .listen((docSnap) {
      ContactConfig contact = ContactConfig.fromJson(docSnap.data());
      add(ContactConfigChangedMaintenanceEvent(contact: contact));
    });
  }

  _onContactConfigChangedMaintenanceEvent(
    ContactConfigChangedMaintenanceEvent event,
    emit,
  ) {
    emit(state.copyWith(contact: event.contact));
  }

  _onConfigChangedMaintenanceEvent(
    ConfigChangedMaintenanceEvent event,
    emit,
  ) {
    int currentVersion = int.parse(
      state.currentPackage.version.replaceAll(numberOnlyRegexp, ""),
    );

    int latestVersion = int.parse(
      event.config.version.replaceAll(numberOnlyRegexp, ""),
    );

    bool updateAvailable = latestVersion > currentVersion;
    bool forceUpdateRequired = updateAvailable && event.config.forceUpdate;
    emit(state.copyWith(
        config: event.config.copyWith(
      forceUpdate: forceUpdateRequired,
    )));
  }

  _onGoToUpdateFromStoreMaintenanceEvent(
    GoToUpdateFromStoreMaintenanceEvent event,
    emit,
  ) {
    try {
      if (Platform.isAndroid) {
        launchUrlString(
          "https://play.google.com/store/apps/details?id=${state.currentPackage.packageName}",
        );
      }
      if (Platform.isIOS) {
        launchUrlString(
          "https://apps.apple.com/us/app/family-connect-member/id1620005773",
        );
      }
    } catch (e) {
      DebugLogger.error(e);
    }
  }

  @override
  close() async {
    _configStream?.cancel();
    _contactStream?.cancel();
    _updateStream?.cancel();
    _configStream = null;
    _contactStream = null;
    _updateStream = null;
    super.close();
  }

  FutureOr<void> _onCheckUpdatesEvent(
      CheckUpdates event, Emitter<MaintenanceState> emit) {
    _updateStream = _fireStore
        .collection('update')
        .doc(FirebaseConfig.current)
        .snapshots()
        .listen((docSnap) async {
      Map<String, dynamic>? json = docSnap.data();
      PackageInfo update = PackageInfo(
          appName: 'MobEx Health Hub',
          packageName: 'com.mobexhealth.mobex_hub',
          version: json?["version"] ?? '0.0.0',
          buildNumber: json?["build"] ?? '0',
          buildSignature: json?["link"] ?? "null");

      bool mandatory = json?["mandatory"] ?? false;
      String notes = json?["note"] ??
          "You're using an older version of the app.  To access new features and improvements, please update the app now.";

      // print("this is updates");
      // print(update.buildSignature);
      // print(update.buildNumber);
      // print(update.version);
      // print(update.appName);
      // print(update.packageName);

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      // emit(state.copyWith(currentPackage: packageInfo));

      // print("package info");
      // print(packageInfo.version);
      // print(packageInfo.buildNumber);

      Version currentV = Version.parse(packageInfo.version);
      Version newV = Version.parse(update.version);

      if (newV > currentV) {
        print("update available");
        // emit(state.copyWith(updateAvailable: true, update: update));
        UpdatePopUp.showUpdate(update, mandatory, notes);
      }
    });
  }
}
