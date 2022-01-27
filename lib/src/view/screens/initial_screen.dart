import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'ble/scan_screen.dart';
import 'error_screen.dart';
import 'loading_screen.dart';

// screen to decide which screen should be shown based on ble status
class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(_) {
    return Builder(
      builder: (_) {
        return StreamBuilder<BleStatus>(
          stream: FlutterReactiveBle().statusStream,
          initialData: BleStatus.unknown,
          builder: (_, AsyncSnapshot<BleStatus> snapshot) {
            final BleStatus status = snapshot.data!;
            return status == BleStatus.ready ? const ScanScreen() : (status == BleStatus.unknown ? const LoadingScreen() : StatusScreen(status: status));
          },
        );
      },
    );
  }
}
