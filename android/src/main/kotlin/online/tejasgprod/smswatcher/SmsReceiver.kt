package online.tejasgprod.smswatcher
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.SmsMessage
import io.flutter.plugin.common.MethodChannel

class SmsReceiver: BroadcastReceiver() {
    companion object {
        var smsReceiveChannel : MethodChannel? = null
        var eventSink:((Map<String,String?>)->Unit)?=null
    }

    override fun onReceive(context: Context, intent: Intent){
        val bundle = intent.extras
        if(bundle !=null || intent.action == "android.provider.Telephony.SMS_RECEIVED"){
            val pdus = bundle?.get("pdus") as Array<*>
            for(pdu in pdus){
                val sms = SmsMessage.createFromPdu(pdu as ByteArray)
                val data = mapOf("sender" to sms.originatingAddress,"body" to sms.messageBody)
                smsReceiveChannel?.invokeMethod("onSmsReceived",data)
                eventSink?.invoke(data)
            }
        }
    }
}