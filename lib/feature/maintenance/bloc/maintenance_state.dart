part of 'maintenance_bloc.dart';

class MaintenanceState extends Equatable {
  const MaintenanceState({
    required this.config,
    required this.contact,
    required this.currentPackage,
    required this.update,
    required this.updateAvailable,
  });

  factory MaintenanceState.initial() {
    return MaintenanceState(
        config: MaintenanceConfig(),
        contact: ContactConfig(),
        currentPackage: PackageInfo(
          appName: 'MobEx Health Hub',
          packageName: 'com.mobexhealth.mobex_hub',
          version: '0.0.0',
          buildNumber: '0',
        ),
        update: PackageInfo(
          appName: 'MobEx Health Hub',
          packageName: 'com.mobexhealth.mobex_hub',
          version: '0.0.0',
          buildNumber: '0',
        ),
        updateAvailable: false
    );
  }

  final MaintenanceConfig config;
  final ContactConfig contact;
  final PackageInfo currentPackage;
  final PackageInfo update;
  final bool updateAvailable;

  MaintenanceState copyWith({
    MaintenanceConfig? config,
    ContactConfig? contact,
    PackageInfo? currentPackage,
    PackageInfo? update,
    bool? updateAvailable,
  }) {
    return MaintenanceState(
      config: config ?? this.config,
      contact: contact ?? this.contact,
      currentPackage: currentPackage ?? this.currentPackage,
      update: update ?? this.update,
      updateAvailable: updateAvailable ?? this.updateAvailable,
    );
  }

  @override
  List<Object> get props =>
      [
        config,
        contact,
        currentPackage,
        update,
        updateAvailable,
      ];
}
