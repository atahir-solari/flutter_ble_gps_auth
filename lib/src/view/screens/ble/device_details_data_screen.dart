import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../logic/connection/connection_provider.dart';
import '../../../logic/subscription/subscription_bloc.dart';
import '../../../logic/subscription/subscription_state.dart';
import '../../theme/custom_theme.dart';
import '../../widget/info_data_widget.dart';
import '../../widget/piechart_widget.dart';

class DeviceDetailDataScreen extends StatefulWidget {
  const DeviceDetailDataScreen({
    Key? key,
    required this.discoveredDevice,
  }) : super(key: key);
  final DiscoveredDevice discoveredDevice;

  @override
  State<DeviceDetailDataScreen> createState() => _DeviceDetailDataScreenState();
}

class _DeviceDetailDataScreenState extends State<DeviceDetailDataScreen> {
  Timer? timer;

  @override
  void dispose() {
    if (timer != null) {
      timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDeviceConnected = context.watch<ConnectionProvider>().deviceConnectionState == DeviceConnectionState.connected;
    final SubscriptionBloc _subscriptionBloc = SubscriptionBloc();

    return isDeviceConnected
        ? MultiProvider(
            providers: <SingleChildWidget>[
              // manage subscription and writes
              Provider<SubscriptionBloc>.value(value: _subscriptionBloc),

              // used to get data in real time
              StreamProvider<SubscriptionState>(
                create: (_) => _subscriptionBloc.state,
                initialData: SubscriptionState(),
              ),
            ],
            builder: (BuildContext context, _) {
              if (context.read<ConnectionProvider>().deviceConnectionState == DeviceConnectionState.connected) {
                context.read<SubscriptionBloc>().subscribe(widget.discoveredDevice.id);
                context.read<SubscriptionBloc>().updateData(widget.discoveredDevice.id);

                timer = Timer.periodic(const Duration(seconds: 1), (_) {
                  context.read<SubscriptionBloc>().updateData(widget.discoveredDevice.id);
                });
              }
              if (context.read<SubscriptionState>().isError) {
                return Center(
                  child: Text(
                    "Error, can't write characteristics",
                    style: CustomTheme.listTileTitleStyle,
                  ),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(12),
                children: <InfoDataWidget>[
                  InfoDataWidget(
                    title: 'Ram Memory',
                    content: PiechartWidget(
                      dataMap: <String, double>{
                        'Free Ram Memory': double.tryParse(context.watch<SubscriptionState>().freeRam) ?? 0,
                        'Used Ram Memory': 100 - (double.tryParse(context.watch<SubscriptionState>().freeRam) ?? 0),
                      },
                    ),
                  ),
                  InfoDataWidget(
                    title: 'Cpu Temperature',
                    content: Text(
                      '${context.watch<SubscriptionState>().cpuTemperature} °C',
                      style: const TextStyle(color: CustomTheme.white),
                    ),
                  ),
                  InfoDataWidget(
                    title: 'System Temperature',
                    content: Text(
                      '${context.watch<SubscriptionState>().systemTemperature} °C',
                      style: const TextStyle(color: CustomTheme.white),
                    ),
                  ),
                  InfoDataWidget(
                    title: 'Cpu Usage',
                    content: PiechartWidget(
                      dataMap: <String, double>{
                        'Used Cpu': double.parse(context.watch<SubscriptionState>().cpuUsage),
                        'Available Cpu': 100 - double.parse(context.watch<SubscriptionState>().cpuUsage),
                      },
                    ),
                  ),
                  InfoDataWidget(
                    title: 'Sensor Temperature',
                    content: Text(
                      '${context.watch<SubscriptionState>().sensorTemperature} °C',
                      style: const TextStyle(color: CustomTheme.white),
                    ),
                  ),
                  InfoDataWidget(
                    title: 'Disk',
                    content: PiechartWidget(
                      dataMap: <String, double>{
                        'Free Disk Space': double.tryParse(context.watch<SubscriptionState>().freeDisk) ?? 0,
                        'Used Disk Space': 100 - (double.tryParse(context.watch<SubscriptionState>().freeDisk) ?? 0),
                      },
                    ),
                  ),
                ],
              );
            },
          )
        : Center(
            child: Text(
              'Device is not connected',
              style: CustomTheme.listTileTitleStyle,
            ),
          );
  }
}
