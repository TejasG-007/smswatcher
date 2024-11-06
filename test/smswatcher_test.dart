import 'package:flutter_test/flutter_test.dart';
import 'package:smswatcher/smswatcher.dart';
import 'package:smswatcher/smswatcher_platform_interface.dart';
import 'package:smswatcher/smswatcher_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSmswatcherPlatform
    with MockPlatformInterfaceMixin
    implements SmswatcherPlatform {
  @override
  Future<void> dispose() async {
    print("disposing the controller");
  }

  @override
  Future<void> initializedSMSStream() async {
    print("Initializing the Stream for sms");
  }

  @override
  Stream<Map<String, String>> listenToNewSMS() {
    return Stream.value({"sender": "TejasGProduction", "body": "SMS Testing"});
  }

  @override
  Future<List<Map<String, String>>?> fetchMessages() {
    return Future.value([
      {"sender": "TejasGProduction", "body": "SMS Testing"}
    ]);
  }
}

void main() {
  final SmswatcherPlatform initialPlatform = SmswatcherPlatform.instance;

  test('$MethodChannelSmswatcher is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSmswatcher>());
  });

  test('getPlatformVersion', () async {
    Smswatcher smswatcherPlugin = Smswatcher();
    MockSmswatcherPlatform fakePlatform = MockSmswatcherPlatform();
    SmswatcherPlatform.instance = fakePlatform;

    expect(await smswatcherPlugin.getAllSMS(), [
      {"sender": "TejasGProduction", "body": "SMS Testing"}
    ]);
    smswatcherPlugin.getStreamOfSMS().listen((data) {
      expect(data, {"sender": "TejasGProduction", "body": "SMS Testing"});
    });
  });
}
