import 'dart:async';

import 'package:adventuresmith/models/dice_expression_model.dart';
import 'package:adventuresmith/screens/dice_explorer/utils.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class DiceExpressionItem extends StatefulWidget {
  final int index;

  @override
  DiceExpressionItemState createState() {
    return DiceExpressionItemState(index);
  }

  DiceExpressionItem(this.index, {Key key}) : super(key: key);
}

class DiceExpressionItemState extends State<DiceExpressionItem> {
  Color get color => colors[_index];
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
                          child: Text("${min ?? '?'} → ${max ?? '?'}"),
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
