import 'package:flutter_test/flutter_test.dart';
import 'package:hwt_lister_mobile/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HwtListerApp());
    expect(find.text('HWT LISTER'), findsOneWidget);
  });
}
