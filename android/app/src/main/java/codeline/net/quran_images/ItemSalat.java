package codeline.net.quran_images;

import android.content.Context;

public class ItemSalat {

    private String time;
    private String timeAndSuffix;

    public ItemSalat(String time, String timeAndSuffix) {
        this.time = time;
        this.timeAndSuffix = timeAndSuffix;
    }

    public static String getNameOfSalat(Context context,int pos){
        String[] salatName;
            salatName = new String[]{"الفجر", "الصبح" ,"الظهر" ,"العصر", "غروب الشمس", "المغرب" , "العشاء" };

        return  salatName[pos];
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }


    public String getTimeAndSuffix() {
        return timeAndSuffix;
    }

    public void setTimeAndSuffix(String timeAndSuffix) {
        this.timeAndSuffix = timeAndSuffix;
    }
}
