import 'package:flutter_test/flutter_test.dart';
import 'package:biodata_maker/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BiodataMakerApp());
    await tester.pumpAndSettle();
  });
}
