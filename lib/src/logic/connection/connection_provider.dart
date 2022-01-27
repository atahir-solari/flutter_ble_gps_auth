import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class ConnectionProvider extends ChangeNotifier {
  ConnectionStateUpdate _connectionStateUpdate = const ConnectionStateUpdate(
    deviceId: 'Unknown device',
    connectionState: DeviceConnectionState.disconnected,
    failure: null,
  );

  String get deviceId => _connectionStateUpdate.deviceId;
  DeviceConnectionState get deviceConnectionState => _connectionStateUpdate.connectionState;

  StreamSubscription<ConnectionStateUpdate>? _subscription;

  void connect(String deviceId) {
    _subscription = FlutterReactiveBle()
        .connectToDevice(
      id: deviceId,
      connectionTimeout: const Duration(seconds: 10),
    )
        .listen(
      (ConnectionStateUpdate update) {
        // print('ConnectionState for device $deviceId : ${update.connectionState}');
        _connectionStateUpdate = update;
        notifyListeners();
      },
    );
  }

  Future<void> disconnect(String deviceId) async {
    try {
      // print('disconnecting to device: $deviceId');
      await _subscription?.cancel();
    } on Exception catch (e, _) {
      //  print('Error disconnecting from a device: $e');
    } finally {
      // Since subscription is terminated, the "disconnected" state cannot be received and propagated
      _connectionStateUpdate = ConnectionStateUpdate(
        deviceId: deviceId,
        connectionState: DeviceConnectionState.disconnected,
        failure: null,
      );
      notifyListeners();
    }
  }
}
