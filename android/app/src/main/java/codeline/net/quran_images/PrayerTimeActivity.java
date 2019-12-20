package codeline.net.quran_images;

import android.Manifest;
import android.app.Activity;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

public class PrayerTimeActivity extends AppCompatActivity implements LocationListener {

    double timezone ;

    public static int day = 0;

    private static final long MIN_DISTANCE_CHANGE_FOR_UPDATES = 5; // 10 meters

    private static final long MIN_TIME_BW_UPDATES = 1000 * 30 * 1; // 1 minute

    public final static int REQUEST_QPPS_TURN_ON = 154;

    private TextView dateTodat;
    private AdabterSalat adabterSalat;
    private ListView lv;
    private Button btnRefresh;



    private TextView tittleToolbar;

    String[] mouth ;

    private String astus = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_salat_time);

        Utils.checkPermissions(this,this);
        init();
    }

    public Calendar getTimeByCal(int time) throws ParseException {

        DateFormat df = new SimpleDateFormat("MMMM d, yyyy");
        String now_time = df.format(new Date());

        Calendar cal = Calendar.getInstance();
        cal.setTime(df.parse(now_time));
        cal.add(Calendar.DATE, time);

        return cal;
    }

    public void showDateInArabic(){
        String date = "";
        try {
            Calendar calendar = getTimeByCal(day);
            int year  =  calendar.get(Calendar.YEAR);
            int mouthOfYear = calendar.get(Calendar.MONTH);
            int day = calendar.get(Calendar.DATE);

            date = day+" "+mouth[mouthOfYear]+" "+ year;

        }catch (Exception ex){}

        dateTodat.setText(date);
    }


    private void init() {

        dateTodat = (TextView)findViewById(R.id.dateToday);
        lv = (ListView)findViewById(R.id.lvSalat);
        btnRefresh = (Button)findViewById(R.id.btnRefresh);
        //tittleToolbar = (TextView)findViewById(R.id.tv_time_salat);


            mouth = new String[]{"جانفي", "فيفري", "مارس" ,"آفريل" ,"ماي" ,"جوان" ,"جويلية" ,"أوت" ,"سبتمبر" ,"أكتوبر" ,"نوفمبر" ,"ديسمبر" };
            astus = "فشل في تحديد المكان قم بفتح GPS";

        showDateInArabic();

        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {


            if ((ItemLocation.getLal(getApplicationContext())) == 0 ||
                    ( ItemLocation.getLong(getApplicationContext())) == 0) {

                String TAG = "1/"+ ItemLocation.getLal(getApplicationContext())+" * "+ItemLocation.getLong(getApplicationContext());
                Log.e("TAG 1",TAG);

                //location == null
                GpsUtils gpsUtils = new GpsUtils(this);
                gpsUtils.turnGPSOn(new GpsUtils.onGpsListener() {
                    @Override
                    public void gpsStatus(boolean isGPSEnable) {
                        if(isGPSEnable){
                            //get location
                            Location location = getLocation();

                            if (location != null) {
                                showSalatTime(location.getLatitude(), location.getLongitude(), day);
                                ItemLocation.setLal(getApplicationContext(), String.valueOf(location.getLatitude()));
                                ItemLocation.setLong(getApplicationContext(), String.valueOf(location.getLongitude()));
                                try {
                                    setAlarm(PrayerTime.getSalatTimes(getApplicationContext(), location.getLatitude(), location.getLongitude(), getTimeByCal(day),-1));
                                }catch (Exception ex){}
                            }else {
                                Toast.makeText(getApplicationContext(),"failed !!"+location,Toast.LENGTH_SHORT).show();
                            }
                        }
                    }
                });


            }else {

                String TAG = "1/"+ ItemLocation.getLal(getApplicationContext())+" * "+ItemLocation.getLong(getApplicationContext());
                Log.e("TAG 2",TAG);
                showSalatTime(ItemLocation.getLal(this),ItemLocation.getLong(this),day);


            }
        }
    }

    private Location getLocation() {
        Location location = null;


        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
                &&ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED ) {


            try {


                LocationManager locationManager = (LocationManager) this
                        .getSystemService(Context.LOCATION_SERVICE);

                boolean isGPSEnabled = locationManager
                        .isProviderEnabled(LocationManager.GPS_PROVIDER);

                boolean isNetworkEnabled = locationManager
                        .isProviderEnabled(LocationManager.NETWORK_PROVIDER);

                if (isNetworkEnabled) {

                    if (isNetworkEnabled) {
                        locationManager.requestLocationUpdates(
                                LocationManager.NETWORK_PROVIDER,
                                MIN_TIME_BW_UPDATES,
                                MIN_DISTANCE_CHANGE_FOR_UPDATES, this);

                        if (locationManager != null) {
                            location = locationManager
                                    .getLastKnownLocation(LocationManager.NETWORK_PROVIDER);


                            Log.e("isNetworkEnabled",""+location);

                        }

                    }
                }
                if ((location == null)  && isGPSEnabled) {

                    locationManager.requestLocationUpdates(
                            LocationManager.GPS_PROVIDER, MIN_TIME_BW_UPDATES,
                            MIN_DISTANCE_CHANGE_FOR_UPDATES, this);
                    if (locationManager != null) {
                        location = locationManager
                                .getLastKnownLocation(LocationManager.GPS_PROVIDER);

                        Log.e("isGPSEnabled",""+location);


                    }
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return location;
    }


    public Prayer preinitPrayerTime(int time) {

        // // 80.18859;

        String timeZone = ItemLocation.getTimeZone(this);

        // Test Prayer times here
        Prayer prayers = new Prayer();

        prayers.setTimeFormat(DataSalatCalu.getTimeFormat(this));
        prayers.setCalcMethod(DataSalatCalu.getMethodeCalul(this));
        prayers.setAsrJuristic(DataSalatCalu.getAsrCalul(this));
        prayers.setAdjustHighLats(DataSalatCalu.getAngleCalul(this));
        int[] offsets = { 0, 0, 0, 0, 0, 0, 0 }; // {Fajr,Sunrise,Dhuhr,Asr,Sunset,Maghrib,Isha}
        prayers.tune(offsets);

        Date now = new Date();
        Calendar cal = Calendar.getInstance();
        cal.setTime(now);
        cal.add(Calendar.DATE, time);
        // cal.add( Calendar.MINUTE,
        // Integer.parseInt(pref.getString("daylight","0")));

        if (timeZone.equals("")) {
            timezone =getTimeZone(cal.getTimeZone().getID().toString());
            String TimeZoneName = cal.getTimeZone().getID().toString();
            ItemLocation.setTimeZone(this,TimeZoneName);

        } else {
            timezone = getTimeZone(timeZone);
        }

        return prayers;

    }

    public double getTimeZone(String selectedId) {

        TimeZone timezone = TimeZone.getTimeZone(selectedId);
        int TimeZoneOffset = timezone.getRawOffset() / (60 * 1000);

        int hrs = TimeZoneOffset / 60;
        int mins = TimeZoneOffset % 60;
        String result = hrs + "." + (mins == 30 ? 5 : 0);

        return Double.parseDouble(result);
    }

    public void previous(View view) {
        day--;
        showDateInArabic();
        showSalatTime(ItemLocation.getLal(this),ItemLocation.getLong(this),day);
    }

    public void next(View view) {
        day++;
        showDateInArabic();
        showSalatTime(ItemLocation.getLal(this),ItemLocation.getLong(this),day);
    }
    private void showSalatTime(double lal,double lon,int day){

        if(lal != 0.0 && lon != 0.0) {

            try {
                //Toolbar will now take on default Action Bar characteristics
                List<String> prayerTimes =
                        PrayerTime.getSalatTimes(getApplicationContext(), lal, lon, getTimeByCal(day),0);
                adabterSalat = new AdabterSalat(this, R.layout.item_salat, prayerTimes);
                lv.setAdapter(adabterSalat);


            }catch (Exception ex){};
        }

    }



    private void setAlarm(List<String> timesSalat){



        int hourOfDay = 0,minute = 0;



        for (int index = 0; index < timesSalat.size();index++) {

            AlarmManager manager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
            String t = timesSalat.get(index);

            if(t.length() == 7 || t.length() ==4)
                t = "0"+t;

            hourOfDay =  Integer.parseInt(t.substring(0,2));
            minute = Integer.parseInt(t.substring(3,5));

            Date dat = new Date();
            Calendar cal_alarm = Calendar.getInstance();
            Calendar cal_now = Calendar.getInstance();
            cal_now.setTime(dat);
            cal_alarm.setTime(dat);

            cal_alarm.set(Calendar.HOUR_OF_DAY, hourOfDay);
            cal_alarm.set(Calendar.MINUTE, minute);
            cal_alarm.set(Calendar.SECOND, cal_now.get(Calendar.SECOND));
            if (cal_alarm.before(cal_now)) {
                cal_alarm.add(Calendar.DATE, 1);
            }

            Intent myIntent = new Intent(this, AlarmReceiver.class);
            myIntent.putExtra("number", index);
            PendingIntent pendingIntent = PendingIntent.getBroadcast(this, index, myIntent,PendingIntent.FLAG_CANCEL_CURRENT);
            // manager.set(AlarmManager.RTC_WAKEUP, cal_alarm.getTimeInMillis(), pendingIntent);

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

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == REQUEST_QPPS_TURN_ON) {
                //get location
                Location location = getLocation();

                if (location != null) {
                    showSalatTime(location.getLatitude(), location.getLongitude(), day);
                    ItemLocation.setLal(getApplicationContext(), String.valueOf(location.getLatitude()));
                    ItemLocation.setLong(getApplicationContext(), String.valueOf(location.getLongitude()));
                    //Toolbar will now take on default Action Bar characteristics
                    try {
                        setAlarm(PrayerTime.getSalatTimes(getApplicationContext(), location.getLatitude(), location.getLongitude(), getTimeByCal(day),-1));
                    }catch (Exception ex){}
                }
            }
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
    }

    public void refresh(View view) {
        init();
    }


    @Override
    public void onLocationChanged(Location location) {


        if (location != null) {
            showSalatTime(location.getLatitude(), location.getLongitude(), day);
            ItemLocation.setLal(getApplicationContext(), String.valueOf(location.getLatitude()));
            ItemLocation.setLong(getApplicationContext(), String.valueOf(location.getLongitude()));
            //Toolbar will now take on default Action Bar characteristics
            try {
                setAlarm(PrayerTime.getSalatTimes(getApplicationContext(), location.getLatitude(), location.getLongitude(), getTimeByCal(day),-1));
            }catch (Exception ex){}
        }

    }

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {

    }

    @Override
    public void onProviderEnabled(String provider) {

    }

    @Override
    public void onProviderDisabled(String provider) {

    }
}
