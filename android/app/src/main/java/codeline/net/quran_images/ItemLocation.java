package codeline.net.quran_images;

import android.content.Context;

public class ItemLocation {

    public static final String EXTRA_LOCATION = "EXTRA_LOCATION";
    public static final String EXTRA_LOCATION_LALTITUDE = "EXTRA_LOCATION_LALTITUDE";
    public static final String EXTRA_LOCATION_LONGITUDE = "EXTRA_LOCATION_LONGITUDE";
    public static final String DEFAULT_VALUE = "0";
    public static final String EXTRA_TIME_ZONE = "EXTRA_TIME_ZONE";

    public static void setLal(Context ctx, String lal){
        ctx.getSharedPreferences(EXTRA_LOCATION,Context.MODE_PRIVATE)
                .edit().putString(EXTRA_LOCATION_LALTITUDE,lal).apply();
    }

    public static void setLong(Context ctx,String longi){
        ctx.getSharedPreferences(EXTRA_LOCATION,Context.MODE_PRIVATE)
                .edit().putString(EXTRA_LOCATION_LONGITUDE,longi).apply();
    }

    public static void setTimeZone(Context ctx,String time){
        ctx.getSharedPreferences(EXTRA_LOCATION,Context.MODE_PRIVATE)
                .edit().putString(EXTRA_TIME_ZONE,time).apply();
    }

    public static String getTimeZone(Context ctx){
        return ctx.getSharedPreferences(EXTRA_LOCATION,Context.MODE_PRIVATE)
                .getString(EXTRA_TIME_ZONE,"");
    }

    public static double getLal(Context ctx){

        return Double.valueOf(ctx.getSharedPreferences(EXTRA_LOCATION,Context.MODE_PRIVATE)
                .getString(EXTRA_LOCATION_LALTITUDE,DEFAULT_VALUE));
    }

    public static double getLong(Context ctx){
        return Double.valueOf(ctx.getSharedPreferences(EXTRA_LOCATION,Context.MODE_PRIVATE)
                .getString(EXTRA_LOCATION_LONGITUDE,DEFAULT_VALUE));
    }


}