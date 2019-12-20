package codeline.net.quran_images;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.Calendar;
import java.util.List;

import static android.content.Context.ALARM_SERVICE;

public class AdabterSalat extends ArrayAdapter<String> {

    private Context mContext;
    private List<String> salatTime;

    public AdabterSalat(Context context, int resource, List<String> list) {
        super(context, resource);
        this.mContext  = context;
        this.salatTime = list;


    }


    @Override
    public long getItemId(int position) {
        return position;
    }

    @Nullable
    @Override
    public String getItem(int position) {
        return ((null != salatTime) ? salatTime.get(position) : null);
    }

    @Override
    public int getCount() {
        return ((null != salatTime)?salatTime.size() : 0);
    }

    @NonNull
    @Override
    public View getView(final int position, View convertView, final ViewGroup parent) {

        View view = convertView;
        if (null == view){
            LayoutInflater layoutInflater = (LayoutInflater)mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);


                view = layoutInflater.inflate(R.layout.item_salat,null);


        }


            TextView tvName = (TextView)view.findViewById(R.id.salatName);
            TextView tvTime = (TextView)view.findViewById(R.id.salatTime);
            ImageView ivAlarm  = (ImageView)view.findViewById(R.id.iconeNotif);


            if(PrayerTimeActivity.day < 0){
                ivAlarm.setVisibility(View.INVISIBLE);
            }else {

                if (AlarmClass.get(mContext, String.valueOf(position))) {
                    //ivAlarm.setImageResource(R.drawable.ic_notifications_active24dp);
                }
            }

            ivAlarm.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    switchImage(v,position,salatTime.get(position));
                }
            });


            String time = salatTime.get(position);
            if(time.length() == 7 || time.length() ==4)
                time = "0"+time;

            tvName.setText(ItemSalat.getNameOfSalat(mContext,position));
            tvTime.setText(time);


        return view;
    }

    private void switchImage(View view,int pos,String time){

        ImageView imageView =(ImageView) view;
        int ressourseId ;
        boolean state;

        if(AlarmClass.get(mContext,String.valueOf(pos))){
            ressourseId = R.drawable.icon;
            state = false;
        }else {
            ressourseId = R.drawable.icon;
            state = true;
           // setAlarm(pos,time);

        }

        //imageView.setImageResource(ressourseId);
        AlarmClass.set(mContext,String.valueOf(pos),state);


    }
    private void setAlarm(int pos,long time){
            AlarmManager alarmManager = (AlarmManager) mContext.getSystemService(ALARM_SERVICE);
            Intent intent = new Intent(mContext, AlarmReceiver.class);
            PendingIntent pi=PendingIntent.getBroadcast(mContext, pos,intent, 0);
            alarmManager.set(AlarmManager.RTC_WAKEUP,time,pi);

    }


    private void cancelAlarm(int pos){
        Intent intent = new Intent(mContext, AlarmReceiver.class);
        PendingIntent pi=PendingIntent.getBroadcast(mContext, pos,intent, 0);
        AlarmManager alarmManager = (AlarmManager) mContext.getSystemService(ALARM_SERVICE);
        alarmManager.cancel(pi);
    }
}
