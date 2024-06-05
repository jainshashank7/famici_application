import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/utils/barrel.dart';

import '../../../../core/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'device_status_indicator.dart';

class ConnectivityStatusWidget extends StatelessWidget {
  const ConnectivityStatusWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, connectivity) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 24.0,
          ),
          child: Row(
            children: [
              Row(
                children: [
                  DeviceStatusIndicator(
                    connected: connectivity.isBluetoothOn,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Bluetooth',
                      style: FCStyle.textStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  DeviceStatusIndicator(
                    connected: connectivity.isWifiOn,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Wifi', style: FCStyle.textStyle),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
