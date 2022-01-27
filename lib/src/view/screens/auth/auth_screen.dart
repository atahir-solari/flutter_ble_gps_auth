import 'package:flutter/material.dart';
import 'package:flutter_local_auth_invisible/flutter_local_auth_invisible.dart';

import '../../theme/custom_theme.dart';
import 'auth_section.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AUTHENTICATION'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<bool>(
          future: LocalAuthentication.canCheckBiometrics,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              if (snapshot.data!)
                return const AuthSection();
              else
                return Text(
                  'This device does not support biometric authentication',
                  style: CustomTheme.listTileTitleStyle,
                );
            } else
              return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
