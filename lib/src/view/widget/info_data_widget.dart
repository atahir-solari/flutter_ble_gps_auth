import 'package:flutter/material.dart';
import '../theme/custom_theme.dart';

class InfoDataWidget extends StatelessWidget {
  const InfoDataWidget({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: CustomTheme.blue,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: CustomTheme.white,
            ),
          ),
          content,
        ],
      ),
    );
  }
}
