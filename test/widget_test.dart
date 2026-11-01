import 'package:flutter_test/flutter_test.dart';
import 'package:shield_ai/app.dart';

void main() {
  testWidgets('ShieldAI app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ShieldAiApp());
    await tester.pump();
    expect(find.text('ShieldAI'), findsWidgets);
  });
}
