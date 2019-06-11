import 'package:dart_dice_parser/dart_dice_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';

/// represents the current set of dice expressions being displayed
class DiceExpressions with ChangeNotifier {
  final _expressions = <DiceExpressionModel>[];

  /// retrieve current list of expressions
  List<DiceExpressionModel> get expressions => _expressions;

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

  /// the stats related to the current expression
  Map<String, dynamic> get stats => _stats;
  Map<String, dynamic> _stats = {};

  /// is stats map populated?
  bool get hasStats => _stats.isNotEmpty;

  /// sets the current dice expression
  void setExpression(String expr) {
    _log.finest(expr);
    _diceExpression = expr;
    if (expr == null || expr.isEmpty) {
      _stats = {};
      return;
    }

    var results = _diceParser.parse(_diceExpression);
    if (results.isFailure) {
      _stats = {};
    } else {
      _stats = _diceParser.stats(
          diceStr: diceExpression, numRolls: numRollsForStats);
      _log.finest(_stats);
    }
  }

  /// returns null if OK, string otherwise
  String validator(String val) {
    final RegExp diceExp = RegExp(r'^[dDcClLhHF0-9 +-<>%]*$');
    if (!diceExp.hasMatch(val)) {
      return "valid characters: dclhF, 0-9";
    }

    var results = _diceParser.parse(val);

    if (results.isFailure) {
      _log.warning("Invalid $results");
      return "err at position ${results.position}";
    } else {
      return null;
    }
  }
}
