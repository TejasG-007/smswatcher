package online.tejasgprod.smswatcher
import android.content.IntentFilter
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import android.content.Context
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import android.Manifest
import androidx.core.app.ActivityCompat


/** SmswatcherPlugin */
class SmswatcherPlugin: FlutterPlugin, MethodCallHandler ,EventChannel.StreamHandler{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private val SMS_URI = Uri.parse("content://sms/inbox")
  private var eventSink:EventChannel.EventSink? = null
  private  val smsReceiver = SmsReceiver()

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sms_listener")
    channel.setMethodCallHandler(this)
    SmsReceiver.smsReceiveChannel = channel
    val eventChannel = EventChannel(flutterPluginBinding.binaryMessenger,"sms_event_listener")
    eventChannel.setStreamHandler(this)
    SmsReceiver.eventSink = {
        data -> eventSink?.success(data)
    }

  }

  override fun onMethodCall(call: MethodCall, result:MethodChannel.Result) {
    when(call.method){
      "getAllSms" -> {
        val smsList = getAllSms()
        result.success(smsList)
      }
      else -> result.notImplemented()
    }
  }

  private fun getAllSms():List<Map<String,String>>{
    val smsList = mutableListOf<Map<String,String>>()
    if(ActivityCompat.checkSelfPermission(context,Manifest.permission.READ_SMS)!=PackageManager.PERMISSION_GRANTED){
      return smsList
    }
    val cursor:Cursor? = context.contentResolver.query(SMS_URI,null,null,null,null)
    cursor?.use {
      val addressIndex = cursor.getColumnIndex("address")
      val bodyIndex = cursor.getColumnIndex("body")
      while(cursor.moveToNext()){
        val address = cursor.getString(addressIndex)
        val body = cursor.getString(bodyIndex)
        smsList.add(mapOf("sender" to address , "body" to body))
      }
    }
    return smsList
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    SmsReceiver.smsReceiveChannel = null
    eventSink = null
  }

  override fun onListen(arguments: Any?, events: EventSink?) {
    eventSink = events
    context.registerReceiver(smsReceiver, IntentFilter("android.provider.Telephony.SMS_RECEIVED"))
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
    context.unregisterReceiver(smsReceiver)
  }
}



