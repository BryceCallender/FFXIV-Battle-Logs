import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ReportDataChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  ReportDataChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      barGroupingType: charts.BarGroupingType.grouped,
      barRendererDecorator: new charts.BarLabelDecorator<String>(
        labelAnchor: charts.BarLabelAnchor.end
      ),
    );
  }
}

/// Sample ordinal data type.
class DPSInfo {
  final String user;
  final double DPS; //Total / (end - start) * 1000
  final double rDPS; //TotalRDPS / (end - start) * 1000
  final charts.Color color;

  DPSInfo({this.user, this.DPS, this.rDPS, this.color});
}

class HPSInfo {
  final String user;
  final double overhealPercentage;
  final double HPS; //Total / (end - start) * 1000
  final charts.Color color;

  HPSInfo({this.user, this.overhealPercentage ,this.HPS, this.color});
}
