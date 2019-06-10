import 'package:adventuresmith/models/dice_expression_model.dart';
import 'package:charts_common/common.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class OrdinalDiceResult {
  final int result;
  final int count;

  OrdinalDiceResult(this.result, this.count);
}

class DiceExplorer extends StatelessWidget {
  const DiceExplorer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DiceExpressions>(builder: (context, diceExpressions, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: diceExpressions.expressions.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) => DiceExpressionItem(index),
                ),
              ),
              Divider(),
              Expanded(
                child: DiceStats(diceExpressions.expressions),
              ),
            ]),
      );
    });
  }
}

@immutable
class DiceStats extends StatelessWidget {
  static final palettes = [
    MaterialPalette.blue,
    MaterialPalette.green,
    MaterialPalette.red,
  ];

  final List<DiceExpressionModel> exprs;
  const DiceStats(this.exprs, {Key key}) : super(key: key);

  List<charts.Series<OrdinalDiceResult, int>> gatherSeries() {
    var stats = <charts.Series<OrdinalDiceResult, int>>[];
    var ind = 0;
    for (final diceExpressionModel in exprs) {
      if (diceExpressionModel.hasStats) {
        var histAsList = <OrdinalDiceResult>[];
        var hist = diceExpressionModel.stats['histogram'] ?? <int, int>{};
        var palette = palettes[ind].shadeDefault;
        if (hist is Map<int, int>) {
          histAsList = hist.entries
              .map((e) => OrdinalDiceResult(e.key, e.value))
              .toList();
        }

        stats.add(charts.Series<OrdinalDiceResult, int>(
          id: diceExpressionModel.diceExpression,
          domainFn: (OrdinalDiceResult r, _) => r.result,
          measureFn: (OrdinalDiceResult r, _) => r.count,
          data: histAsList,
          colorFn: (_, __) => palette,
        ));
      }
      ind++;
    }
    return stats;
  }

  List<charts.ChartBehavior> gatherBehaviors() {
    var behaviors = <charts.ChartBehavior>[];
    var rangeAnnotations = <AnnotationSegment>[];
    var ind = 0;
    for (final diceExpressionModel in exprs) {
      if (diceExpressionModel.hasStats) {
        var median = diceExpressionModel.stats["median"];
        var stddev = diceExpressionModel.stats["standardDeviation"];
        var low = median - stddev;
        var high = median + stddev;
        var palette = palettes[ind].shadeDefault;
        rangeAnnotations.add(charts.RangeAnnotationSegment(
          low,
          high,
          charts.RangeAnnotationAxisType.domain,
          startLabel: low.toString(),
          endLabel: high.toString(),
        ));
        rangeAnnotations.add(
          charts.LineAnnotationSegment(
            median,
            charts.RangeAnnotationAxisType.domain,
            startLabel: median.toString(),
            color: palette.lighter,
          ),
        );
      }
      ind++;
    }
    behaviors.add(charts.RangeAnnotation(rangeAnnotations));
    return behaviors;
  }

  @override
  Widget build(BuildContext context) {
    var seriesList = gatherSeries();
    if (seriesList.isEmpty) {
      seriesList.add(
        charts.Series<OrdinalDiceResult, int>(
          id: "",
          domainFn: (OrdinalDiceResult r, _) => r.result,
          measureFn: (OrdinalDiceResult r, _) => r.count,
          data: [],
        ),
      );
    }
    return charts.LineChart(
      seriesList,
      animate: true,
      behaviors: gatherBehaviors(),
      primaryMeasureAxis: charts.NumericAxisSpec(
        showAxisLine: false, // don't show axis line
        renderSpec: charts.NoneRenderSpec(),
      ),
    );
  }
}

@immutable
class DiceExpressionItem extends StatelessWidget {
  final int index;

  const DiceExpressionItem(this.index, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger _log = Logger('DiceExplorer');

    final expressions = Provider.of<DiceExpressions>(context);
    final model = expressions.expressions[index];

    final controller = TextEditingController(text: model.diceExpression);

    final statsKeys = ['min', 'max', 'median', 'mean', 'standardDeviation'];

    final medianResults = <Widget>[];
    if (model.hasStats) {
      medianResults.addAll([
        Spacer(),
        Text("Median:"),
        Text(model.stats["median"].toString()),
        Text("+/-"),
        Text(model.stats["standardDeviation"].toString()),
      ]);
    }
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'Enter a dice expression',
          ),
          controller: controller,
          onSubmitted: (val) {
            _log.info("$val");
            expressions.setExpr(index, val);
          },
        ),
        Row(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Text("min:"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(model.stats['min'].toString() ?? ""),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("max:"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(model.stats['max'].toString() ?? ""),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Column(
              children: [
                Row(
                  children: [
                    Text("median:"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(model.stats['median'].toString() ?? ""),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("mean:"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(model.stats['mean'].toString() ?? ""),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Column(
              children: [
                Row(
                  children: [
                    Text("stddev:"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          model.stats['standardDeviation'].toString() ?? ""),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
