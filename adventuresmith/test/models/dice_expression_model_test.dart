import 'dart:math';

import 'package:adventuresmith/models/dice_expression_model.dart';
import 'package:dart_dice_parser/dart_dice_parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRandom extends Mock implements Random {}

void main() {
  group('DiceExpressionModel', () {
    DiceExpressionModel expressionModel;

    setUp(() async {
      var mockRandom = MockRandom();
      var diceParser = DiceParser(diceRoller: DiceRoller(mockRandom));

      when(mockRandom.nextInt(argThat(inInclusiveRange(1, 1000))))
          .thenReturn(1);

      expressionModel = DiceExpressionModel(diceParser);
    });

    test('set expr - valid', () async {
      await expressionModel.setExpression("2d6");
      expect(expressionModel.validationError, isNull);
      expect(expressionModel.stats.isEmpty, isFalse);
    });

    test('set expr - invalid', () async {
      await expressionModel.setExpression("2d6 asdf");
      expect(
          expressionModel.validationError, "invalid char in dice expression");
      expect(expressionModel.stats.isEmpty, isTrue);
    });
  });
}
