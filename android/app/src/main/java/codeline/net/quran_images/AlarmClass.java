package codeline.net.quran_images;

import android.content.Context;

public class AlarmClass {

    private static final String ALARM = "ALARM";
    private static final String EXTRA_ALARM_ = "EXTRA_ALARM_";

    public static final String EXTRA_NAME_OF_SALAT_ = "EXTRA_NAME_OF_SALAT";
    public static final String EXTRA_TIME_OF_SALAT_ = "EXTRA_TIME_OF_SALAT_";
    public static final String EXTRA_POS_OF_SALAT_ = "EXTRA_POS_OF_SALAT_";


    public static void set(Context ctx,String id,boolean a){
        String key = EXTRA_ALARM_+id;
        ctx.getSharedPreferences(ALARM,Context.MODE_PRIVATE)
                .edit().putBoolean(key,a).apply();
    }

    public static boolean get(Context ctx,String id){
        String key = EXTRA_ALARM_+id;
        return ctx.getSharedPreferences(ALARM,Context.MODE_PRIVATE)
                .getBoolean(key,true);
    }
}
