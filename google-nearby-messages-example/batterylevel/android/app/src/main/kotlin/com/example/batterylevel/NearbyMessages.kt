package com.example.batterylevel

import android.content.ContentValues
import android.os.Bundle
import android.util.Log
import com.google.android.gms.nearby.Nearby
import com.google.android.gms.nearby.messages.Message
import com.google.android.gms.nearby.messages.MessageListener
import io.flutter.embedding.android.FlutterActivity

class NearbyMessages : FlutterActivity() {
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
}