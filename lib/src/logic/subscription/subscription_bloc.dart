// ignore_for_file: avoid_dynamic_calls, avoid_redundant_argument_values
import 'dart:async';
import 'dart:convert';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:uuid/uuid.dart' as uuid;

import 'subscription_state.dart';

class SubscriptionBloc {
  final StreamController<SubscriptionState> _controller = StreamController<SubscriptionState>();
  Stream<SubscriptionState> get state => _controller.stream;

  // starting values
  String _freeRam = '0';
  String _cpuTemperature = '0';
  String _systemTemperature = '0';
  String _cpuUsage = '0';
  String _sensorTemperature = '0';
  String _freeDisk = '0';
  bool _isError = false;

  Future<int> _requestMtu({
    required String deviceId,
    required int mtu,
  }) async =>
      FlutterReactiveBle().requestMtu(deviceId: deviceId, mtu: mtu);

  QualifiedCharacteristic _getCharacteristicById(String deviceId) => QualifiedCharacteristic(
      deviceId: deviceId, characteristicId: Uuid.parse('2456e1b9-26e2-8f83-e744-f34f01e9d703'), serviceId: Uuid.parse('2456e1b9-26e2-8f83-e744-f34f01e9d701'));

  Future<void> subscribe(String deviceId) async {
    final QualifiedCharacteristic characteristic = _getCharacteristicById(deviceId);

    try {
      // request MTU (default 244)
      await _requestMtu(deviceId: deviceId, mtu: 244);

      FlutterReactiveBle().subscribeToCharacteristic(characteristic).listen((List<int> data) {
        final String jsonString = String.fromCharCodes(data);
        final Map<String, dynamic> json = jsonDecode(jsonString) as Map<String, dynamic>;

        if (json['F']['Field'] == 'FREERAM')
          _freeRam = json['F']['Value'] as String;
        else if (json['F']['Field'] == 'CPUTEMPERATURE')
          _cpuTemperature = json['F']['Value'] as String;
        else if (json['F']['Field'] == 'SYSTEMTEMPERATURE')
          _systemTemperature = json['F']['Value'] as String;
        else if (json['F']['Field'] == 'CPUUSAGE')
          _cpuUsage = json['F']['Value'] as String;
        else if (json['F']['Field'] == 'VC1_SENSORTEMPERATURE')
          _sensorTemperature = json['F']['Value'] as String;
        else if (json['F']['Field'] == 'FREEDISK') _freeDisk = json['F']['Value'] as String;

        _isError = false;
      });
    } catch (e) {
      // print('An error occured trying to subscribe to device: $e');
      _isError = true;
    } finally {
      _updateState();
    }
  }

  Future<void> updateData(String deviceId) async {
    String message;

    try {
      message = '12{"F":{"Field":"FREERAM","Value":""}, "T":0,"Id":"$_getRandomUuid"}';
      await _writeCharacteristic(deviceId: deviceId, message: message);

      message = '12{"F":{"Field":"CPUTEMPERATURE","Value":""}, "T":0,"Id":"$_getRandomUuid"}';
      await _writeCharacteristic(deviceId: deviceId, message: message);

      message = '12{"F":{"Field":"SYSTEMTEMPERATURE","Value":""}, "T":0,"Id":"$_getRandomUuid"}';
      await _writeCharacteristic(deviceId: deviceId, message: message);

      message = '12{"F":{"Field":"CPUUSAGE","Value":""}, "T":0,"Id":"$_getRandomUuid"}';
      await _writeCharacteristic(deviceId: deviceId, message: message);

      message = '12{"F":{"Field":"VC1_SENSORTEMPERATURE","Value":""}, "T":0,"Id":"$_getRandomUuid"}';
      await _writeCharacteristic(deviceId: deviceId, message: message);

      message = '12{"F":{"Field":"FREEDISK","Value":""}, "T":0,"Id":"$_getRandomUuid"}';
      await _writeCharacteristic(deviceId: deviceId, message: message);
    } catch (e) {
      // print('An error occured trying to write characteristic: $e');
      _isError = true;
      _updateState();
    }
  }

  String _getRandomUuid() => const uuid.Uuid().v4();

  Future<void> _writeCharacteristic({required String deviceId, required String message}) async {
    final QualifiedCharacteristic characteristic = _getCharacteristicById(deviceId);

    await FlutterReactiveBle().writeCharacteristicWithoutResponse(
      characteristic,
      value: utf8.encode(message) + <int>[13],
    );
  }

  void _updateState() => _controller.add(SubscriptionState(
        freeRam: _freeRam,
        cpuTemperature: _cpuTemperature,
        systemTemperature: _systemTemperature,
        cpuUsage: _cpuUsage,
        sensorTemperature: _sensorTemperature,
        freeDisk: _freeDisk,
        isError: _isError,
      ));
}
