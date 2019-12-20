package codeline.net.quran_images;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.RotateAnimation;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import java.text.DecimalFormat;

public class QiblaActivity extends AppCompatActivity implements SensorEventListener, LocationListener {
    // define the display assembly compass picture
    private ImageView image, imageArrow;

    // record the compass picture angle turned
    private float currentDegree = 0f;

    // device sensor manager
    private SensorManager mSensorManager;
    String angleFormated;
    TextView Direction_Qibla, Qibla_Distance;


    double lat1, lat2, lon1, lon2;

    public final static int REQUEST_QPPS_TURN_ON = 154;


    private static final long MIN_DISTANCE_CHANGE_FOR_UPDATES = 5; // 10 meters

    private static final long MIN_TIME_BW_UPDATES = 1000 * 30 * 1; // 1 minute
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_quibla);
        if(Sensor_Check()){
            init();
            initLocation();
        }else {

                Toast.makeText(getApplicationContext(),
                        "هاتفك لا يدعم خدمة تحديد اتجاه القبلة ❌\n(لايحتوي على حساس المغناطيس)",Toast.LENGTH_SHORT).show();

        }
    }

    public boolean Sensor_Check() {
        SensorManager sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        if (sensorManager.getSensorList(Sensor.TYPE_MAGNETIC_FIELD).size() > 0)
            return true;
        else
            return false;

    }


    private void init(){

        Utils.checkPermissions(this,this);

        image = (ImageView) findViewById(R.id.main_image_compass);
        imageArrow = (ImageView) findViewById(R.id.main_image_arrow);

        // TextView that will tell the user what degree is he heading
        // CityCountryName = (TextView) findViewById(R.id.CityCountryName);
        // Country_Name = (TextView) findViewById(R.id.Country_Name);
        Direction_Qibla = (TextView) findViewById(R.id.Direction_Qibla);
        Qibla_Distance = (TextView) findViewById(R.id.Qibla_Distance);


        // initialize your android device sensor capabilities
        mSensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);


    }


    @Override
    public void onSensorChanged(SensorEvent event) {

        // get the angle around the z-axis rotated
        float degree = Math.round(event.values[0]);
        if(degree != 0 && angleFormated != null) {
            imageArrow.setRotation(Float.parseFloat(angleFormated) - degree);
       /* if (!ActivityHome.Drawer.isDrawerOpen(ActivityHome.category_list))
        {
            try {

                Direction_Qibla.setText(getString(R.string.degree, String
                        .valueOf(Float.parseFloat(angleFormated) - degree)));

            } catch (Exception e) {
                // TODO: handle exception
            }
        }*/
            // tvHeading.setText("Heading: " + Float.toString(degree) + " degrees");

            // create a rotation animation (reverse turn degree degrees)
            RotateAnimation ra = new RotateAnimation(currentDegree, -degree,
                    Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF,
                    0.5f);

            // how long the animation will take place
            ra.setDuration(50);

            // set the animation after the end of the reservation status
            ra.setFillAfter(true);

            // Start the animation
            image.startAnimation(ra);
            currentDegree = -degree;
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }


    @Override
    public void onLocationChanged(Location location) {
        qibleLocation(location.getLatitude(), location.getLongitude());

        ItemLocation.setLal(getApplicationContext(), String.valueOf(location.getLatitude()));
        ItemLocation.setLong(getApplicationContext(), String.valueOf(location.getLongitude()));

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

    public static float distFrom(double lat1, double lng1, double lat2,
                                 double lng2) {
        double earthRadius = 6371000; // meters
        double dLat = Math.toRadians(lat2 - lat1);
        double dLng = Math.toRadians(lng2 - lng1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1))
                * Math.cos(Math.toRadians(lat2)) * Math.sin(dLng / 2)
                * Math.sin(dLng / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        float dist = (float) (earthRadius * c);

        return (dist / 1000);
    }


    public void magnetometer() {
        Location locationA = new Location("point A");

        locationA.setLatitude(lat1);
        locationA.setLongitude(lon1);

        Location locationB = new Location("point B");

        locationB.setLatitude(lat2);
        locationB.setLongitude(lon2);

        float distance = locationA.distanceTo(locationB);

        RotateAnimation ra = new RotateAnimation(currentDegree,distance,
                Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF,
                0.5f);

        // how long the animation will take place
        //	ra.setDuration(210);

        // set the animation after the end of the reservation status
        ra.setFillAfter(true);

        // Start the animation
        currentDegree = distance;
        imageArrow.startAnimation(ra);
        //	imageArrow.setRotation(Float.parseFloat(angleFormated) - distance);


    }
    public Location getLocation() {

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



    private void qibleLocation(double lal,double lon){
        lat2 = 21.422487;
        lon2 = 39.826206;

        //user location
        lat1 = lal;
        lon1 = lon;

        if (mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD) == null) {
            magnetometer();

        }

        // for the system's orientation sensor registered listeners
        mSensorManager.registerListener(this,
                mSensorManager.getDefaultSensor(Sensor.TYPE_ORIENTATION),
                SensorManager.SENSOR_DELAY_GAME);
        Double bearing = bearing(lat1, lon1, lat2, lon2);
        DecimalFormat df = new DecimalFormat("#");
        angleFormated = df.format(bearing);

        Direction_Qibla.setText(getString(R.string.degree,
                String.valueOf(angleFormated)));
        Qibla_Distance.setText(getString(R.string.distance,
                distFrom(lat1, lon1, lat2, lon2)));


    }

    private void initLocation() {

        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {

            //location == null
            GpsUtils gpsUtils = new GpsUtils(this);
            gpsUtils.turnGPSOn(new GpsUtils.onGpsListener() {
                @Override
                public void gpsStatus(boolean isGPSEnable) {
                    if (isGPSEnable) {
                        //get location
                        Location location = getLocation();
                        if (location != null) {

                            qibleLocation(location.getLatitude(), location.getLongitude());

                            ItemLocation.setLal(getApplicationContext(), String.valueOf(location.getLatitude()));
                            ItemLocation.setLong(getApplicationContext(), String.valueOf(location.getLongitude()));


                        } else {
                            Toast.makeText(getApplicationContext(),"failed !!",Toast.LENGTH_SHORT).show();
                        }
                    }else
                        qibleLocation(ItemLocation.getLal(QiblaActivity.this),ItemLocation.getLong(QiblaActivity.this));

                }
            });

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

                    qibleLocation(location.getLatitude(),location.getLongitude());

                    ItemLocation.setLal(getApplicationContext(), String.valueOf(location.getLatitude()));
                    ItemLocation.setLong(getApplicationContext(), String.valueOf(location.getLongitude()));

                }
            }
        }
    }
    @Override
    protected void onResume() {
        super.onResume();
        mSensorManager.registerListener(this,mSensorManager.getDefaultSensor(Sensor.TYPE_ORIENTATION),
                SensorManager.SENSOR_DELAY_GAME);
    }

    @Override
    public void onStop() {

        if(mSensorManager != null){
            // to stop the listener and save battery
            mSensorManager.unregisterListener(this);
        }
        super.onStop();
    }
    public static double radToBearing(double rad) {
        return (Math.toDegrees(rad) + 360) % 360;
    }
    public static double bearing(double lat1, double lon1, double lat2,
                                 double lon2) {
        double lat1Rad = Math.toRadians(lat1);
        double lat2Rad = Math.toRadians(lat2);
        double deltaLonRad = Math.toRadians(lon2 - lon1);

        double y = Math.sin(deltaLonRad) * Math.cos(lat2Rad);
        double x = Math.cos(lat1Rad) * Math.sin(lat2Rad) - Math.sin(lat1Rad)
                * Math.cos(lat2Rad) * Math.cos(deltaLonRad);
        return radToBearing(Math.atan2(y, x));
    }
}
