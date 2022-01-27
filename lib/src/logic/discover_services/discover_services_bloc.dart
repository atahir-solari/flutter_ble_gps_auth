import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'discover_services_state.dart';

class DiscoverServicesBloc {
  final StreamController<DiscoverServicesState> _controller = StreamController<DiscoverServicesState>();
  Stream<DiscoverServicesState> get state => _controller.stream;
  List<DiscoveredService> _discoveredServices = <DiscoveredService>[];

  Future<void> discoverServices(String id) async {
    _discoveredServices = await FlutterReactiveBle().discoverServices(id);
    _updateState();
  }

  void clear() {
    _discoveredServices = <DiscoveredService>[];
    _updateState();
  }

  void _updateState() => _controller.add(DiscoverServicesState(_discoveredServices));
}
