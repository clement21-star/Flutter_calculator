import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'calculator_engine.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF17181A),
        fontFamily: 'Poppins',
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final Calculator _calculator = Calculator();

  void _press(String key) => setState(() => _calculator.press(key));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17181A),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scale =
              constraints.maxWidth / _frameWidth <
                  constraints.maxHeight / _frameHeight
              ? constraints.maxWidth / _frameWidth
              : constraints.maxHeight / _frameHeight;
          return Center(
            child: SizedBox(
              width: _frameWidth * scale,
              height: _frameHeight * scale,
              child: FittedBox(
                child: SizedBox(
                  width: _frameWidth,
                  height: _frameHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(39),
                    child: ColoredBox(
                      color: const Color(0xFF17181A),
                      child: Stack(
                        children: [
                          const Positioned(
                            left: 116,
                            top: -281,
                            width: 420,
                            height: 420,
                            child: _Glow(
                              asset: 'assets/figma/ellipse_2.svg',
                              width: 420,
                              height: 420,
                            ),
                          ),
                          const Positioned(
                            left: 16,
                            top: 717,
                            width: 379,
                            height: 365,
                            child: _Glow(
                              asset: 'assets/figma/ellipse_3.svg',
                              width: 379,
                              height: 365,
                            ),
                          ),
                          Positioned(
                            left: 34,
                            top: 138,
                            width: 308,
                            height: 36,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: _ExpressionText(
                                expression: _calculator.expression,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 34,
                            top: 180,
                            width: 308,
                            height: 72,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                _calculator.result,
                                key: const Key('result'),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 48,
                                  height: 1.5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          _assetKey(
                            34,
                            330,
                            62,
                            40,
                            'e',
                            'assets/figma/btn_e.svg',
                          ),
                          _assetKey(
                            116,
                            330,
                            62,
                            40,
                            'µ',
                            'assets/figma/btn_mu.svg',
                          ),
                          _assetKey(
                            198,
                            330,
                            62,
                            40,
                            'sin',
                            'assets/figma/btn_sin.svg',
                          ),
                          _assetKey(
                            280,
                            330,
                            62,
                            40,
                            'deg',
                            'assets/figma/btn_deg.svg',
                          ),
                          _textKey(
                            34,
                            386,
                            62,
                            62,
                            'Ac',
                            background: const Color(0xFF616161),
                            foreground: const Color(0xFFA5A5A5),
                            radius: 16,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                          Positioned(
                            left: 116,
                            top: 386,
                            width: 62,
                            height: 62,
                            child: _Tap(
                              label: 'Delete',
                              onTap: () => _press('del'),
                              child: DecoratedBox(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF616161),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 17,
                                      top: 19,
                                      width: 24,
                                      height: 24,
                                      child: SvgPicture.asset(
                                        'assets/figma/icon_delete.svg',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          _assetKey(
                            198,
                            386,
                            62,
                            62,
                            '/',
                            'assets/figma/btn_divide.svg',
                          ),
                          _assetKey(
                            280,
                            386,
                            62,
                            62,
                            '*',
                            'assets/figma/btn_multiply.svg',
                          ),
                          _textKey(34, 470, 62, 60, '7'),
                          _textKey(116, 470, 62, 60, '8'),
                          _textKey(198, 470, 62, 60, '9'),
                          _textKey(
                            280,
                            470,
                            62,
                            60,
                            '-',
                            background: const Color(0xFF005DB2),
                            foreground: const Color(0xFF24A5FF),
                          ),
                          _textKey(34, 546, 62, 60, '4'),
                          _textKey(116, 546, 62, 60, '5'),
                          _textKey(198, 546, 62, 60, '6'),
                          _textKey(
                            280,
                            552,
                            62,
                            96,
                            '+',
                            background: const Color(0xFF005DB2),
                            foreground: const Color(0xFF339DFF),
                            radius: 12,
                          ),
                          _textKey(34, 622, 62, 60, '1'),
                          _textKey(116, 622, 62, 60, '2'),
                          _textKey(198, 622, 62, 60, '3'),
                          _textKey(34, 712, 144, 60, '0'),
                          Positioned(
                            left: 198,
                            top: 710,
                            width: 62,
                            height: 62,
                            child: _Tap(
                              label: 'Decimal',
                              onTap: () => _press('.'),
                              child: const DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Color(0xFF303136),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 29,
                                      top: 29,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Color(0xFF109DFF),
                                          shape: BoxShape.circle,
                                        ),
                                        child: SizedBox(
                                          width: 4.5,
                                          height: 4.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          _textKey(
                            280,
                            674,
                            62,
                            96,
                            '=',
                            background: const Color(0xFF1991FF),
                            foreground: const Color(0xFFB2DAFF),
                            radius: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _assetKey(
    double left,
    double top,
    double width,
    double height,
    String keyName,
    String asset,
  ) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: _Tap(
        label: keyName,
        onTap: () => _press(keyName),
        child: SvgPicture.asset(asset, width: width, height: height),
      ),
    );
  }

  Widget _textKey(
    double left,
    double top,
    double width,
    double height,
    String label, {
    Color background = const Color(0xFF303136),
    Color foreground = const Color(0xFF29A8FF),
    double radius = 16,
    double fontSize = 32,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: _Tap(
        label: label,
        onTap: () => _press(label),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: fontWeight,
                fontSize: fontSize,
                height: 1,
                color: foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpressionText extends StatelessWidget {
  const _ExpressionText({required this.expression});

  final String expression;

  @override
  Widget build(BuildContext context) {
    const base = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      fontSize: 24,
      height: 1.5,
      color: Color(0xFF818181),
    );
    final spans = <InlineSpan>[];
    final pattern = RegExp(r'[+\-*/]');
    var start = 0;
    for (final match in pattern.allMatches(expression)) {
      if (match.start > start) {
        spans.add(TextSpan(text: expression.substring(start, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: const TextStyle(color: Color(0xFF109DFF)),
        ),
      );
      start = match.end;
    }
    if (start < expression.length) {
      spans.add(TextSpan(text: expression.substring(start)));
    }
    return Text.rich(
      TextSpan(style: base, children: spans),
      key: const Key('expression'),
      maxLines: 1,
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.asset, required this.width, required this.height});

  final String asset;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 50.5,
        sigmaY: 50.5,
        tileMode: TileMode.decal,
      ),
      child: SvgPicture.asset(asset, width: width, height: height),
    );
  }
}

class _Tap extends StatelessWidget {
  const _Tap({required this.label, required this.onTap, required this.child});

  final String label;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: child,
      ),
    );
  }
}

const double _frameWidth = 375;
const double _frameHeight = 812;
