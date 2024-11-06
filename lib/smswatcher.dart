import 'smswatcher_platform_interface.dart';

class Smswatcher {
  Future<List<Map<String,String>>?> getAllSMS() {
    return SmswatcherPlatform.instance.fetchMessages();
  }

  Stream<Map<String,String>> getStreamOfSMS(){
    return SmswatcherPlatform.instance.listenToNewSMS();
  }

  Future<void> dispose()async{
    await SmswatcherPlatform.instance.dispose();
  }
}
