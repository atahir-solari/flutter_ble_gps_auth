import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../theme/custom_theme.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({
    Key? key,
    required this.status,
  }) : super(key: key);

  final BleStatus status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WARNING'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          _getMessageFromStatus(status),
          style: CustomTheme.listTileTitleStyle,
        ),
      ),
    );
  }

  String _getMessageFromStatus(BleStatus status) {
    switch (status) {
      case BleStatus.unsupported:
        return 'This device is not supported';
      case BleStatus.poweredOff:
        return 'Bluetooth is turned off';
      case BleStatus.locationServicesDisabled:
        return 'This app have not access to location services';
      case BleStatus.unauthorized:
      default: // Unauthorized status
        return 'Authorize the app to use Bluetooth and location';
    }
  }
}
