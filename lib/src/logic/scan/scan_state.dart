import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class ScanState {
  const ScanState({
    required this.discoveredDevices,
    required this.isScanInProgress,
  });

  final List<DiscoveredDevice> discoveredDevices;
  final bool isScanInProgress;
}
