import 'package:ffxiv_battle_logs/fflog_classes.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SkillDamageChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final bool vertical;

  SkillDamageChart(this.seriesList, {this.animate, this.vertical});

  @override
  _SkillDamageChartState createState() => _SkillDamageChartState();
}

class _SkillDamageChartState extends State<SkillDamageChart> {

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;

    return new charts.BarChart(
      widget.seriesList,
      animate: widget.animate,
      vertical: widget.vertical,
      barRendererDecorator: new charts.BarLabelDecorator<String>(
          labelAnchor: charts.BarLabelAnchor.end
      ),
      domainAxis: new charts.OrdinalAxisSpec(
        showAxisLine: true,
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

class SkillInfo {
  final Ability ability;
  final AbilityDamageInformation abilityDamageInformation;

  SkillInfo(this.ability, this.abilityDamageInformation);

}