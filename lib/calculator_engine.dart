import 'dart:math' as math;

/// Left-to-right calculator that matches the sample on the design:
/// `6000/2+3227*2` evaluates to 12,454.
class Calculator {
  String expression = '6000/2+3227*2';
  String result = '=12,454';
  bool justEvaluated = true;
  bool degrees = true;

  void press(String key) {
    switch (key) {
      case 'Ac':
        _clear();
      case 'del':
        _backspace();
      case '=':
        _equals();
      case '.':
        _dot();
      case '+':
      case '-':
      case '*':
      case '/':
        _operator(key);
      case 'e':
        _constantE();
      case 'µ':
        _micro();
      case 'sin':
        _sine();
      case 'deg':
        degrees = !degrees;
      default:
        _digit(key);
    }
  }

  void _clear() {
    expression = '0';
    justEvaluated = false;
    _refresh();
  }

  void _backspace() {
    if (justEvaluated) {
      _clear();
      return;
    }
    expression = expression.length <= 1
        ? '0'
        : expression.substring(0, expression.length - 1);
    if (expression.isEmpty) expression = '0';
    _refresh();
  }

  void _equals() {
    justEvaluated = true;
    _refresh();
  }

  void _digit(String digit) {
    if (justEvaluated) {
      expression = digit;
      justEvaluated = false;
      _refresh();
      return;
    }
    if (RegExp(r'(?:^|[+\-*/])0$').hasMatch(expression)) {
      if (digit == '0') return;
      expression = expression.substring(0, expression.length - 1) + digit;
    } else {
      expression += digit;
    }
    _refresh();
  }

  void _dot() {
    if (justEvaluated) {
      expression = '0.';
      justEvaluated = false;
      _refresh();
      return;
    }
    final current = RegExp(r'(\d+\.?\d*|\.\d*)$').firstMatch(expression);
    if (current != null) {
      if (current.group(0)!.contains('.')) return;
      expression = '$expression.';
    } else {
      expression = '${expression}0.';
    }
    _refresh();
  }

  void _operator(String operator) {
    if (justEvaluated) {
      final value = evaluateExpression(expression);
      expression = '${value == null ? '0' : plainNumber(value)}$operator';
      justEvaluated = false;
      _refresh();
      return;
    }
    if (expression.endsWith('.')) {
      expression = expression.substring(0, expression.length - 1);
    }
    if (RegExp(r'[+\-*/]$').hasMatch(expression)) {
      expression = expression.substring(0, expression.length - 1) + operator;
    } else {
      expression += operator;
    }
    _refresh();
  }

  void _constantE() {
    if (justEvaluated || expression == '0') {
      expression = 'e';
    } else if (RegExp(r'[+\-*/]$').hasMatch(expression)) {
      expression = '${expression}e';
    } else {
      expression = '$expression*e';
    }
    justEvaluated = false;
    _refresh();
  }

  void _micro() {
    if (justEvaluated) {
      final value = evaluateExpression(expression);
      if (value == null) return;
      expression = plainNumber(value * 1e-6);
      justEvaluated = false;
      _refresh();
      return;
    }
    if (expression.endsWith('µ') || expression.endsWith('e')) return;
    if (RegExp(r'\d$').hasMatch(expression)) {
      expression = '$expressionµ';
      _refresh();
    }
  }

  void _sine() {
    final String prefix;
    final double? current;
    if (justEvaluated) {
      prefix = '';
      current = evaluateExpression(expression);
    } else {
      final match = RegExp(
        r'^(.*?)((?:\d+\.?\d*|\.\d+)µ?|e)$',
      ).firstMatch(expression);
      if (match == null) return;
      prefix = match.group(1)!;
      current = _operandValue(match.group(2)!);
    }
    if (current == null) return;
    final radians = degrees ? current * math.pi / 180 : current;
    expression = '$prefix${plainNumber(math.sin(radians))}';
    justEvaluated = false;
    _refresh();
  }

  void _refresh() {
    final value = evaluateExpression(expression);
    result = value == null ? 'Error' : '=${formatGrouped(value)}';
  }
}

