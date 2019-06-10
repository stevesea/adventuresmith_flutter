import 'package:dart_dice_parser/dart_dice_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:petitparser/petitparser.dart';

/// represents the current set of dice expressions being displayed
class DiceExpressions with ChangeNotifier {
  List<DiceExpressionModel> _expressions;

  /// retrieve current list of expressions
  List<DiceExpressionModel> get expressions => _expressions;

  /// add a new expression
  void add(DiceExpressionModel item) {
    _expressions.add(item);
    notifyListeners();
  }

  /// remove expression at given index
  void remove(int ind) {
    _expressions.removeAt(ind);
    notifyListeners();
  }
}

/// a dice expression, parsing results, and related stats.
class DiceExpressionModel with ChangeNotifier {
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
  Map<String, dynamic> _stats;

  /// result of parsing the current expression
  Result<dynamic> get parseResults => _parseResults;
  Result<dynamic> _parseResults;

  /// simple flag saying whether there's an error or not
  bool get hasError => _hasError;
  bool _hasError;

  /// sets the current dice expression
  void setExpression(String _expr) {
    _diceExpression = _expr;
    _parseResults = _diceParser.parse(_diceExpression);
    if (_parseResults.isFailure) {
      _hasError = true;
    } else {
      _stats = _diceParser.stats(diceStr: diceExpression);
    }

    notifyListeners();
  }
}
