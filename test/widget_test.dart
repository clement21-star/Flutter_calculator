import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mycalculator/main.dart';

void main() {
  testWidgets('calculator opens on the design sample and can clear', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('=12,454'), findsOneWidget);
    expect(find.text('6000/2+3227*2'), findsOneWidget);
    expect(find.text('Ac'), findsOneWidget);

    await tester.tap(find.widgetWithText(GestureDetector, 'Ac'));
    await tester.pump();

    expect(find.text('=0'), findsOneWidget);
  });
}
