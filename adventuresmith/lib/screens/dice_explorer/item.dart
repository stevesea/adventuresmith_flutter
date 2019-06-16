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
  String _validatorStr;
  DiceExpressionModel _model;

  @override
  void initState() {
    _controller.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _debounce.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expressions = Provider.of<DiceExpressions>(context);
    _model = expressions.expressions[_index];

    if (_controller.text.isEmpty) {
      // only set controller text if it's empty. if we always reset the text,
      // then cursor position gets messed up
      _controller.text = _model.diceExpression;
    }

    var mean = _model.stats["mean"];
    var stddev = _model.stats["stddev"];
    var min = _model.stats['min'];
    var max = _model.stats['max'];

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
                  decoration: InputDecoration(
                    hintText: 'Enter a dice expression',
                    border: OutlineInputBorder(),
                    errorText: _model.validationError,
                  ),
                  onChanged: (val) {
                    if (val == _model.diceExpression) {
                      _debounce?.cancel();
                      return;
                    }
                    if (_debounce != null) {
                      _debounce.cancel();
                    }
                    _debounce = Timer(Duration(milliseconds: 500), () {
                      expressions.setExpr(_index, _controller.text);
                    });
                  },
                ),
              ),
              if (_model.hasStats)
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
