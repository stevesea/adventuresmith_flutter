import 'dart:async';

import 'package:adventuresmith/models/dice_expression_model.dart';
import 'package:charts_common/common.dart' as charts_common;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

/// list of palettes to use for different graphs
final palettes = [
  charts_common.MaterialPalette.blue,
  charts_common.MaterialPalette.green,
  charts_common.MaterialPalette.purple,
  charts_common.MaterialPalette.deepOrange,
  charts_common.MaterialPalette.red,
];

final colors = [for (var p in palettes) chartColorToColor(p.shadeDefault)];

Color chartColorToColor(charts_common.Color c) {
  return Color.fromARGB(c.a, c.r, c.g, c.b);
}

Color paletteIndexToColor(int index) {
  return chartColorToColor(palettes[index].shadeDefault);
}

class OrdinalDiceResult {
  final num result;
  final num count;

  OrdinalDiceResult(this.result, this.count);
}

class DiceExplorerPage extends StatelessWidget {
  const DiceExplorerPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dice Stats Explorer'),
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              showDialog(
                context: context,
                builder: buildAlertDialog,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: DiceExplorerScreen(),
      ),
    );
  }

  AlertDialog buildAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Dice Syntax", style: Theme.of(context).textTheme.headline),
      content: Container(
        width: double.maxFinite,
        child: ListView(
          children: [
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Dice types\n",
                    style: Theme.of(context).textTheme.title,
                  ),
                  TextSpan(
                    text: 'AdX',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  TextSpan(
                    text: ' : roll A dice of X sides\n',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  TextSpan(
                    text: 'AdF',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  TextSpan(
                    text: ' : roll A fudge dice\n',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  TextSpan(
                    text: 'Ad%',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  TextSpan(
                    text: ' : roll A 100-sided dice\n',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  TextSpan(
                    text: 'AD66',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  TextSpan(
                    text: ' : roll 1d6*10 + 1d6\n',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  TextSpan(
                    text: 'Ad!X',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  TextSpan(
                    text: ' : roll A dice of X sides (explode)\n',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  TextSpan(
                    text: 'Ad!!X',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  TextSpan(
                    text: ' : roll A dice of X sides (explode once)\n',
                    style: Theme.of(context).textTheme.body1,
                  ),
                ],
              ),
            ),
            Divider(),
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Modifying results\n",
                    style: Theme.of(context).textTheme.title,
                  ),
                  TextSpan(
                    text: 'AdX-HN, AdX-LN',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  TextSpan(
                    text: ' : drop N highest or lowest\n',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  TextSpan(
                    text: 'AdX->B, AdX-<B, AdX-=B',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  TextSpan(
                    text:
                        ' : drop any greater than, less than, or equal to B\n\n',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  TextSpan(
                    text: 'AdXC<B, AdXC>B',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  TextSpan(
                    text:
                        ' : change any value less than or greater than B to B\n',
                    style: Theme.of(context).textTheme.body1,
                  ),
                ],
              ),
            ),
            Divider(),
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Counting results\n",
                    style: Theme.of(context).textTheme.title,
                  ),
                  TextSpan(
                    text: 'AdX#>B, AdX#<B, AdX#=B',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  TextSpan(
                    text:
                        ' : count how many results are greater than, less than, or equal to B\n\n',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  TextSpan(
                    text: 'AdX#',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  TextSpan(
                    text:
                        ' : how many results? \n`20d10-<2->8#` roll 2d10, drop <2 and >8, count # left \n',
                    style: Theme.of(context).textTheme.body1,
                  ),
                ],
              ),
            ),
            Divider(),
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Arithmetic\n",
                    style: Theme.of(context).textTheme.title,
                  ),
                  TextSpan(
                    text:
                        'addition, subtraction, multiplication and parenthesis are supported',
                    style: Theme.of(context).textTheme.body1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class DiceExplorerScreen extends StatelessWidget {
  const DiceExplorerScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DiceExpressions>(builder: (context, diceExpressions, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ListView.separated(
                  itemCount: diceExpressions.expressions.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) => DiceExpressionItem(index),
                ),
              ),
            ),
            if (diceExpressions.hasResults) Divider(),
            if (diceExpressions.hasResults)
              Text("total rolls: ${DiceExpressionModel.numRollsForStats}"),
            Divider(),
            if (diceExpressions.hasResults)
              Expanded(
                child: DiceStats(diceExpressions.expressions),
              ),
          ],
        ),
      );
    });
  }
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

class DiceExpressionItem extends StatefulWidget {
  final int index;

  @override
  DiceExpressionItemState createState() {
    return DiceExpressionItemState(index);
  }

  DiceExpressionItem(this.index, {Key key}) : super(key: key);
}

class DiceExpressionItemState extends State<DiceExpressionItem> {
  Color get color => paletteIndexToColor(_index);
  final int _index;
  DiceExpressionItemState(this._index);
  final _log = Logger('DiceExpressionItemState');
  var _controller = TextEditingController();
  Timer _debounce;

  @override
  Widget build(BuildContext context) {
    final expressions = Provider.of<DiceExpressions>(context);
    final model = expressions.expressions[_index];
    _controller.text = model.diceExpression;

    var mean = model.stats["mean"];
    var stddev = model.stats["stddev"];
    var min = model.stats['min'];
    var max = model.stats['max'];

    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: color,
        unselectedWidgetColor: color,
        iconTheme: IconThemeData(color: color),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  MdiIcons.diceMultiple,
                ),
                onPressed: () {},
              ),
              Flexible(
                child: TextField(
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.continueAction,
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Enter a dice expression',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    var duration = Duration(seconds: 5);

                    if (val == model.diceExpression) {
                      return;
                    }
                    if (_debounce != null) {
                      _debounce.cancel();
                    }
                    _debounce = Timer(duration, () {
                      expressions.setExpr(_index, _controller.text);
                    });
                  },
                  onEditingComplete: () {
                    if (_debounce != null) {
                      _debounce.cancel();
                    }
                    Future(() {
                      expressions.setExpr(_index, _controller.text);
                    });
                  },
                  onSubmitted: (_) {
                    if (_debounce != null) {
                      _debounce.cancel();
                    }
                    Future(() {
                      expressions.setExpr(_index, _controller.text);
                    });
                  },
                ),
              ),
              if (model.hasStats)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(children: [
                    Row(
                      children: [
                        Text("${mean ?? '?'} ± ${stddev ?? '?'}"),
                      ],
                    ),
                    Row(
                      children: [
                        Text("min, max:"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${min ?? '?'} ↔ ${max ?? '?'}"),
                        ),
                      ],
                    ),
                  ]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
