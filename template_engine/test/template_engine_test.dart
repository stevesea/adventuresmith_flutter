import 'package:adventuresmith_template_engine/src/grammar.dart';
import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';

class TokenizedListGrammarDefinition extends GrammarDefinition {
  Parser start() => ref(body).end();
  /*
  list() => ref(element) & char(',') & ref(list) | ref(element);
  element() => digit().plus().flatten().trim();
  */
  Parser body() => ref(WHITESPACE).star();
  Parser list() => ref(element) & char(',') & ref(list) | ref(element);
  Parser element() => ref(token, digit().plus().trim());
  Parser token(Object input) {
    if (input is Parser) {
      return input.token().trim();
    } else if (input is String) {
      return token(input.length == 1 ? char(input) : string(input));
    } else if (input is Function) {
      return token(ref(input));
    }
    throw ArgumentError.value(input, 'invalid token parser');
  }

  Parser NEWLINE() => pattern('\n\r');

  Parser WHITESPACE() => whitespace();
}

void main() {
  setUp(() async {});
  group('test loader', () {
    test('test', () {
      var parser = JsonParser();

      var template = """
[1, 2, 3, 4, 5]
        """;
      var result = parser.parse(template);

      if (result.isFailure) {
        print("""
Parsing failure:
    $template
    ${' ' * (result.position - 1)}^-- ${result.message}
    """);
        return 1;
      } else {
        print(result);
        print(result.value);
      }
    });
  });
}
