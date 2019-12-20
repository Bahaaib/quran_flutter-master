package codeline.net.quran_images.qibla;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.RotateAnimation;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.util.Locale;

import codeline.net.quran_images.R;

import static android.view.View.INVISIBLE;


public class CompassActivity extends AppCompatActivity {
    private static final String TAG = CompassActivity.class.getSimpleName();
    private Compass compass;
    private ImageView qiblatIndicator;
    private ImageView imageDial;
    private TextView tvAngle;
    private TextView tvYourLocation;
    //public Menu menu;
    //public MenuItem item;
    private float currentAzimuth;
    SharedPreferences prefs;
    GPSTracker gps;
    private final int RC_Permission = 1221;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_compass);

        setUserChanges(getIntent());

        /////////////////////////////////////////////////
        prefs = getSharedPreferences("", MODE_PRIVATE);
        gps = new GPSTracker(this);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        //////////////////////////////////////////
        qiblatIndicator = findViewById(R.id.qibla_indicator);
        imageDial = findViewById(R.id.dial);
        tvAngle = findViewById(R.id.angle);
        tvYourLocation = findViewById(R.id.your_location);

        //////////////////////////////////////////
        qiblatIndicator.setVisibility(INVISIBLE);
        qiblatIndicator.setVisibility(View.GONE);

        setupCompass();
    }

    @Override
    protected void onStart() {
        super.onStart();
        Log.d(TAG, "start compass");
        if (compass != null) {
            compass.start(this);
        }

    }

    @Override
    protected void onPause() {
        super.onPause();
        if (compass != null) {
            compass.stop();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();

        if (compass != null) {
            compass.start(this);
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        Log.d(TAG, "stop compass");
        if (compass != null) {
            compass.stop();
        }
        if (gps != null) {
            gps.stopUsingGPS();
            gps = null;
        }
    }

    private void setUserChanges(Intent intent) {
        try {


            // Root Background Color
            findViewById(R.id.root).setBackgroundColor(
                    (intent.getExtras() != null &&
                            intent.getExtras().containsKey(Constants.COMPASS_BG_COLOR)) ?
                            Color.parseColor(intent.getExtras().getString(Constants.COMPASS_BG_COLOR)) :
                            Color.parseColor("#" + Integer.toHexString(
                                    ContextCompat.getColor(this, R.color.bg_color))));

            // Qibla Degrees Text Color
            ((TextView) findViewById(R.id.angle)).setTextColor(
                    (intent.getExtras() != null &&
                            intent.getExtras().containsKey(Constants.ANGLE_TEXT_COLOR)) ?
                            Color.parseColor(intent.getExtras().getString(Constants.ANGLE_TEXT_COLOR)) :
                            Color.parseColor("#" + Integer.toHexString(
                                    ContextCompat.getColor(this, android.R.color.white))));

            // Dial
            ((ImageView) findViewById(R.id.dial)).setImageResource(
                    (intent.getExtras() != null &&
                            intent.getExtras().containsKey(Constants.DRAWABLE_DIAL)) ?
                            intent.getExtras().getInt(Constants.DRAWABLE_DIAL) : R.drawable.dial);

            // Qibla Indicator
            ((ImageView) findViewById(R.id.qibla_indicator)).setImageResource(
                    (intent.getExtras() != null &&
                            intent.getExtras().containsKey(Constants.DRAWABLE_QIBLA)) ?
                            intent.getExtras().getInt(Constants.DRAWABLE_QIBLA) : R.drawable.qibla);

            // Footer Image
            findViewById(R.id.footer_image).setVisibility(
                    (intent.getExtras() != null &&
                            intent.getExtras().containsKey(Constants.FOOTER_IMAGE_VISIBLE)) ?
                            intent.getExtras().getInt(Constants.FOOTER_IMAGE_VISIBLE) : View.VISIBLE);

            // Your Location TextView
            findViewById(R.id.your_location).setVisibility(
                    (intent.getExtras() != null &&
                            intent.getExtras().containsKey(Constants.LOCATION_TEXT_VISIBLE)) ?
                            intent.getExtras().getInt(Constants.LOCATION_TEXT_VISIBLE) : View.VISIBLE);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void setupCompass() {
        Boolean permission_granted = GetBoolean("permission_granted");
        if (permission_granted) {
            getBearing();
        } else {
            tvAngle.setText(getResources().getString(R.string.msg_permission_not_granted_yet));
            tvYourLocation.setText(getResources().getString(R.string.msg_permission_not_granted_yet));
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.ACCESS_FINE_LOCATION,
                                Manifest.permission.ACCESS_COARSE_LOCATION},
                        RC_Permission);
            } else {
                fetch_GPS();
            }
        }


        compass = new Compass(this);
        Compass.CompassListener cl = new Compass.CompassListener() {

            @Override
            public void onNewAzimuth(float azimuth) {
                // adjustArrow(azimuth);
                adjustGambarDial(azimuth);
                adjustArrowQiblat(azimuth);
            }
        };
        compass.setListener(cl);

        ////////////// ADDED CODE ///////////////
        //fetch_GPS();
    }


    public void adjustGambarDial(float azimuth) {
        // Log.d(TAG, "will set rotation from " + currentAzimuth + " to "                + azimuth);

        Animation an = new RotateAnimation(-currentAzimuth, -azimuth,
                Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF,
                0.5f);
        currentAzimuth = (azimuth);
        an.setDuration(500);
        an.setRepeatCount(0);
        an.setFillAfter(true);
        imageDial.startAnimation(an);
    }

    public void adjustArrowQiblat(float azimuth) {
        //Log.d(TAG, "will set rotation from " + currentAzimuth + " to "                + azimuth);

        float kiblat_derajat = GetFloat("kiblat_derajat");
        Animation an = new RotateAnimation(-(currentAzimuth) + kiblat_derajat, -azimuth,
                Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF,
                0.5f);
        currentAzimuth = (azimuth);
        an.setDuration(500);
        an.setRepeatCount(0);
        an.setFillAfter(true);
        qiblatIndicator.startAnimation(an);
        if (kiblat_derajat > 0) {
            qiblatIndicator.setVisibility(View.VISIBLE);
        } else {
            qiblatIndicator.setVisibility(INVISIBLE);
            qiblatIndicator.setVisibility(View.GONE);
        }
    }

    @SuppressLint("MissingPermission")
    public void getBearing() {
        // Get the location manager

        float kaabaDegs = GetFloat("kiblat_derajat");
        if (kaabaDegs > 0.0001) {
            String strYourLocation;
            if(gps.getLocation() != null)
                strYourLocation = getResources().getString(R.string.your_location)
                        + " " + gps.getLocation().getLatitude() + ", " + gps.getLocation().getLongitude();
            else
                strYourLocation = getResources().getString(R.string.unable_to_get_your_location);
            tvYourLocation.setText(strYourLocation);
            String strKaabaDirection = String.format(Locale.ENGLISH, "%.0f", kaabaDegs)
                    + " " + getResources().getString(R.string.degree) + " " + getDirectionString(kaabaDegs);
            tvAngle.setText(strKaabaDirection);

            qiblatIndicator.setVisibility(View.VISIBLE);
        } else {
            fetch_GPS();
        }
    }

    private String getDirectionString(float azimuthDegrees) {
        String where = "NW";

        if (azimuthDegrees >= 350 || azimuthDegrees <= 10)
            where = "N";
        if (azimuthDegrees < 350 && azimuthDegrees > 280)
            where = "NW";
        if (azimuthDegrees <= 280 && azimuthDegrees > 260)
            where = "W";
        if (azimuthDegrees <= 260 && azimuthDegrees > 190)
            where = "SW";
        if (azimuthDegrees <= 190 && azimuthDegrees > 170)
            where = "S";
        if (azimuthDegrees <= 170 && azimuthDegrees > 100)
            where = "SE";
        if (azimuthDegrees <= 100 && azimuthDegrees > 80)
            where = "E";
        if (azimuthDegrees <= 80 && azimuthDegrees > 10)
            where = "NE";

        return where;
    }


    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        if (requestCode == RC_Permission) {
            // If request is cancelled, the result arrays are empty.
            if (grantResults.length > 0
                    && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // permission was granted, yay! Do the
                SaveBoolean("permission_granted", true);
                tvAngle.setText(getResources().getString(R.string.msg_permission_granted));
                tvYourLocation.setText(getResources().getString(R.string.msg_permission_granted));
                qiblatIndicator.setVisibility(INVISIBLE);
                qiblatIndicator.setVisibility(View.GONE);

                fetch_GPS();
            } else {
                Toast.makeText(getApplicationContext(), getResources().getString(R.string.toast_permission_required), Toast.LENGTH_LONG).show();
                finish();
            }
        }
    }


    public void SaveBoolean(String Judul, Boolean bbb) {
        SharedPreferences.Editor edit = prefs.edit();
        edit.putBoolean(Judul, bbb);
        edit.apply();
    }

    public Boolean GetBoolean(String Judul) {
        return prefs.getBoolean(Judul, false);
    }

    public void SaveFloat(String Judul, Float bbb) {
        SharedPreferences.Editor edit = prefs.edit();
        edit.putFloat(Judul, bbb);
        edit.apply();
    }

    public Float GetFloat(String Judul) {
        return prefs.getFloat(Judul, 0);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        return super.onOptionsItemSelected(item);

    }

    public void fetch_GPS() {
        double result;
        gps = new GPSTracker(this);
        if (gps.canGetLocation()) {
            double myLat = gps.getLatitude();
            double myLng = gps.getLongitude();
            // \n is for new line
            String strYourLocation = getResources().getString(R.string.your_location)
                    + " " + myLat + ", " + myLng;
            tvYourLocation.setText(strYourLocation);
            //Toast.makeText(getApplicationContext(), "Lokasi anda: - \nLat: " + latitude + "\nLong: " + longitude, Toast.LENGTH_LONG).show();
            Log.e("TAG", "GPS is on");
            if (myLat < 0.001 && myLng < 0.001) {
                // qiblatIndicator.isShown(false);
                qiblatIndicator.setVisibility(INVISIBLE);
                qiblatIndicator.setVisibility(View.GONE);
                tvAngle.setText(getResources().getString(R.string.location_not_ready));
                tvYourLocation.setText(getResources().getString(R.string.location_not_ready));
                     } else {
                //21.422487, 39.826206
                double kaabaLng = 39.826206; // ka'bah Position https://www.latlong.net/place/kaaba-mecca-saudi-arabia-12639.html
                double kaabaLat = Math.toRadians(21.422487); // ka'bah Position https://www.latlong.net/place/kaaba-mecca-saudi-arabia-12639.html
                double myLatRad = Math.toRadians(myLat);
                double longDiff = Math.toRadians(kaabaLng - myLng);
                double y = Math.sin(longDiff) * Math.cos(kaabaLat);
                double x = Math.cos(myLatRad) * Math.sin(kaabaLat) - Math.sin(myLatRad) * Math.cos(kaabaLat) * Math.cos(longDiff);
                result = (Math.toDegrees(Math.atan2(y, x)) + 360) % 360;
                SaveFloat("kiblat_derajat", (float) result);
                String strKaabaDirection = String.format(Locale.ENGLISH, "%.0f", (float) result)
                        + " " + getResources().getString(R.string.degree) + " " + getDirectionString((float) result);
                tvAngle.setText(strKaabaDirection);
                qiblatIndicator.setVisibility(View.VISIBLE);

            }
        } else {
            // can't get location
            // GPS or Network is not enabled
            // Ask user to enable GPS/network in settings
            gps.showSettingsAlert();

            // qiblatIndicator.isShown(false);
            qiblatIndicator.setVisibility(INVISIBLE);
            qiblatIndicator.setVisibility(View.GONE);
            tvAngle.setText(getResources().getString(R.string.pls_enable_location));
            tvYourLocation.setText(getResources().getString(R.string.pls_enable_location));
               }
    }
    ////////////////////////////////////
}