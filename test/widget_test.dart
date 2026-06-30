import 'package:flutter_test/flutter_test.dart';
import 'package:qr_code_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const QRCodeApp());

    // Verify that the title is present
    expect(find.text('QR Code App'), findsOneWidget);
  });
}
