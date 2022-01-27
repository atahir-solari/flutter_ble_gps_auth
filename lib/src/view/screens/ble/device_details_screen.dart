import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../logic/connection/connection_provider.dart';
import '../../../logic/discover_services/discover_services_bloc.dart';
import '../../../logic/discover_services/discover_services_state.dart';
import '../../theme/custom_theme.dart';
import 'device_details_data_screen.dart';
import 'device_details_home_screen.dart';

class DeviceDetailsScreen extends StatefulWidget {
  const DeviceDetailsScreen({
    Key? key,
    required this.discoveredDevice,
  }) : super(key: key);

  final DiscoveredDevice discoveredDevice;

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  int pageIndex = 0;
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final DiscoverServicesBloc _discoverServicesBloc = DiscoverServicesBloc();

    return MultiProvider(
      providers: <SingleChildWidget>[
        // manage connection
        ChangeNotifierProvider<ConnectionProvider>(create: (_) => ConnectionProvider()),

        // used to manage services
        Provider<DiscoverServicesBloc>.value(value: _discoverServicesBloc),

        // used to get stream info about services
        StreamProvider<DiscoverServicesState>(
          create: (_) => _discoverServicesBloc.state,
          initialData: DiscoverServicesState(<DiscoveredService>[]),
        ),
      ],
      builder: (BuildContext context, _) {
        return WillPopScope(
          // disconnect from device when this screen is closed
          onWillPop: () async {
            context.read<DiscoverServicesBloc>().clear();
            context.read<ConnectionProvider>().disconnect(widget.discoveredDevice.id);
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.discoveredDevice.name.isEmpty ? 'Uknown Device' : widget.discoveredDevice.name),
              centerTitle: true,
            ),
            body: PageView(
              controller: _controller,
              onPageChanged: (int newIndex) {
                if (newIndex != pageIndex) {
                  setState(() {
                    pageIndex = newIndex;
                  });
                }
              },
              children: <Widget>[
                DeviceDetailsHomeScreen(discoveredDevice: widget.discoveredDevice),
                DeviceDetailDataScreen(discoveredDevice: widget.discoveredDevice),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: pageIndex,
              onTap: (int newIndex) {
                if (newIndex != pageIndex) {
                  setState(() {
                    pageIndex = newIndex;
                  });
                  _controller.animateToPage(newIndex, duration: const Duration(milliseconds: 200), curve: Curves.ease);
                }
              },
              selectedItemColor: CustomTheme.blue,
              unselectedItemColor: CustomTheme.purple,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.data_saver_off),
                  label: 'Data',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
