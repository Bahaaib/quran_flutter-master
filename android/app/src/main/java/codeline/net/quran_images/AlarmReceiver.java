package codeline.net.quran_images;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;


import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import static android.content.Context.ALARM_SERVICE;

public class AlarmReceiver extends BroadcastReceiver {

    public Calendar getTimeByCal(int time) throws ParseException {

        DateFormat df = new SimpleDateFormat("MMMM d, yyyy");
        String now_time = df.format(new Date());

        Calendar cal = Calendar.getInstance();
        cal.setTime(df.parse(now_time));
        cal.add(Calendar.DATE, time);

        return cal;
    }

    @Override
    public void onReceive(Context context, Intent intent) {

        Bundle bundle = intent.getExtras();

        System.out.println("onReceive");
        if(bundle != null){
            int index = bundle.getInt("number");
            System.out.println("index"+index);
            if(AlarmClass.get(context,String.valueOf(index))){

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    NotificationOreo.createNotificationChannel(context,ItemSalat.getNameOfSalat(context,index));
                }else {
                    AddNotification.notify(context, "القرآن الكريم", ItemSalat.getNameOfSalat(context, index), 1);
                }

            }
            try {
                cancelAlarm(context,index);
                setAlarm(context,PrayerTime.getSalatTimes(context, ItemLocation.getLal(context), ItemLocation.getLong(context), getTimeByCal(1),-1),index);
            }catch (Exception ex){}
        }
    }

    private void cancelAlarm(Context ctx,int pos){
        Intent intent = new Intent(ctx, AlarmReceiver.class);
        PendingIntent pi=PendingIntent.getBroadcast(ctx, pos,intent, PendingIntent.FLAG_CANCEL_CURRENT);
        AlarmManager alarmManager = (AlarmManager) ctx.getSystemService(ALARM_SERVICE);
        alarmManager.cancel(pi);
    }
    private void setAlarm(Context ctx,List<String> timesSalat,int index){




            AlarmManager manager = (AlarmManager)ctx. getSystemService(Context.ALARM_SERVICE);
            int hourOfDay = 0,minute = 0;
            Calendar cal_alarm = null;
            try {
                cal_alarm = getTimeByCal(1);

            }catch (Exception ex){}

            String t = timesSalat.get(index);

            if(t.length() == 7 || t.length() ==4)
                t = "0"+t;

            hourOfDay =  Integer.parseInt(t.substring(0,2));
            minute = Integer.parseInt(t.substring(3,5));


            cal_alarm.set(Calendar.HOUR_OF_DAY, hourOfDay);
            cal_alarm.set(Calendar.MINUTE, minute);
            cal_alarm.set(Calendar.SECOND, 0);
            /*if (cal_alarm.before(cal_now)) {
                cal_alarm.add(Calendar.DATE, 1);
            }*/

            Intent myIntent = new Intent(ctx, AlarmReceiver.class);
            myIntent.putExtra("number", index);
            PendingIntent pendingIntent = PendingIntent.getBroadcast(ctx, index, myIntent, PendingIntent.FLAG_CANCEL_CURRENT);
            //manager.set(AlarmManager.RTC_WAKEUP, cal_alarm.getTimeInMillis(), pendingIntent);

            if (Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP_MR1) {
                //lollipop_mr1 is 22, this is only 23 and above
                manager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, cal_alarm.getTimeInMillis(), pendingIntent);
            } else if (Build.VERSION.SDK_INT > Build.VERSION_CODES.JELLY_BEAN_MR2) {
                //JB_MR2 is 18, this is only 19 and above.
                manager.setExact(AlarmManager.RTC_WAKEUP, cal_alarm.getTimeInMillis(), pendingIntent);
            } else {
                //available since api1
                manager.set(AlarmManager.RTC_WAKEUP, cal_alarm.getTimeInMillis(), pendingIntent);
            }

    }



}
