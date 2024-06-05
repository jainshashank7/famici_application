import 'dart:convert';

MaintenanceConfig maintenanceConfigFromJson(String str) =>
    MaintenanceConfig.fromJson(json.decode(str));

String maintenanceConfigToJson(MaintenanceConfig data) =>
    json.encode(data.toJson());

class MaintenanceConfig {
  MaintenanceConfig({
    this.maintenance = false,
    this.version = '0.0.1',
    this.forceUpdate = false,
    this.build = 0,
  });

  final bool maintenance;
  final String version;
  final bool forceUpdate;
  final int build;

  MaintenanceConfig copyWith({
    bool? maintenance,
    String? version,
    bool? forceUpdate,
    int? build,
  }) =>
      MaintenanceConfig(
        maintenance: maintenance ?? this.maintenance,
        version: version ?? this.version,
        forceUpdate: forceUpdate ?? this.forceUpdate,
        build: build ?? this.build,
      );

  factory MaintenanceConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return MaintenanceConfig();
    }
    return MaintenanceConfig(
      maintenance: json["maintenance"],
      version: json["version"],
      forceUpdate: json["force_update"],
      build: json["build"],
    );
  }

  Map<String, dynamic> toJson() => {
        "maintenance": maintenance,
        "version": version,
        "force_update": forceUpdate,
        "build": build,
      };
}
