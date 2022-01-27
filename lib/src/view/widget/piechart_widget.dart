import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../theme/custom_theme.dart';

class PiechartWidget extends StatelessWidget {
  const PiechartWidget({Key? key, required this.dataMap}) : super(key: key);

  final Map<String, double> dataMap;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      chartType: ChartType.ring,
      chartValuesOptions: const ChartValuesOptions(
        showChartValuesInPercentage: true,
        chartValueStyle: TextStyle(
          color: CustomTheme.purple,
        ),
      ),
      colorList: const <Color>[
        CustomTheme.yellow,
        CustomTheme.purple,
      ],
      legendOptions: const LegendOptions(
        legendTextStyle: TextStyle(
          color: CustomTheme.white,
        ),
      ),
      dataMap: dataMap,
    );
  }
}
