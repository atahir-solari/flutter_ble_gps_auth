import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../logic/scan/scan_bloc.dart';
import '../../../logic/scan/scan_state.dart';
import '../../theme/custom_theme.dart';
import '../gps/gps_screen.dart';
import 'device_details_screen.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScanBloc _scanBloc = ScanBloc();

    return MultiProvider(
      providers: <SingleChildWidget>[
        // used to controll scan (start/stop)
        Provider<ScanBloc>.value(value: _scanBloc),

        // used to know the status of the scan
        StreamProvider<ScanState>(
          create: (_) => _scanBloc.state,
          initialData: const ScanState(
            discoveredDevices: <DiscoveredDevice>[],
            isScanInProgress: false,
          ),
        ),
      ],
      builder: (BuildContext context, _) {
        final bool isScanInProgress = Provider.of<ScanState>(context).isScanInProgress;
        final List<DiscoveredDevice> discoveredDevices = Provider.of<ScanState>(context).discoveredDevices;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'SCAN DEVICES',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: <IconButton>[
              IconButton(
                onPressed: () {
                  if (isScanInProgress) {
                    context.read<ScanBloc>().stopScan();
                  }
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => GpsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.location_on_rounded),
              )
            ],
          ),
          body: ListView(
            children: <Widget>[
              Visibility(
                visible: isScanInProgress,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: const LinearProgressIndicator(),
              ),
              ListView.builder(
                itemCount: discoveredDevices.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      discoveredDevices[index].name.isEmpty ? 'Unknown Device' : discoveredDevices[index].name,
                      style: CustomTheme.listTileTitleStyle,
                    ),
                    subtitle: RichText(
                      text: TextSpan(
                        style: CustomTheme.listTileSubitleStyle,
                        children: <TextSpan>[
                          const TextSpan(text: 'ID: ', style: TextStyle(color: CustomTheme.purple)),
                          TextSpan(
                            text: discoveredDevices[index].id,
                          ),
                          const TextSpan(text: '\nRSSI: ', style: TextStyle(color: CustomTheme.purple)),
                          TextSpan(
                            text: '${discoveredDevices[index].rssi}',
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        context.read<ScanBloc>().stopScan();
                        Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => DeviceDetailsScreen(
                              discoveredDevice: discoveredDevices[index],
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.navigate_next_rounded,
                        color: CustomTheme.purple,
                      ),
                      splashColor: CustomTheme.blue,
                      highlightColor: CustomTheme.blue.withOpacity(0.25),
                    ),
                  );
                },
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(12),
            child: FloatingActionButton(
              onPressed: isScanInProgress ? context.watch<ScanBloc>().stopScan : context.watch<ScanBloc>().startScan,
              child: Icon(isScanInProgress ? Icons.stop : Icons.sensors_rounded),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
