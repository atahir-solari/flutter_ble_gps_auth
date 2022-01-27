import 'package:flutter/material.dart';
import 'package:flutter_local_auth_invisible/flutter_local_auth_invisible.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../theme/custom_theme.dart';
import '../initial_screen.dart';

class AuthSection extends StatelessWidget {
  const AuthSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Select authentication method',
            style: CustomTheme.listTileTitleStyle,
          ),
          MaterialButton(
            color: CustomTheme.blue,
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    bool isPinWrong = false;
                    return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
                      return AlertDialog(
                        title: Text(
                          'Insert Pin (0-0-0-0)',
                          style: CustomTheme.listTileTitleStyle,
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            PinCodeTextField(
                              appContext: context,
                              length: 4,
                              animationType: AnimationType.scale,
                              cursorColor: CustomTheme.purple,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.circle,
                                borderRadius: BorderRadius.circular(5),
                                selectedColor: CustomTheme.yellow,
                                selectedFillColor: CustomTheme.yellow,
                                inactiveFillColor: CustomTheme.purple,
                                inactiveColor: CustomTheme.purple,
                                activeColor: CustomTheme.purple,
                                activeFillColor: Colors.white,
                              ),
                              onChanged: (String code) {
                                if (code.length < 4 && isPinWrong) {
                                  setState(() {
                                    isPinWrong = false;
                                  });
                                }
                              },
                              onCompleted: (String code) {
                                if (code == '0000') {
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) => const InitialScreen(),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    isPinWrong = true;
                                  });
                                }
                              },
                              keyboardType: TextInputType.number,
                            ),
                            if (isPinWrong)
                              const Text(
                                'Wrong',
                                style: TextStyle(color: CustomTheme.blue),
                              )
                          ],
                        ),
                      );
                    });
                  });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Passcode',
                  style: CustomTheme.listTileSubitleStyle.copyWith(
                    fontSize: 15,
                    color: CustomTheme.white,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.person_rounded,
                  color: CustomTheme.white,
                ),
              ],
            ),
          ),
          MaterialButton(
            color: CustomTheme.yellow,
            onPressed: () async {
              final List<BiometricType> biometricTypes = await LocalAuthentication.getAvailableBiometrics();
              if (biometricTypes.contains(BiometricType.fingerprint)) {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    try {
                      LocalAuthentication.authenticate(
                        localizedReason: 'Please authenticate',
                      ).asStream().listen((bool data) {
                        // if authenticated go to new screen
                        if (data) {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => const InitialScreen(),
                            ),
                          );
                        }
                      });
                    } catch (e) {
                      // print('error in authentication: $e');
                    }

                    return SizedBox(
                      height: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Authenticate',
                            style: CustomTheme.listTileTitleStyle,
                          ),
                          const SizedBox(height: 20),
                          const Icon(
                            Icons.fingerprint_rounded,
                            size: 70,
                            color: CustomTheme.yellow,
                          ),
                        ],
                      ),
                    );
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ).whenComplete(() => LocalAuthentication.stopAuthentication());
              } else {
                // alert user if fingerprint is not supported
                showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                    title: Text('Error'),
                    content: Text('Fingerprint is not supported on this device'),
                  ),
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Fingerprint',
                  style: CustomTheme.listTileSubitleStyle.copyWith(fontSize: 15, color: CustomTheme.purple),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.fingerprint_rounded,
                  color: CustomTheme.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
