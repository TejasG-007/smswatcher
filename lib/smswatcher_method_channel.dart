import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'smswatcher_platform_interface.dart';

/// An implementation of [SmswatcherPlatform] that uses method channels.
class MethodChannelSmswatcher extends SmswatcherPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sms_listener');

  @visibleForTesting
  final eventChannel = const EventChannel("sms_event_listener");

  List<Map<String,String>> _allSms = [];


  Future<List<Map<String,String>>> _getAllSMS() async {
    final List<dynamic> allSMS = await methodChannel.invokeMethod('getAllSms');
    return allSMS.map((data){
      if(data is Map<dynamic,dynamic>){
        return Map<String,String>.from(data);
      }else{
        throw Exception("Invalid SMS data format");
      }
    }).toList();
  }

  @override
  Future<List<Map<String,String>>> fetchMessages() async {
    _allSms = await _getAllSMS();
    return _allSms;
  }

  final StreamController<Map<String,String>> _smsController = StreamController.broadcast();

  Stream<Map<String,String>> get smsStream =>_smsController.stream;

  @override
  Stream<Map<String, String>> listenToNewSMS() {
    return eventChannel.receiveBroadcastStream().map((data){
      _allSms.insert(0,Map<String,String>.from(data));
      return Map<String,String>.from(data);
    });
  }



  @override
  Future<void> initializedSMSStream()async{
    eventChannel.receiveBroadcastStream().listen((data){
      if(data is Map){
        final Map<String,String> smsData = {
          "sender":data["sender"] as String? ?? "",
          "body":data["body"] as String? ?? "",
        };
        _smsController.add(smsData);
      }
    },onError: (error){
      print("Error in receiving SMS event :$error");
    });
  }

  @override
  Future<void> dispose()async{
    await _smsController.close();
  }
}
