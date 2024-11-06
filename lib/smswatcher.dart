import 'smswatcher_platform_interface.dart';

class Smswatcher {
  //This method will return the list sms at once.
  Future<List<Map<String, String>>?> getAllSMS() {
    return SmswatcherPlatform.instance.fetchMessages();
  }

  //This method allows to listen to latest sms.
  Stream<Map<String, String>> getStreamOfSMS() {
    return SmswatcherPlatform.instance.listenToNewSMS();
  }

  //dispose will close the stream.
  Future<void> dispose() async {
    await SmswatcherPlatform.instance.dispose();
  }
}
