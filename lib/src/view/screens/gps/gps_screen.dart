import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../theme/custom_theme.dart';
import '../initial_screen.dart';

class GpsScreen extends StatelessWidget {
  GpsScreen({Key? key}) : super(key: key);

  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('LOCATION'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<dynamic>(
                  builder: (_) => const InitialScreen(),
                ),
              );
            },
            icon: const Icon(Icons.bluetooth_rounded),
          ),
        ],
      ),
      body: OSMFlutter(
        androidHotReloadSupport: true,
        controller: mapController,
        trackMyPosition: true,
        initZoom: 13,
        mapIsLoading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Loading map...'),
          ],
        ),
        userLocationMarker: UserLocationMaker(
          personMarker: const MarkerIcon(
            icon: Icon(
              Icons.push_pin_rounded,
              color: CustomTheme.purple,
              size: 68,
            ),
          ),
          directionArrowMarker: const MarkerIcon(
            icon: Icon(
              Icons.double_arrow,
              color: CustomTheme.purple,
              size: 48,
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const SizedBox(width: 32),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <ElevatedButton>[
              ElevatedButton(
                onPressed: mapController.zoomIn,
                child: const Icon(Icons.add_rounded),
              ),
              ElevatedButton(
                onPressed: mapController.zoomOut,
                child: const Icon(Icons.remove_rounded),
              ),
            ],
          ),
          const Spacer(),
          FloatingActionButton(
            onPressed: mapController.currentLocation,
            child: const Icon(Icons.gps_fixed_rounded),
          ),
        ],
      ),
    );
  }
}
