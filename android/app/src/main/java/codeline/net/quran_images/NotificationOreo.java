package codeline.net.quran_images;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Build;

import java.util.Random;


public class NotificationOreo {

    private static final String CHANNEL_ID = "my_channel_01";
    private static int notifyID =11;

    public static void createNotificationChannel(Context ctx,String tittle) {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Sets an ID for the notification, so it can be updated.
            int notifyID = 1;
            CharSequence name = "name";// The user-visible name of the channel.
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel mChannel = new NotificationChannel(CHANNEL_ID, name, importance);
// Create a notification and set the notification channel.
            Notification notification = new Notification.Builder(ctx)
                    .setContentTitle(tittle)
                    //.setContentText("You've received new messages.")
                    .setSmallIcon(R.drawable.icon)
                    .setChannelId(CHANNEL_ID)
                    .setAutoCancel(true)
                   // .setOngoing(true)

                    .build();



            NotificationManager mNotificationManager =
                    (NotificationManager)ctx. getSystemService(Context.NOTIFICATION_SERVICE);
            mNotificationManager.createNotificationChannel(mChannel);

           // Issue the notification.
            notifyID = new Random().nextInt(9999-1)-1;
            mNotificationManager.notify(notifyID , notification);

        }
    }

    public static void cancel(Context context){
        NotificationManager notificationManager =
                (NotificationManager)context.getSystemService(Context.NOTIFICATION_SERVICE);
            // The id of the channel.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
           // notificationManager.cancel(notifyID);
            notificationManager.deleteNotificationChannel(CHANNEL_ID);
        }
    }
}
