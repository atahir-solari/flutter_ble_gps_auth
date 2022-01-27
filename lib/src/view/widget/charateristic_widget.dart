import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../theme/custom_theme.dart';

class CharateristicWidget extends StatelessWidget {
  const CharateristicWidget({
    Key? key,
    required this.characteristic,
  }) : super(key: key);

  final DiscoveredCharacteristic characteristic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              const TextSpan(
                text: 'Charateristic: ',
                style: TextStyle(fontWeight: FontWeight.bold, color: CustomTheme.purple),
              ),
              TextSpan(
                text: '${characteristic.characteristicId}',
                style: const TextStyle(
                  color: CustomTheme.blue,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          children: <_CharateristicCard>[
            _CharateristicCard(
              title: 'READABLE',
              value: characteristic.isReadable,
            ),
            _CharateristicCard(
              title: 'NOTIFIABLE',
              value: characteristic.isNotifiable,
            ),
            _CharateristicCard(
              title: 'INDICATABLE',
              value: characteristic.isIndicatable,
            ),
            _CharateristicCard(
              title: 'WRITABLE WITH RESPONSE',
              value: characteristic.isWritableWithResponse,
            ),
            _CharateristicCard(
              title: 'WRITE WITHOUT RESPONSE',
              value: characteristic.isWritableWithoutResponse,
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _CharateristicCard extends StatelessWidget {
  const _CharateristicCard({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return value
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            margin: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: CustomTheme.yellow,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Text(
              title,
              style: const TextStyle(color: CustomTheme.purple),
            ),
          )
        : const SizedBox.shrink();
  }
}
