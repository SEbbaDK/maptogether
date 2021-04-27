package com.example.batterylevel

// android imports
import NearbyMessageHandler
import android.content.*
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import com.google.android.gms.nearby.Nearby
import com.google.android.gms.nearby.messages.Message
import com.google.android.gms.nearby.messages.MessageListener
import com.google.android.gms.tasks.Task
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {

    private val CHANNEL = "samples.flutter.dev/battery"

    private val nearbyMessageHandler = NearbyMessageHandler()
    private var pupTask : Task<Void>? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        Log.d(ContentValues.TAG, "Start")
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else if (call.method == "returnHej") {
                val returnVal = returnHej();
                
                if (returnVal != null) {
                    result.success(returnVal)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            }

            else if (call.method == "publish") {
                pupTask = nearbyMessageHandler.publish(this, Message("Det virker!".toByteArray()))
                result.success(null)
            }

            else if (call.method == "unPublish") {
                nearbyMessageHandler.unPublish(this, Message("Det virker!".toByteArray()))
                result.success(null)
            }


            else if (call.method == "subscribe") {
                val a = nearbyMessageHandler.subscribe(this)
                result.success(a)
            }

            else if (call.method == "unsubscribe") {
                val a = nearbyMessageHandler.unSubscribe(this)
                result.success(a)
            }

            else if (call.method == "getMessage") {
                result.success(nearbyMessageHandler.getLatestMessage())
            }

            else if (call.method == "getExceptionMessage") {
                val res : String
                if (pupTask == null) {
                    res = "pupTask is null"
                } else if (pupTask!!.exception == null) {
                    res = "no exception"
                } else {
                    var trace : String = ""
                    for (e in pupTask!!.exception!!.stackTrace) {
                        trace += e.className + "." + e.methodName + e.lineNumber + "\n"
                    }
                    res = trace
                }
                result.success(res)
            }

            else {
                result.notImplemented()
            }
        }
    }

    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }

        return batteryLevel
    }


    fun returnHej(): String {
        val myString = "hej";
        return myString;
    }


    /// Nearby messages...

    /*

    private var mMessage: Message? = null
    var mMessageListener: MessageListener? = null

    public override fun onCreate(savedInstanceState: Bundle?) {

        
        super.onCreate(savedInstanceState)

        val mMessageListener: MessageListener = object : MessageListener() {
            override fun onFound(message: Message) {
                Log.d(ContentValues.TAG, "Found message: " + String(message.content))
            }

            override fun onLost(message: Message) {
                Log.d(ContentValues.TAG, "Lost sight of message: " + String(message.content))
            }
        }
        mMessage = Message("Hello World".toByteArray())
    }


    public override fun onStart() {
        super.onStart()

        // ...
        Nearby.getMessagesClient(this).publish(mMessage!!)
        Nearby.getMessagesClient(this).subscribe(mMessageListener!!)
    }

    public override fun onStop() {
        Nearby.getMessagesClient(this).unpublish(mMessage!!)
        Nearby.getMessagesClient(this).unsubscribe(mMessageListener!!)

        // ...
        super.onStop()
    }
*/
}
