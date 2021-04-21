package com.example.batterylevel;

import android.os.Bundle;
import android.util.Log;

import com.google.android.gms.nearby.Nearby;
import com.google.android.gms.nearby.messages.Message;
import com.google.android.gms.nearby.messages.MessageListener;

import io.flutter.embedding.android.FlutterActivity;

import static android.content.ContentValues.TAG;

public class NearbyMessages extends FlutterActivity {

    private Message mMessage;
    MessageListener mMessageListener;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        MessageListener mMessageListener = new MessageListener() {
            @Override
            public void onFound(Message message) {
                Log.d(TAG, "Found message: " + new String(message.getContent()));
            }

            @Override
            public void onLost(Message message) {
                Log.d(TAG, "Lost sight of message: " + new String(message.getContent()));
            }
        };

        mMessage = new Message("Hello World".getBytes());
    }

    @Override
    public void onStart() {
        super.onStart();

        // ...
        
        Nearby.getMessagesClient(this).publish(mMessage);
        Nearby.getMessagesClient(this).subscribe(mMessageListener);
    }

    @Override
    public void onStop() {
        Nearby.getMessagesClient(this).unpublish(mMessage);
        Nearby.getMessagesClient(this).unsubscribe(mMessageListener);

        // ...

        super.onStop();
    }

}

