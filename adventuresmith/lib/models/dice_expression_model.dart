import 'dart:collection';

import 'package:dart_dice_parser/dart_dice_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';

/// represents the current set of dice expressions being displayed
class DiceExpressions with ChangeNotifier {
  final _expressions = <DiceExpressionModel>[];

  /// retrieve current list of expressions
  UnmodifiableListView<DiceExpressionModel> get expressions =>
      UnmodifiableListView(_expressions);

  bool get hasResults {
    var filtered = _expressions.where((expr) => expr.hasStats);
    return filtered.isNotEmpty;
  }

  /// add a new expression
  void add(final DiceExpressionModel item) {
    _expressions.add(item);
    notifyListeners();
  }

  void setExpr(final int index, final String expr) {
    if (index < _expressions.length && index >= 0) {
      _expressions[index].setExpression(expr);
      notifyListeners();
    }
  }

  /// remove expression at given index
  void remove(final int ind) {
    _expressions.removeAt(ind);
    notifyListeners();
  }
}

/// a dice expression, parsing results, and related stats.
class DiceExpressionModel {
  static final numRollsForStats = 10000;
  final _log = Logger('DiceExpressionModel');
  DiceParser _diceParser;

  /// Constructs a new DiceExpressionModel, optionally injected with a [DiceParser].
  DiceExpressionModel([DiceParser dp]) {
    _diceParser = dp ?? DiceParser();
  }

  /// the current dice expression
  String get diceExpression => _diceExpression;
  String _diceExpression;

  /// null if no error on latest expression

  String get validationError => _validationError;
  String _validationError;

  /// the stats related to the current expression
  UnmodifiableMapView<String, dynamic> get stats => UnmodifiableMapView(_stats);
  Map<String, dynamic> _stats = {};

  /// is stats map populated?
  bool get hasStats => _stats.isNotEmpty;

  /// sets the current dice expression
  void setExpression(String expr) async {
    _log.finest(expr);
    _diceExpression = expr.trim();

    // if null or empty, clear out state
    if (expr == null || expr.isEmpty) {
      _stats = {};
      _validationError = null;
      return;
    }

    _validationError = _validator(diceExpression);
    if (_validationError != null) {
      _stats = {};
    } else {
      _stats = await _diceParser.stats(
          diceStr: diceExpression, numRolls: numRollsForStats);
      _log.fine(_stats);
    }
  }

  final RegExp _diceExp = RegExp(r'^[dDcClLhHF0-9 +-<>%#!=]*$');

  /// returns null if OK, string otherwise
  String _validator(String val) {
    if (!_diceExp.hasMatch(val)) {
      return "invalid char in dice expression";
    }

    var results = _diceParser.parse(val);

    if (results.isFailure) {
      return "invalid dice expression";
    } else {
      return null;
    }
  }
}
