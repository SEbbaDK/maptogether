import android.app.Activity
import android.content.ContentValues
import android.util.Log
import com.example.batterylevel.MainActivity
import com.google.android.gms.nearby.Nearby
import com.google.android.gms.nearby.messages.Message
import com.google.android.gms.nearby.messages.MessageListener

class NearbyMessageHandler() {

    var message: Message? = null

    var messageListener: MessageListener? = null

    init {
        val messageListener: MessageListener = object : MessageListener() {
            override fun onFound(message: Message) {
                Log.d(ContentValues.TAG, "Found message: " + String(message.content))
            }

            override fun onLost(message: Message) {
                Log.d(ContentValues.TAG, "Lost sight of message: " + String(message.content))
            }
        }

        message = Message("Hello World".toByteArray());
    }


    public fun publish(activity: Activity, message: Message) {
        Nearby.getMessagesClient(activity).publish(message);
    }

    public fun subscribe(activity: Activity, messageListener: MessageListener) {
        Nearby.getMessagesClient(activity).subscribe(messageListener);
    }

}