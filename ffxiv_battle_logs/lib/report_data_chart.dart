import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ReportDataChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final bool vertical;

  ReportDataChart(this.seriesList, {this.animate, this.vertical});

  @override
  _ReportDataChartState createState() => _ReportDataChartState();
}

class _ReportDataChartState extends State<ReportDataChart> {

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;

    return new charts.BarChart(
      widget.seriesList,
      animate: widget.animate,
      vertical: widget.vertical,
      barGroupingType: charts.BarGroupingType.grouped,
      barRendererDecorator: new charts.BarLabelDecorator<String>(
        labelAnchor: charts.BarLabelAnchor.end
      ),
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
            // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  color: brightness == Brightness.dark? charts.MaterialPalette.white : charts.MaterialPalette.black),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: brightness == Brightness.dark? charts.MaterialPalette.white : charts.MaterialPalette.black),
          )
      ),
      /// Assign a custom style for the measure axis.
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(

            // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  color: brightness == Brightness.dark? charts.MaterialPalette.white : charts.MaterialPalette.black),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: brightness == Brightness.dark? charts.MaterialPalette.white : charts.MaterialPalette.black),
          ),
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
