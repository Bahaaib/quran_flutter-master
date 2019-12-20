package codeline.net.quran_images;

import android.content.Context;

public class DataSalatCalu {

    private static final String DATA_CALULATION = "DATA_CALULATION";
    private static final String EXTRA_METHODE_CALULATION = "EXTRA_METHODE_CALULATION";
    private static final String EXTRA_ASR_CALULATION = "EXTRA_ASR_CALULATION";
    private static final String EXTRA_ANGLE_BASED_CALULATION = "EXTRA_ANGLE_BASED_CALULATION";
    private static final String EXTRA_TIME_FORMAT_CALULATION = "EXTRA_TIME_FORMAT_CALULATION";


    public static void setMethodeCalcul(Context ctx,int m){
        ctx.getSharedPreferences(DATA_CALULATION,Context.MODE_PRIVATE)
                .edit().putInt(EXTRA_METHODE_CALULATION,m).apply();
    }

    public static void setAsrCalcul(Context ctx,int m){
        ctx.getSharedPreferences(DATA_CALULATION,Context.MODE_PRIVATE)
                .edit().putInt(EXTRA_ASR_CALULATION,m).apply();
    }
    public static void setAngleeCalcul(Context ctx,int m){
        ctx.getSharedPreferences(DATA_CALULATION,Context.MODE_PRIVATE)
                .edit().putInt(EXTRA_ANGLE_BASED_CALULATION,m).apply();
    }


    public static void setTimeFormat(Context ctx,int m){
        ctx.getSharedPreferences(DATA_CALULATION,Context.MODE_PRIVATE)
                .edit().putInt(EXTRA_TIME_FORMAT_CALULATION,m).apply();
    }


    /// get

    public static  int getMethodeCalul(Context ctx){
        return ctx.getSharedPreferences(DATA_CALULATION,Context.MODE_PRIVATE)
                .getInt(EXTRA_METHODE_CALULATION,1);
    }

    public static  int getAsrCalul(Context ctx){
        return ctx.getSharedPreferences(DATA_CALULATION,Context.MODE_PRIVATE)
                .getInt(EXTRA_ASR_CALULATION,1);
    }

    public static  int getAngleCalul(Context ctx){
        return ctx.getSharedPreferences(DATA_CALULATION,Context.MODE_PRIVATE)
                .getInt(EXTRA_ANGLE_BASED_CALULATION,1);
    }

    public static  int getTimeFormat(Context ctx){
        return ctx.getSharedPreferences(DATA_CALULATION,Context.MODE_PRIVATE)
                .getInt(EXTRA_TIME_FORMAT_CALULATION,1);
    }
}
