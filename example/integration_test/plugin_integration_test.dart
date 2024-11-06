// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing


import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:smswatcher/smswatcher.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('get All Sms', (WidgetTester tester) async {
    final Smswatcher plugin = Smswatcher();
    final List<Map<String, String>>? smsData = await plugin.getAllSMS();
    // The version string depends on the host platform running the test, so
    // just assert that some non-empty string is returned.
    expect(smsData?.isNotEmpty, true);
  });
}
