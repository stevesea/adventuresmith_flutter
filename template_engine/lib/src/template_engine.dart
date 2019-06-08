import 'package:dart_dice_parser/dart_dice_parser.dart';
import 'package:petitparser/petitparser.dart';

///
///

class AdventureSmithTemplate {
  Parser _parser;

  DiceParser _diceParser;

  AdventureSmithTemplate({DiceParser diceParser}) {
    _parser = _build();
    _diceParser = diceParser ?? DiceParser();
  }

  Parser _build() {
    var builder = ExpressionBuilder();
    // build groups in descending order of operations
    // * parens, ints
    // * variations of dice-expr
    // * mult
    // * add/sub
    builder.group()
      // match ints. will return null if empty
      ..primitive(digit()
          .star()
          .flatten('integer expected') // create string result of digit*
          .trim() // trim whitespace
          .map((a) => a.isNotEmpty ? int.parse(a) : null))
      // handle parens
      ..wrapper(char('(').trim(), char(')').trim(), (l, a, r) => a);
    return builder.build().end();
  }
}
