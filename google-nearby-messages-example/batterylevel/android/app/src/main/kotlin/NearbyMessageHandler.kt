import android.app.Activity
import android.content.ContentValues
import android.util.Log
import com.google.android.gms.nearby.Nearby
import com.google.android.gms.nearby.messages.Message
import com.google.android.gms.nearby.messages.MessageListener

object NearbyMessageHandler {

    var message: Message? = Message("...".toByteArray());

    var messageListener: MessageListener;


    init {
        messageListener = object : MessageListener() {
            override fun onFound(m: Message) {
                Log.d(ContentValues.TAG, "Found message: " + String(m.content))
                message = m
            }

            override fun onLost(message: Message) {
                Log.d(ContentValues.TAG, "Lost sight of message: " + String(message.content))
            }
        }
    }

    public fun publish(activity: Activity, message: Message) : Boolean {
        Nearby.getMessagesClient(activity).publish(message);
        return true;
    }

    public fun unPublish(activity: Activity, message: Message) : Boolean {
        Nearby.getMessagesClient(activity).unpublish(message);
        return true;
    }

    public fun subscribe(activity: Activity) : String {
        Nearby.getMessagesClient(activity).subscribe(messageListener);
        return String(message!!.content);
    }

    public fun unSubscribe(activity: Activity) : String {
        Nearby.getMessagesClient(activity).unsubscribe(messageListener);
        return String(message!!.content);
    }

}