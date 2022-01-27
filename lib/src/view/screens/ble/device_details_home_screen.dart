import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import '../../../logic/connection/connection_provider.dart';
import '../../../logic/discover_services/discover_services_bloc.dart';
import '../../../logic/discover_services/discover_services_state.dart';
import '../../theme/custom_theme.dart';
import '../../widget/charateristic_widget.dart';

class DeviceDetailsHomeScreen extends StatelessWidget {
  const DeviceDetailsHomeScreen({
    Key? key,
    required this.discoveredDevice,
  }) : super(key: key);

  final DiscoveredDevice discoveredDevice;

  @override
  Widget build(_) {
    return Builder(
      builder: (BuildContext context) {
        final bool isDeviceConnected = context.watch<ConnectionProvider>().deviceConnectionState == DeviceConnectionState.connected;
        final bool isDeviceDisconnected = context.watch<ConnectionProvider>().deviceConnectionState == DeviceConnectionState.disconnected;
        final DeviceConnectionState connectionState = context.watch<ConnectionProvider>().deviceConnectionState;
        return ListView(
          padding: const EdgeInsets.all(12),
          children: <Widget>[
            ListTile(
              title: Text(
                discoveredDevice.name.isEmpty ? 'Uknown Device' : discoveredDevice.name,
                style: CustomTheme.listTileTitleStyle,
              ),
              subtitle: Text(
                discoveredDevice.id,
                style: CustomTheme.listTileSubitleStyle,
              ),
              trailing: Text(
                connectionState == DeviceConnectionState.connected
                    ? 'Connected!'
                    : (connectionState == DeviceConnectionState.disconnected
                        ? 'Disonnected!'
                        : (connectionState == DeviceConnectionState.connecting ? 'Connecting...' : 'Disconnecting...')),
                style: const TextStyle(color: CustomTheme.purple),
              ),
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (isDeviceConnected || isDeviceDisconnected)
                    Icon(
                      isDeviceConnected ? Icons.bluetooth_connected_rounded : Icons.bluetooth_disabled_rounded,
                      color: CustomTheme.yellow,
                    )
                  else
                    const CircularProgressIndicator()
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    onPressed: isDeviceDisconnected
                        ? () {
                            context.read<ConnectionProvider>().connect(discoveredDevice.id);
                          }
                        : null,
                    color: CustomTheme.blue,
                    child: Text(
                      'Connect',
                      style: TextStyle(
                        color: isDeviceDisconnected ? CustomTheme.white : CustomTheme.purple.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MaterialButton(
                    onPressed: isDeviceConnected
                        ? () {
                            context.read<ConnectionProvider>().disconnect(discoveredDevice.id);
                          }
                        : null,
                    color: CustomTheme.blue,
                    child: Text(
                      'Disonnect',
                      style: TextStyle(
                        color: isDeviceConnected ? CustomTheme.white : CustomTheme.purple.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            MaterialButton(
              onPressed: isDeviceConnected
                  ? () async {
                      context.read<DiscoverServicesBloc>().discoverServices(discoveredDevice.id);
                    }
                  : null,
              color: CustomTheme.yellow,
              child: Text(
                'Discover Services',
                style: TextStyle(
                  color: isDeviceConnected ? CustomTheme.purple : CustomTheme.purple.withOpacity(0.5),
                ),
              ),
            ),
            for (DiscoveredService service in context.watch<DiscoverServicesState>().dicoveredServices)
              ExpansionTile(
                title: Text(
                  '${service.serviceId}',
                  style: const TextStyle(
                    color: CustomTheme.blue,
                    fontSize: 16,
                  ),
                ),
                iconColor: CustomTheme.purple,
                collapsedIconColor: CustomTheme.purple,
                expandedAlignment: Alignment.centerLeft,
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.zero,
                children: <CharateristicWidget>[
                  for (DiscoveredCharacteristic characteristic in service.characteristics) CharateristicWidget(characteristic: characteristic),
                ],
              )
          ],
        );
      },
    );
  }
}
