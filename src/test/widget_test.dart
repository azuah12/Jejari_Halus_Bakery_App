import 'dart:ui' show Size;

import 'package:flutter_test/flutter_test.dart';
import 'package:src/main.dart';

void main() {
  testWidgets(
    'CrumbTech displays the order type selection screen',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const CrumbTechApp());

      expect(find.text('How shall we make your day?'), findsOneWidget);
      expect(find.text('Immediate Order'), findsOneWidget);
      expect(find.text('Advance Preorder'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    },
  );
}