double? evaluateExpression(String input) {
  final tokens = _tokenize(input);
  if (tokens.isEmpty) return 0;
  if (tokens.first is! double) return null;
  var acc = tokens.first as double;
  var i = 1;
  while (i < tokens.length) {
    final op = tokens[i];
    if (op is! String) return null;
    i++;
    if (i >= tokens.length) break;
    final next = tokens[i];
    if (next is! double) return null;
    i++;
    switch (op) {
      case '+':
        acc += next;
      case '-':
        acc -= next;
      case '*':
        acc *= next;
      case '/':
        if (next == 0) return null;
        acc /= next;
      default:
        return null;
    }
  }
  return acc;
}

String plainNumber(double value) {
  if (value.isNaN || value.isInfinite) return '0';
  if ((value - value.roundToDouble()).abs() < 1e-9 && value.abs() < 1e15) {
    return value.round().toString();
  }
  var text = value.toStringAsFixed(10);
  if (text.contains('.')) {
    text = text
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }
  return text;
}

String formatGrouped(double value) {
  if (value.isNaN || value.isInfinite) return 'Error';
  final negative = value < 0;
  final absolute = value.abs();
  final String digits;
  if ((absolute - absolute.roundToDouble()).abs() < 1e-8 && absolute < 1e15) {
    digits = absolute.round().toString();
  } else {
    digits = plainNumber(absolute);
  }
  final parts = digits.split('.');
  final grouped = _groupThousands(parts.first);
  final body = parts.length > 1 ? '$grouped.${parts[1]}' : grouped;
  return negative ? '-$body' : body;
}

String _groupThousands(String digits) {
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    if (i > 0 && remaining % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

double? _operandValue(String token) {
  if (token == 'e') return math.e;
  final micro = token.endsWith('µ');
  final raw = micro ? token.substring(0, token.length - 1) : token;
  final value = double.tryParse(raw);
  if (value == null) return null;
  return micro ? value * 1e-6 : value;
}

List<Object> _tokenize(String input) {
  final tokens = <Object>[];
  var i = 0;
  while (i < input.length) {
    final char = input[i];
    if (char == 'e') {
      _pushValue(tokens, math.e);
      i++;
      continue;
    }
    if (char == 'µ') {
      if (tokens.isNotEmpty && tokens.last is double) {
        tokens[tokens.length - 1] = (tokens.last as double) * 1e-6;
      }
      i++;
      continue;
    }
    if ('+-*/'.contains(char)) {
      final unary = char == '-' && (tokens.isEmpty || tokens.last is String);
      if (unary) {
        i++;
        if (i < input.length && input[i] == 'e') {
          _pushValue(tokens, -math.e);
          i++;
          continue;
        }
        final start = i;
        i = _consumeNumber(input, i);
        if (i == start) {
          tokens.add(char);
          continue;
        }
        var number = double.parse(input.substring(start, i));
        if (i < input.length && input[i] == 'µ') {
          number *= 1e-6;
          i++;
        }
        _pushValue(tokens, -number);
        continue;
      }
      tokens.add(char);
      i++;
      continue;
    }
    if (_isNumberChar(char)) {
      final start = i;
      i = _consumeNumber(input, i);
      var number = double.parse(input.substring(start, i));
      if (i < input.length && input[i] == 'µ') {
        number *= 1e-6;
        i++;
      }
      _pushValue(tokens, number);
      continue;
    }
    i++;
  }
  return tokens;
}

void _pushValue(List<Object> tokens, double value) {
  if (tokens.isNotEmpty && tokens.last is double) tokens.add('*');
  tokens.add(value);
}

int _consumeNumber(String input, int index) {
  var seenDot = false;
  var i = index;
  while (i < input.length) {
    final char = input[i];
    if (char == '.') {
      if (seenDot) break;
      seenDot = true;
      i++;
      continue;
    }
    if (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57) {
      i++;
      continue;
    }
    break;
  }
  return i;
}

bool _isNumberChar(String char) {
  return char == '.' || (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57);
}
