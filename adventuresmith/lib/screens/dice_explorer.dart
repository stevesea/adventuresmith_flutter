import 'package:adventuresmith/models/dice_expression_model.dart';
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

  static List<charts.Series<OrdinalDiceResult, String>> gatherStats(
      DiceExpressions diceExpressions) {
    var stats = <charts.Series<OrdinalDiceResult, String>>[];
    for (final diceExpressionModel in diceExpressions.expressions) {
      if (diceExpressionModel.stats.isNotEmpty) {
        var histAsList = <OrdinalDiceResult>[];
        var hist = diceExpressionModel.stats['histogram'] ?? <int, int>{};
        if (hist is Map<int, int>) {
          histAsList = hist.entries
              .map((e) => OrdinalDiceResult(e.key, e.value))
              .toList();
        }

        stats.add(charts.Series<OrdinalDiceResult, String>(
          id: diceExpressionModel.diceExpression,
          domainFn: (OrdinalDiceResult r, _) => r.result.toString(),
          measureFn: (OrdinalDiceResult r, _) => r.count,
          data: histAsList,
        ));
      }
    }
    return stats;
  }

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
                child: charts.BarChart(
                  gatherStats(diceExpressions),
                  animate: false,
                  barGroupingType: charts.BarGroupingType.grouped,
                  behaviors: [charts.SeriesLegend()],
                ),
              ),
            ]),
      );
    });
  }
}

class DiceExpressionItem extends StatelessWidget {
  final int index;

  const DiceExpressionItem(this.index, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger _log = Logger('DiceExplorer');

    final expressions = Provider.of<DiceExpressions>(context);
    final expressionModel = expressions.expressions[index];

    final controller =
        TextEditingController(text: expressionModel.diceExpression);

    final statsKeys = ['min', 'max', 'median', 'mean', 'standardDeviation'];
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
                      child:
                          Text(expressionModel.stats['min'].toString() ?? ""),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("max:"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text(expressionModel.stats['max'].toString() ?? ""),
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
                      child: Text(
                          expressionModel.stats['median'].toString() ?? ""),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("mean:"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text(expressionModel.stats['mean'].toString() ?? ""),
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
                      child: Text(expressionModel.stats['standardDeviation']
                              .toString() ??
                          ""),
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
