import 'package:adventuresmith/models/dice_expression_model.dart';
import 'package:adventuresmith/screens/dice_explorer/utils.dart';
import 'package:charts_common/common.dart' as charts_common;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class OrdinalDiceResult {
  final num result;
  final num count;

  OrdinalDiceResult(this.result, this.count);
}

/// Widget to display dice stats from given expressions
@immutable
class DiceStats extends StatelessWidget {
  final List<DiceExpressionModel> _expressions;

  /// ctor for DiceStats widget
  const DiceStats(this._expressions, {Key key}) : super(key: key);

  /// convert the DiceExpressionModel's stats into series for the line chart
  List<charts.Series<OrdinalDiceResult, num>> gatherSeries() {
    var series = <charts.Series<OrdinalDiceResult, num>>[];
    var ind = 0;
    for (final diceExpressionModel in _expressions) {
      if (diceExpressionModel.hasStats) {
        var histAsList = <OrdinalDiceResult>[];

        var hist = diceExpressionModel.stats['histogram'] ?? <num, num>{};
        var palette = palettes[ind].shadeDefault;
        if (hist is Map<num, num>) {
          histAsList = hist.entries
              .map((e) => OrdinalDiceResult(e.key, e.value))
              .toList();
        }

        series.add(charts.Series<OrdinalDiceResult, num>(
          id: diceExpressionModel.diceExpression,
          domainFn: (r, _) => r.result,
          measureFn: (r, _) => r.count,
          data: histAsList,
          colorFn: (_, __) => palette,
        ));

        var mean = diceExpressionModel.stats["mean"];
        var stddev = diceExpressionModel.stats["stddev"];
        var low = mean - stddev;
        var high = mean + stddev;

        series.add(charts.Series<OrdinalDiceResult, num>(
          id: "${diceExpressionModel.diceExpression} annotation $ind",
          domainFn: (r, _) => mean,
          domainLowerBoundFn: (r, _) => low,
          domainUpperBoundFn: (r, _) => high,
          measureFn: (_, __) =>
              null, // no measure values are needed for symbol annotations
          data: [
            OrdinalDiceResult(low, null),
            OrdinalDiceResult(mean, null),
            OrdinalDiceResult(high, null),
          ],
          colorFn: (_, __) => palette,
        )..setAttribute(charts.rendererIdKey, 'customSymbolAnnotation'));
      }
      ind++;
    }
    return series;
  }

  /// retrieve chart behaviors (range / line annotations, legend settings, etc)
  List<charts.ChartBehavior> gatherBehaviors() {
    var behaviors = <charts.ChartBehavior>[];

    var annotations = <charts_common.AnnotationSegment>[];
    var ind = 0;
    for (final diceExpressionModel in _expressions) {
      if (diceExpressionModel.hasStats) {
        var mean = diceExpressionModel.stats["mean"];
        var palette = palettes[ind].shadeDefault;
        /*
        var stddev = diceExpressionModel.stats["stddev"];
        var low = mean - stddev;
        var high = mean + stddev;
        annotations.add(charts.RangeAnnotationSegment(
          low,
          high,
          charts.RangeAnnotationAxisType.domain,
          startLabel: low.toString(),
          endLabel: high.toString(),
          color: palette.lighter.lighter.lighter,
          labelAnchor: charts.AnnotationLabelAnchor.start,
          labelDirection: charts.AnnotationLabelDirection.vertical,
        ));

         */

        annotations.add(
          charts.LineAnnotationSegment(
            mean,
            charts.RangeAnnotationAxisType.domain,
            startLabel: mean.toString(),
            color: palette.lighter,
            labelAnchor: charts.AnnotationLabelAnchor.end,
            labelDirection: charts.AnnotationLabelDirection.vertical,
          ),
        );
      }
      ind++;
    }

    behaviors.add(charts.RangeAnnotation(
      annotations,
      //seems to only work if label direction is horizontal,
      // but, horiz labels makes spacing labels hard
      //defaultLabelPosition: charts.AnnotationLabelPosition.margin,
    ));

    // don't enable series legend until figure out how to hide series.
    // (otherwise, the annotation series highlighting mean+stddev shows up)
    //behaviors.add(charts.SeriesLegend());
    return behaviors;
  }

  @override
  Widget build(BuildContext context) {
    var seriesList = gatherSeries();
    if (seriesList.isEmpty) {
      // if there are no series to display, fill in dummy values
      seriesList.add(
        charts.Series<OrdinalDiceResult, num>(
          id: "",
          domainFn: (r, _) => r.result,
          measureFn: (r, _) => r.count,
          data: [],
        ),
      );
    }
    return charts.LineChart(
      seriesList,
      animate: true,
      behaviors: gatherBehaviors(),
      /*
      primaryMeasureAxis: charts.NumericAxisSpec(
        showAxisLine: false, // don't show axis line
        renderSpec: charts.NoneRenderSpec(),
      ),

       */
      customSeriesRenderers: [
        charts.SymbolAnnotationRendererConfig(
          customRendererId: 'customSymbolAnnotation',
        ),
      ],
    );
  }
}
