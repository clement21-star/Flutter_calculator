import 'package:flutter_test/flutter_test.dart';
import 'package:mycalculator/calculator_engine.dart';

void main() {
  test('design sample evaluates left to right to 12,454', () {
    expect(evaluateExpression('6000/2+3227*2'), 12454);
    final calculator = Calculator();
    expect(calculator.expression, '6000/2+3227*2');
    expect(calculator.result, '=12,454');
  });

  test('digits, operators, and equals update the display', () {
    final calculator = Calculator()..press('Ac');
    expect(calculator.result, '=0');

    for (final key in ['6', '0', '0', '0', '/', '2', '=']) {
      calculator.press(key);
    }
    expect(calculator.expression, '6000/2');
    expect(calculator.result, '=3,000');
  });

  test('sine of 30 degrees is one half', () {
    final calculator = Calculator()
      ..press('Ac')
      ..press('3')
      ..press('0')
      ..press('sin');
    expect(calculator.result, '=0.5');
  });

  test('divide by zero shows an error', () {
    final calculator = Calculator()
      ..press('Ac')
      ..press('8')
      ..press('/')
      ..press('0');
    expect(calculator.result, 'Error');
  });
}
