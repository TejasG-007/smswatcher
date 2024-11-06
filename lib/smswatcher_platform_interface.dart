import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'smswatcher_method_channel.dart';

abstract class SmswatcherPlatform extends PlatformInterface {
  /// Constructs a SmsListnerPlatform.
  SmswatcherPlatform() : super(token: _token);

  static final Object _token = Object();

  static SmswatcherPlatform _instance = MethodChannelSmswatcher();

  /// The default instance of [SmsListenerPlatform] to use.
  ///
  /// Defaults to [MethodChannelSMSListener].
  static SmswatcherPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SmsListenerPlatform] when
  /// they register themselves.
  static set instance(SmswatcherPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<Map<String, String>>?> fetchMessages() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> initializedSMSStream() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Stream<Map<String, String>> listenToNewSMS() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> dispose() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
