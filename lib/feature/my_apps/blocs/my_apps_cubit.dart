import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:device_apps/device_apps.dart';
import 'package:equatable/equatable.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:famici/feature/my_apps/entities/barrel.dart';
import 'package:famici/repositories/my_app_repository.dart';
import 'package:famici/utils/barrel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/blocs/connectivity_bloc/connectivity_bloc.dart';
import '../../../core/enitity/user.dart';

part 'my_apps_state.dart';

class MyAppsCubit extends Cubit<MyAppsState> {
  MyAppsCubit({
    required User me,
  })  : _me = me,
        super(MyAppsState.initial());

  final User _me;
  final MyAppRepository _myAppRepository = MyAppRepository();
  // final ConnectivityBloc connectivityBloc = ConnectivityBloc();

  Future<void> openLyft() async {
    try {
      await LaunchApp.openApp(androidPackageName: lyftBundleId);
    } catch (err) {
      try {
        await launchUrl(Uri.parse(lyftPlayStoreUrl));
      } catch (err) {
        DebugLogger.error(err);
      }
    }
  }

  Future<void> openContentDelivery() async {
    try {
      await LaunchApp.openApp(androidPackageName: contentDeliveryBundleId);
    } catch (err) {
      try {
        await launchUrl(Uri.parse(contentDeliveryPlayStoreUrl));
      } catch (err) {
        DebugLogger.error(err);
      }
    }
  }

  Future<void> syncInternetLinks() async {
    emit(state.copyWith(status: Status.loading));

    List<UrlLink> links = await _myAppRepository.getLinks(
      familyId: _me.familyId,
    );

    if (connectivityBloc.state.isWifiOn) {
      // links.insert(
      //     0, UrlLink(description: "Search on Google", link: googleUrl));
    }
    emit(state.copyWith(links: links, status: Status.success));
  }

  Future<void> toggleFullScreen() async {
    bool isFullScreen = state.isFullScreen;
    emit(state.copyWith(isFullScreen: !isFullScreen));
  }

  Future<void> loadingInternetUrl() async {
    emit(state.copyWith(status: Status.loading));
  }

  Future<void> loadedInternetUrl() async {
    emit(state.copyWith(status: Status.success));
  }

  Future<void> loadingInternetPage() async {
    emit(state.copyWith(initialPageLoaded: false));
  }

  Future<void> loadedInternetPage() async {
    emit(state.copyWith(initialPageLoaded: true));
  }

  Future<void> gameLoading() async {
    emit(state.copyWith(status: Status.loading));
  }

  Future<void> gameLoaded() async {
    emit(state.copyWith(status: Status.success));
  }

  Future<void> launchWebPortal() async {
    final portalUrl =
        '${mobexHealthDeepLink(_me.customAttribute2.companySubDomain)}?username=${_me.email}';
    await launchUrl(
      Uri.parse(portalUrl),
      mode: LaunchMode.externalApplication,
    );
  }
}
