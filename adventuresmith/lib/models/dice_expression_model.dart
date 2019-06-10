import 'package:dart_dice_parser/dart_dice_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:petitparser/petitparser.dart';

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

  /// result of parsing the current expression
  Result<dynamic> get parseResults => _parseResults;
  Result<dynamic> _parseResults;

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

    _parseResults = _diceParser.parse(_diceExpression);
    if (_parseResults.isFailure) {
      _stats = {};
    } else {
      _stats = _diceParser.stats(
          diceStr: diceExpression, numRolls: numRollsForStats);
      _log.finest(_stats);
    }
  }

  //final RegExp diceExp = RegExp(r'[A-Za-z0-9 +-<>');

  /// returns null if OK, string otherwise
  String validator(String val) {
    _log.warning("validating $val");
    return "valid";
  }
}
