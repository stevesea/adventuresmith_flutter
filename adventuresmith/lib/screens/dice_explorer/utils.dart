import 'package:charts_common/common.dart' as charts_common;
import 'package:flutter/material.dart';

/// list of palettes to use for different graphs
final palettes = [
  charts_common.MaterialPalette.blue,
  charts_common.MaterialPalette.green,
  charts_common.MaterialPalette.purple,
  charts_common.MaterialPalette.deepOrange,
  charts_common.MaterialPalette.red,
];

/// list of colors (from palettes)
final colors = [for (var p in palettes) _chartColorToColor(p.shadeDefault)];

Color _chartColorToColor(charts_common.Color c) {
  return Color.fromARGB(c.a, c.r, c.g, c.b);
}

AlertDialog buildDiceExprHelpDialog(BuildContext context) {
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
