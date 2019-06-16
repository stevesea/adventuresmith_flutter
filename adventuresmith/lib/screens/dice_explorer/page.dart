import 'package:adventuresmith/models/dice_expression_model.dart';
import 'package:adventuresmith/screens/dice_explorer/item.dart';
import 'package:adventuresmith/screens/dice_explorer/stats.dart';
import 'package:adventuresmith/screens/dice_explorer/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                builder: buildDiceExprHelpDialog,
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
              child: ListView.separated(
                itemCount: diceExpressions.expressions.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) => DiceExpressionItem(index),
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
