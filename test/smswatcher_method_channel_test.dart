import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smswatcher/smswatcher_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelSmswatcher platform = MethodChannelSmswatcher();
  const MethodChannel channel = MethodChannel('sms_listener');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return Future.value([
          {"sender": "TejasGProduction", "body": "SMS Testing"}
        ]);
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getAllSMS', () async {
    expect(await platform.fetchMessages(), [
      {"sender": "TejasGProduction", "body": "SMS Testing"}
    ]);
  });
}
