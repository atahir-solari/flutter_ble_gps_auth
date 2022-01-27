import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'scan_state.dart';

class ScanBloc {
  final StreamController<ScanState> _controller = StreamController<ScanState>();
  Stream<ScanState> get state => _controller.stream;
  StreamSubscription<DiscoveredDevice>? _subscription;

  final List<DiscoveredDevice> _devices = <DiscoveredDevice>[];

  void startScan() {
    _devices.clear();
    _subscription?.cancel();
    _subscription = FlutterReactiveBle().scanForDevices(
      withServices: <Uuid>[
        //  Uuid.parse('2456e1b9-26e2-8f83-e744-f34f01e9d701'),
      ],
    ).listen(
      (DiscoveredDevice device) {
        final int knownDeviceIndex = _devices.indexWhere((DiscoveredDevice d) => d.id == device.id);
        if (knownDeviceIndex >= 0) {
          _devices[knownDeviceIndex] = device;
        } else {
          _devices.add(device);
        }
        _updateState();
      },
      // onError: (Object e) => print('Device scan fails with error: $e'),
    );
    _updateState();
  }

  Future<void> stopScan() async {
    await _subscription?.cancel();
    _subscription = null;
    _updateState();
  }

  void _updateState() => _controller.add(
        ScanState(
          discoveredDevices: _devices,
          isScanInProgress: _subscription != null,
        ),
      );
}
