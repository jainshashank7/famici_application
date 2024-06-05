part of 'connectivity_bloc.dart';

class ConnectivityState extends Equatable {
  const ConnectivityState({
    required this.isBluetoothOn,
    required this.hasInternet,
    required this.connection,
    required this.isWifiOn,
  });

  final bool isBluetoothOn;
  final bool hasInternet;
  final bool isWifiOn;
  final ConnectivityResult connection;

  factory ConnectivityState.initial() {
    return ConnectivityState(
      isBluetoothOn: false,
      isWifiOn: false,
      hasInternet: false,
      connection: ConnectivityResult.none,
    );
  }

  ConnectivityState copyWith({
    bool? isBluetoothOn,
    bool? hasInternet,
    bool? isWifiOn,
    ConnectivityResult? connection,
  }) {
    return ConnectivityState(
      isBluetoothOn: isBluetoothOn ?? this.isBluetoothOn,
      isWifiOn: isWifiOn ?? this.isWifiOn,
      hasInternet: hasInternet ?? this.hasInternet,
      connection: connection ?? this.connection,
    );
  }

  @override
  List<Object?> get props => [isBluetoothOn, isWifiOn, hasInternet, connection];
}
