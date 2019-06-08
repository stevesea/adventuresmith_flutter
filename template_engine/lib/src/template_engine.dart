import 'package:adventuresmith_template_engine/src/grammar.dart';
import 'package:dart_dice_parser/dart_dice_parser.dart';
import 'package:petitparser/petitparser.dart';

///
///

class TemplateEngine {
  DiceParser _diceParser;

  TemplateEngine({DiceParser diceParser}) {
    _diceParser = diceParser ?? DiceParser();
  }

  Result<dynamic> parse(String template, Map<String, dynamic> ctxt) {
    var parser = JsonParser();

    return parser.parse(template);
  }
}
