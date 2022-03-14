package com.vitanov.multiimagepicker;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.FileUtils;
import android.provider.MediaStore;
import android.provider.OpenableColumns;
import android.text.TextUtils;
import android.media.ThumbnailUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import androidx.exifinterface.media.ExifInterface;

import com.sangcomz.fishbun.FishBun;
import com.sangcomz.fishbun.FishBunCreator;
import com.sangcomz.fishbun.adapter.image.impl.GlideAdapter;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.ref.WeakReference;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import top.zibin.luban.CompressionPredicate;
import top.zibin.luban.Luban;
import top.zibin.luban.OnCompressListener;

import static android.media.ThumbnailUtils.OPTIONS_RECYCLE_INPUT;


/**
 * MultiImagePickerPlugin
 */
public class MultiImagePickerPlugin implements
        FlutterPlugin,
        ActivityAware,
        MethodCallHandler,
        PluginRegistry.ActivityResultListener {

    private static final String CHANNEL_NAME = "multi_image_picker";
    private static final String REQUEST_THUMBNAIL = "requestThumbnail";
    private static final String REQUEST_ORIGINAL = "requestOriginal";
    private static final String REQUEST_METADATA = "requestMetadata";
    private static final String PICK_IMAGES = "pickImages";
    private static final String MAX_IMAGES = "maxImages";
    private static final String SELECTED_ASSETS = "selectedAssets";
    private static final String ENABLE_CAMERA = "enableCamera";
    private static final String ANDROID_OPTIONS = "androidOptions";
    private static final int REQUEST_CODE_CHOOSE = 1001;
    private MethodChannel channel;
    private Activity activity;
    private Context context;
    private BinaryMessenger messenger;
    private Result pendingResult;
    private MethodCall methodCall;


    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        MultiImagePickerPlugin instance = new MultiImagePickerPlugin();
        instance.onAttachedToEngine(registrar.context(), registrar.messenger(), registrar.activity());
        registrar.addActivityResultListener(instance);
    }

    private void onAttachedToEngine(Context applicationContext, BinaryMessenger binaryMessenger, Activity activity) {
        context = applicationContext;
        messenger = binaryMessenger;
        if (activity != null) {
            this.activity = activity;
        }
        channel = new MethodChannel(binaryMessenger, CHANNEL_NAME);
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger(), null);
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        context = null;
        if (channel != null) {
            channel.setMethodCallHandler(null);
            channel = null;
        }
        messenger = null;
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        binding.addActivityResultListener(this);
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        binding.addActivityResultListener(this);
        activity = binding.getActivity();
    }

    private static class GetThumbnailTask extends AsyncTask<String, Void, ByteBuffer> {
        private WeakReference<Activity> activityReference;
        BinaryMessenger messenger;
        final String identifier;
        final int width;
        final int height;
        final int quality;

        GetThumbnailTask(Activity context, BinaryMessenger messenger, String identifier, int width, int height, int quality) {
            super();
            this.messenger = messenger;
            this.identifier = identifier;
            this.width = width;
            this.height = height;
            this.quality = quality;
            this.activityReference = new WeakReference<>(context);
        }

        @Override
        protected ByteBuffer doInBackground(String... strings) {

//            Log.e("identifier", "doInBackground: ---identifier111: thum" + identifier);

            Uri uri = null;

            if (!identifier.contains("content://")) {

                File file = new File(identifier);
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    uri = FileProvider.getUriForFile(activityReference.get(), activityReference.get().getPackageName() + ".multiFileProvider", file);
                } else {
                    uri = Uri.fromFile(file);
                }

//                newIde = "content://media" + identifier;
            } else {
                uri = Uri.parse(identifier);
            }


            byte[] byteArray = null;

            try {
                // get a reference to the activity if it is still there
                Activity activity = activityReference.get();
                if (activity == null || activity.isFinishing()) return null;

                Bitmap sourceBitmap = getCorrectlyOrientedImage(activity, uri);
                Bitmap bitmap = ThumbnailUtils.extractThumbnail(sourceBitmap, this.width, this.height, OPTIONS_RECYCLE_INPUT);

                if (bitmap == null) return null;

                ByteArrayOutputStream bitmapStream = new ByteArrayOutputStream();
                bitmap.compress(Bitmap.CompressFormat.JPEG, this.quality, bitmapStream);
                byteArray = bitmapStream.toByteArray();
                bitmap.recycle();
                bitmapStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }


            final ByteBuffer buffer;
            if (byteArray != null) {
                buffer = ByteBuffer.allocateDirect(byteArray.length);
                buffer.put(byteArray);
                return buffer;
            }
            return null;
        }

        @Override
        protected void onPostExecute(ByteBuffer buffer) {
            super.onPostExecute(buffer);
            if (buffer != null) {
                this.messenger.send("multi_image_picker/image/" + this.identifier + ".thumb", buffer);
                buffer.clear();
            }
        }
    }

    private static class GetImageTask extends AsyncTask<String, Void, ByteBuffer> {
        private final WeakReference<Activity> activityReference;

        final BinaryMessenger messenger;
        final String identifier;
        final int quality;

        GetImageTask(Activity context, BinaryMessenger messenger, String identifier, int quality) {
            super();
            this.messenger = messenger;
            this.identifier = identifier;
            this.quality = quality;
            this.activityReference = new WeakReference<>(context);
        }

        @Override
        protected ByteBuffer doInBackground(String... strings) {

//            Log.e("identifier", "doInBackground: ---identifier111: orignal" + identifier);

//            final Uri uri = Uri.parse(this.identifier);


            Uri uri = null;

            if (!identifier.contains("content://")) {

                File file = new File(identifier);
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    uri = FileProvider.getUriForFile(activityReference.get(), activityReference.get().getPackageName() + ".multiFileProvider", file);
                } else {
                    uri = Uri.fromFile(file);
                }

//                newIde = "content://media" + identifier;
            } else {
                uri = Uri.parse(identifier);
            }


            byte[] bytesArray = null;

            try {
                // get a reference to the activity if it is still there
                Activity activity = activityReference.get();
                if (activity == null || activity.isFinishing()) return null;

                Bitmap bitmap = getCorrectlyOrientedImage(activity, uri);

                if (bitmap == null) return null;

                ByteArrayOutputStream bitmapStream = new ByteArrayOutputStream();
                bitmap.compress(Bitmap.CompressFormat.JPEG, this.quality, bitmapStream);
                bytesArray = bitmapStream.toByteArray();
                bitmap.recycle();
                bitmapStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }

            assert bytesArray != null;
            if (bytesArray == null) {
                return null;
            }
            final ByteBuffer buffer = ByteBuffer.allocateDirect(bytesArray.length);
            buffer.put(bytesArray);
//            Log.e("size", "doInBackground: -- nBackground: ---identifier111:::"+bytesArray.length );
            return buffer;
        }

        @Override
        protected void onPostExecute(ByteBuffer buffer) {
            super.onPostExecute(buffer);
            this.messenger.send("multi_image_picker/image/" + this.identifier + ".original", buffer);
            if (buffer != null) {
                buffer.clear();
            }
        }
    }

    @Override
    public void onMethodCall(final MethodCall call, final Result result) {

        if (!setPendingMethodCallAndResult(call, result)) {
            finishWithAlreadyActiveError(result);
            return;
        }

        if (PICK_IMAGES.equals(call.method)) {
            final HashMap<String, String> options = call.argument(ANDROID_OPTIONS);
            int maxImages = (int) this.methodCall.argument(MAX_IMAGES);
            boolean enableCamera = (boolean) this.methodCall.argument(ENABLE_CAMERA);
            ArrayList<String> selectedAssets = this.methodCall.argument(SELECTED_ASSETS);
            presentPicker(maxImages, enableCamera, selectedAssets, options);
        } else if (REQUEST_ORIGINAL.equals(call.method)) {
            final String identifier = call.argument("identifier");
            final int quality = (int) call.argument("quality");

            if (!this.uriExists(identifier)) {
                finishWithError("ASSET_DOES_NOT_EXIST", "The requested image does not exist.");
            } else {
                GetImageTask task = new GetImageTask(this.activity, this.messenger, identifier, quality);
                task.execute();
                finishWithSuccess();
            }
        } else if (REQUEST_THUMBNAIL.equals(call.method)) {
            final String identifier = call.argument("identifier");
            final int width = (int) call.argument("width");
            final int height = (int) call.argument("height");
            final int quality = (int) call.argument("quality");

            if (!this.uriExists(identifier)) {
                finishWithError("ASSET_DOES_NOT_EXIST", "The requested image does not exist.");
            } else {
                GetThumbnailTask task = new GetThumbnailTask(this.activity, this.messenger, identifier, width, height, quality);
                task.execute();
                finishWithSuccess();
            }
        } else if (REQUEST_METADATA.equals(call.method)) {
            final String identifier = call.argument("identifier");

            Uri uri = Uri.parse(identifier);
            // Scoped storage related code. We can only get gps location if we ask for original image
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                uri = MediaStore.setRequireOriginal(uri);
            }

            try {
                InputStream in = context.getContentResolver().openInputStream(uri);
                assert in != null;
                ExifInterface exifInterface = new ExifInterface(in);
                finishWithSuccess(getPictureExif(exifInterface, uri));

            } catch (IOException e) {
                finishWithError("Exif error", e.toString());
            }

        } else {
            pendingResult.notImplemented();
            clearMethodCallAndResult();
        }
    }

    private HashMap<String, Object> getPictureExif(ExifInterface exifInterface, Uri uri) {
        HashMap<String, Object> result = new HashMap<>();

        // API LEVEL 24
        String[] tags_str = {
                ExifInterface.TAG_DATETIME,
                ExifInterface.TAG_GPS_DATESTAMP,
                ExifInterface.TAG_GPS_LATITUDE_REF,
                ExifInterface.TAG_GPS_LONGITUDE_REF,
                ExifInterface.TAG_GPS_PROCESSING_METHOD,
                ExifInterface.TAG_IMAGE_WIDTH,
                ExifInterface.TAG_IMAGE_LENGTH,
                ExifInterface.TAG_MAKE,
                ExifInterface.TAG_MODEL
        };
        String[] tags_double = {
                ExifInterface.TAG_APERTURE_VALUE,
                ExifInterface.TAG_FLASH,
                ExifInterface.TAG_FOCAL_LENGTH,
                ExifInterface.TAG_GPS_ALTITUDE,
                ExifInterface.TAG_GPS_ALTITUDE_REF,
                ExifInterface.TAG_GPS_LONGITUDE,
                ExifInterface.TAG_GPS_LATITUDE,
                ExifInterface.TAG_IMAGE_LENGTH,
                ExifInterface.TAG_IMAGE_WIDTH,
                ExifInterface.TAG_ISO_SPEED,
                ExifInterface.TAG_ORIENTATION,
                ExifInterface.TAG_WHITE_BALANCE,
                ExifInterface.TAG_EXPOSURE_TIME
        };
        HashMap<String, Object> exif_str = getExif_str(exifInterface, tags_str);
        result.putAll(exif_str);
        HashMap<String, Object> exif_double = getExif_double(exifInterface, tags_double);
        result.putAll(exif_double);

        // A Temp fix while location data is not returned from the exifInterface due to the errors. It also
        // covers Android >= 10 not loading GPS information from getExif_double
        if (exif_double.isEmpty()
                || !exif_double.containsKey(ExifInterface.TAG_GPS_LATITUDE)
                || !exif_double.containsKey(ExifInterface.TAG_GPS_LONGITUDE)) {

            if (uri != null) {
                HashMap<String, Object> hotfix_map = Build.VERSION.SDK_INT < Build.VERSION_CODES.Q
                        ? getLatLng(uri)
                        : getLatLng(exifInterface, uri);

                result.putAll(hotfix_map);
            }
        }

        if (Build.VERSION.SDK_INT == Build.VERSION_CODES.M) {
            String[] tags_23 = {
                    ExifInterface.TAG_DATETIME_DIGITIZED,
                    ExifInterface.TAG_SUBSEC_TIME,
                    ExifInterface.TAG_SUBSEC_TIME_DIGITIZED,
                    ExifInterface.TAG_SUBSEC_TIME_ORIGINAL
            };
            HashMap<String, Object> exif23 = getExif_str(exifInterface, tags_23);
            result.putAll(exif23);
        }

        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.M) {
            String[] tags_24_str = {
                    ExifInterface.TAG_ARTIST,
                    ExifInterface.TAG_CFA_PATTERN,
                    ExifInterface.TAG_COMPONENTS_CONFIGURATION,
                    ExifInterface.TAG_COPYRIGHT,
                    ExifInterface.TAG_DATETIME_ORIGINAL,
                    ExifInterface.TAG_DEVICE_SETTING_DESCRIPTION,
                    ExifInterface.TAG_EXIF_VERSION,
                    ExifInterface.TAG_FILE_SOURCE,
                    ExifInterface.TAG_FLASHPIX_VERSION,
                    ExifInterface.TAG_GPS_AREA_INFORMATION,
                    ExifInterface.TAG_GPS_DEST_BEARING_REF,
                    ExifInterface.TAG_GPS_DEST_DISTANCE_REF,
                    ExifInterface.TAG_GPS_DEST_LATITUDE_REF,
                    ExifInterface.TAG_GPS_DEST_LONGITUDE_REF,
                    ExifInterface.TAG_GPS_IMG_DIRECTION_REF,
                    ExifInterface.TAG_GPS_MAP_DATUM,
                    ExifInterface.TAG_GPS_MEASURE_MODE,
                    ExifInterface.TAG_GPS_SATELLITES,
                    ExifInterface.TAG_GPS_SPEED_REF,
                    ExifInterface.TAG_GPS_STATUS,
                    ExifInterface.TAG_GPS_TRACK_REF,
                    ExifInterface.TAG_GPS_VERSION_ID,
                    ExifInterface.TAG_IMAGE_DESCRIPTION,
                    ExifInterface.TAG_IMAGE_UNIQUE_ID,
                    ExifInterface.TAG_INTEROPERABILITY_INDEX,
                    ExifInterface.TAG_MAKER_NOTE,
                    ExifInterface.TAG_OECF,
                    ExifInterface.TAG_RELATED_SOUND_FILE,
                    ExifInterface.TAG_SCENE_TYPE,
                    ExifInterface.TAG_SOFTWARE,
                    ExifInterface.TAG_SPATIAL_FREQUENCY_RESPONSE,
                    ExifInterface.TAG_SPECTRAL_SENSITIVITY,
                    ExifInterface.TAG_SUBSEC_TIME_DIGITIZED,
                    ExifInterface.TAG_SUBSEC_TIME_ORIGINAL,
                    ExifInterface.TAG_USER_COMMENT
            };

            String[] tags24_double = {
                    ExifInterface.TAG_APERTURE_VALUE,
                    ExifInterface.TAG_BITS_PER_SAMPLE,
                    ExifInterface.TAG_BRIGHTNESS_VALUE,
                    ExifInterface.TAG_COLOR_SPACE,
                    ExifInterface.TAG_COMPRESSED_BITS_PER_PIXEL,
                    ExifInterface.TAG_COMPRESSION,
                    ExifInterface.TAG_CONTRAST,
                    ExifInterface.TAG_CUSTOM_RENDERED,
                    ExifInterface.TAG_DIGITAL_ZOOM_RATIO,
                    ExifInterface.TAG_EXPOSURE_BIAS_VALUE,
                    ExifInterface.TAG_EXPOSURE_INDEX,
                    ExifInterface.TAG_EXPOSURE_MODE,
                    ExifInterface.TAG_EXPOSURE_PROGRAM,
                    ExifInterface.TAG_FLASH_ENERGY,
                    ExifInterface.TAG_FOCAL_LENGTH_IN_35MM_FILM,
                    ExifInterface.TAG_FOCAL_PLANE_RESOLUTION_UNIT,
                    ExifInterface.TAG_FOCAL_PLANE_X_RESOLUTION,
                    ExifInterface.TAG_FOCAL_PLANE_Y_RESOLUTION,
                    ExifInterface.TAG_F_NUMBER,
                    ExifInterface.TAG_GAIN_CONTROL,
                    ExifInterface.TAG_GPS_DEST_BEARING,
                    ExifInterface.TAG_GPS_DEST_DISTANCE,
                    ExifInterface.TAG_GPS_DEST_LATITUDE,
                    ExifInterface.TAG_GPS_DEST_LONGITUDE,
                    ExifInterface.TAG_GPS_DIFFERENTIAL,
                    ExifInterface.TAG_GPS_DOP,
                    ExifInterface.TAG_GPS_IMG_DIRECTION,
                    ExifInterface.TAG_GPS_SPEED,
                    ExifInterface.TAG_GPS_TRACK,
                    ExifInterface.TAG_JPEG_INTERCHANGE_FORMAT,
                    ExifInterface.TAG_JPEG_INTERCHANGE_FORMAT_LENGTH,
                    ExifInterface.TAG_LIGHT_SOURCE,
                    ExifInterface.TAG_MAX_APERTURE_VALUE,
                    ExifInterface.TAG_METERING_MODE,
                    ExifInterface.TAG_PHOTOMETRIC_INTERPRETATION,
                    ExifInterface.TAG_PIXEL_X_DIMENSION,
                    ExifInterface.TAG_PIXEL_Y_DIMENSION,
                    ExifInterface.TAG_PLANAR_CONFIGURATION,
                    ExifInterface.TAG_PRIMARY_CHROMATICITIES,
                    ExifInterface.TAG_REFERENCE_BLACK_WHITE,
                    ExifInterface.TAG_RESOLUTION_UNIT,
                    ExifInterface.TAG_ROWS_PER_STRIP,
                    ExifInterface.TAG_SAMPLES_PER_PIXEL,
                    ExifInterface.TAG_SATURATION,
                    ExifInterface.TAG_SCENE_CAPTURE_TYPE,
                    ExifInterface.TAG_SENSING_METHOD,
                    ExifInterface.TAG_SHARPNESS,
                    ExifInterface.TAG_SHUTTER_SPEED_VALUE,
                    ExifInterface.TAG_STRIP_BYTE_COUNTS,
                    ExifInterface.TAG_STRIP_OFFSETS,
                    ExifInterface.TAG_SUBJECT_AREA,
                    ExifInterface.TAG_SUBJECT_DISTANCE,
                    ExifInterface.TAG_SUBJECT_DISTANCE_RANGE,
                    ExifInterface.TAG_SUBJECT_LOCATION,
                    ExifInterface.TAG_THUMBNAIL_IMAGE_LENGTH,
                    ExifInterface.TAG_THUMBNAIL_IMAGE_WIDTH,
                    ExifInterface.TAG_TRANSFER_FUNCTION,
                    ExifInterface.TAG_WHITE_POINT,
                    ExifInterface.TAG_X_RESOLUTION,
                    ExifInterface.TAG_Y_CB_CR_COEFFICIENTS,
                    ExifInterface.TAG_Y_CB_CR_POSITIONING,
                    ExifInterface.TAG_Y_CB_CR_SUB_SAMPLING,
                    ExifInterface.TAG_Y_RESOLUTION,
            };
            HashMap<String, Object> exif24_str = getExif_str(exifInterface, tags_24_str);
            result.putAll(exif24_str);
            HashMap<String, Object> exif24_double = getExif_double(exifInterface, tags24_double);
            result.putAll(exif24_double);
        }

        return result;
    }

    private HashMap<String, Object> getExif_str(ExifInterface exifInterface, String[] tags) {
        HashMap<String, Object> result = new HashMap<>();
        for (String tag : tags) {
            String attribute = exifInterface.getAttribute(tag);
            if (!TextUtils.isEmpty(attribute)) {
                result.put(tag, attribute);
            }
        }
        return result;
    }

    private HashMap<String, Object> getExif_double(ExifInterface exifInterface, String[] tags) {
        HashMap<String, Object> result = new HashMap<>();
        for (String tag : tags) {
            double attribute = exifInterface.getAttributeDouble(tag, 0.0);
            if (attribute != 0.0) {
                result.put(tag, attribute);
            }
        }
        return result;
    }

    private boolean uriExists(String identifier) {
        if (identifier != null && !identifier.contains("content://")) {
            File file = new File(identifier);
            boolean exists = file.exists();
            return exists;
        }

//        Log.e("identifier", "uriExists:  -- identifier: " + identifier);
        Uri uri = Uri.parse(identifier);

        String fileName = this.getFileName(uri);

        return (fileName != null);
    }

    private void presentPicker(int maxImages, boolean enableCamera, ArrayList<String> selectedAssets, HashMap<String, String> options) {
        String actionBarColor = options.get("actionBarColor");
        String statusBarColor = options.get("statusBarColor");
        String lightStatusBar = options.get("lightStatusBar");
        String actionBarTitle = options.get("actionBarTitle");
        String actionBarTitleColor = options.get("actionBarTitleColor");
        String allViewTitle = options.get("allViewTitle");
        String startInAllView = options.get("startInAllView");
        String useDetailsView = options.get("useDetailsView");
        String selectCircleStrokeColor = options.get("selectCircleStrokeColor");
        String selectionLimitReachedText = options.get("selectionLimitReachedText");
        String textOnNothingSelected = options.get("textOnNothingSelected");
        String backButtonDrawable = options.get("backButtonDrawable");
        String okButtonDrawable = options.get("okButtonDrawable");
        String autoCloseOnSelectionLimit = options.get("autoCloseOnSelectionLimit");
        ArrayList<Uri> selectedUris = new ArrayList<Uri>();

        for (String path : selectedAssets) {
            selectedUris.add(Uri.parse(path));
        }

        FishBunCreator fishBun = FishBun.with(MultiImagePickerPlugin.this.activity)
                .setImageAdapter(new GlideAdapter())
                .setMaxCount(maxImages)
                .hasCameraInPickerPage(enableCamera)
                .setRequestCode(REQUEST_CODE_CHOOSE)
                .setSelectedImages(selectedUris)
                .exceptGif(true)
                .setIsUseDetailView(useDetailsView.equals("true"))
                .setReachLimitAutomaticClose(autoCloseOnSelectionLimit.equals("true"))
                .setButtonInAlbumActivity(true)
//                .isStartInAllView(startInAllView.equals("true"))
                ;

        if (!textOnNothingSelected.isEmpty()) {
            fishBun.textOnNothingSelected(textOnNothingSelected);
        }

        if (!backButtonDrawable.isEmpty()) {
            int id = context.getResources().getIdentifier(backButtonDrawable, "drawable", context.getPackageName());
            fishBun.setHomeAsUpIndicatorDrawable(ContextCompat.getDrawable(context, id));
        }

        if (!okButtonDrawable.isEmpty()) {
            int id = context.getResources().getIdentifier(okButtonDrawable, "drawable", context.getPackageName());
            fishBun.setDoneButtonDrawable(ContextCompat.getDrawable(context, id));
        }

        if (actionBarColor != null && !actionBarColor.isEmpty()) {
            int color = Color.parseColor(actionBarColor);
            if (statusBarColor != null && !statusBarColor.isEmpty()) {
                int statusBarColorInt = Color.parseColor(statusBarColor);
                if (lightStatusBar != null && !lightStatusBar.isEmpty()) {
                    boolean lightStatusBarValue = lightStatusBar.equals("true");
                    fishBun.setActionBarColor(color, statusBarColorInt, lightStatusBarValue);
                } else {
                    fishBun.setActionBarColor(color, statusBarColorInt);
                }
            } else {
                fishBun.setActionBarColor(color);
            }
        }

        if (actionBarTitle != null && !actionBarTitle.isEmpty()) {
            fishBun.setActionBarTitle(actionBarTitle);
        }

        if (selectionLimitReachedText != null && !selectionLimitReachedText.isEmpty()) {
            fishBun.textOnImagesSelectionLimitReached(selectionLimitReachedText);
        }

        if (selectCircleStrokeColor != null && !selectCircleStrokeColor.isEmpty()) {
            fishBun.setSelectCircleStrokeColor(Color.parseColor(selectCircleStrokeColor));
        }

        if (actionBarTitleColor != null && !actionBarTitleColor.isEmpty()) {
            int color = Color.parseColor(actionBarTitleColor);
            fishBun.setActionBarTitleColor(color);
        }

        if (allViewTitle != null && !allViewTitle.isEmpty()) {
            fishBun.setAllViewTitle(allViewTitle);
        }

        fishBun.startAlbum();

    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_CODE_CHOOSE && resultCode == Activity.RESULT_CANCELED) {
            finishWithError("CANCELLED", "The user has cancelled the selection");
        } else if (requestCode == REQUEST_CODE_CHOOSE && resultCode == Activity.RESULT_OK) {


            List<Uri> photos = data.getParcelableArrayListExtra(FishBun.INTENT_PATH);
            if (photos == null) {
                clearMethodCallAndResult();
                return false;
            }
            compressImg(photos);

            return true;
        } else {
            finishWithSuccess(Collections.emptyList());
            clearMethodCallAndResult();
        }
        return false;
    }

    private void compressImg(final List<Uri> photos) {

        final List<File> files = new ArrayList<File>();

        final List<HashMap<String, Object>> hashMaps = resultForError(photos);

        final String compressPath = getCompressPath();
//        MiPictureHelper

        List<String> paths = getPathsByUris(photos);
        for (int i = 0; i < paths.size(); i++) {
//            Log.e("paths ", "compressImg: --- " + paths.get(i));

            Luban.with(activity)
                    .load(paths.get(i))
                    .ignoreBy(30)
                    .setTargetDir(compressPath)
                    .filter(new CompressionPredicate() {
                        @Override
                        public boolean apply(String path) {
//                            Log.e("identifier", "doInBackgroundapply: " + path);
//                            return true;
                            return !((TextUtils.isEmpty(path) || path.toLowerCase().endsWith(".gif")));
                        }
                    })
                    .setCompressListener(new OnCompressListener() {
                        @Override
                        public void onStart() {
                        }

                        @Override
                        public void onSuccess(File file) {
//                            Log.e("file", "doInBackgroundresultForErroronSuccess: -- compressPath:" + compressPath + "----getPath:---" + (file.getAbsoluteFile().getPath()) + "--" + (file.getName()));

                            files.add(file);
                            if ((files.size() == photos.size())) {
                                resultCompressImg(files, hashMaps);
                            }
                            // TODO 压缩成功后调用，返回压缩后的图片文件
                        }

                        @Override
                        public void onError(Throwable e) {
                            ///出错的话 就不压缩了 ， 直接去 返回
                            Log.e("doInBackground", "doInBackgroundonError: " + e.getMessage());
                            resultForError(photos);
                            // TODO 当压缩过程出现问题时调用
                        }
                    }).launch();
        }


    }

    private List<String> getPathsByUris(List<Uri> photos) {

        if (photos == null) return null;


        List<String> paths = new ArrayList<String>();
        for (int i = 0; i < photos.size(); i++) {
            String path = MiPictureHelper.getPath(activity, photos.get(i));
            paths.add(path);
        }

        return paths;
    }

    private void resultCompressImg(List<File> files, List<HashMap<String, Object>> hashMaps) {


        List<HashMap<String, Object>> result = new ArrayList<>(files.size());
        for (File file : files) {
            if (file == null) {
                continue;
            }
            HashMap<String, Object> map = new HashMap<>();
            map.put("identifier", file.toString());
            InputStream is = null;
            int width = 0, height = 0;

            try {
                is = new FileInputStream(file);
                BitmapFactory.Options dbo = new BitmapFactory.Options();
                dbo.inJustDecodeBounds = true;
                dbo.inScaled = false;
                dbo.inSampleSize = 1;
                BitmapFactory.decodeStream(is, null, dbo);
                if (is != null) {
                    is.close();
                }

                int orientation = getOrientation(context, new FileInputStream(file));

                if (orientation == 90 || orientation == 270) {
                    width = dbo.outHeight;
                    height = dbo.outWidth;
                } else {
                    width = dbo.outWidth;
                    height = dbo.outHeight;
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

            map.put("width", width);
            map.put("height", height);
            String path = file.getPath();
            String getAbsolutePath = file.getAbsolutePath();
            String getName = file.getName();
//            Log.e("fileName", "resultForError:path -- " + path);
//            Log.e("fileName", "resultForError:getAbsolutePath -- " + getAbsolutePath);
//            Log.e("fileName", "resultForError:getName -- " + getName);
//            Log.e("fileName", "doInBackgroundresultForError:222 -- " + getAbsolutePath);

            map.put("name", getAbsolutePath);
            result.add(map);
        }

//        result.addAll(hashMaps);
        finishWithSuccess(result);


    }

    private List<HashMap<String, Object>> resultForError(List<Uri> photos) {

        List<HashMap<String, Object>> result = new ArrayList<>(photos.size());
        for (Uri uri : photos) {
            if (uri == null) {
                continue;
            }
            HashMap<String, Object> map = new HashMap<>();
            map.put("identifier", uri.toString());
            InputStream is = null;
            int width = 0, height = 0;

            try {
                is = context.getContentResolver().openInputStream(uri);
                BitmapFactory.Options dbo = new BitmapFactory.Options();
                dbo.inJustDecodeBounds = true;
                dbo.inScaled = false;
                dbo.inSampleSize = 1;
                BitmapFactory.decodeStream(is, null, dbo);
                if (is != null) {
                    is.close();
                }

                int orientation = getOrientation(context, context.getContentResolver().openInputStream(uri));

                if (orientation == 90 || orientation == 270) {
                    width = dbo.outHeight;
                    height = dbo.outWidth;
                } else {
                    width = dbo.outWidth;
                    height = dbo.outHeight;
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

            map.put("width", width);
            map.put("height", height);
            String fileName = getFileName(uri);
//            Log.e("fileName", "doInBackgroundresultForError:111 -- " + fileName);
            map.put("name", fileName);
            result.add(map);
        }

        return result;
//        finishWithSuccess(result);

    }

    private String getCompressPath() {
//
//        final String pathLoad = activity.getCacheDir() + "/imagesUpLoad/images";
//        File file = new File(pathLoad);
//        if (!file.exists() || file.isFile()) {
//            file.mkdirs();
//        }

//        return pathLoad;
        return activity.getCacheDir().getPath();
    }

    private HashMap<String, Object> getLatLng(ExifInterface exifInterface, @NonNull Uri uri) {
        HashMap<String, Object> result = new HashMap<>();
        double[] latLong = exifInterface.getLatLong();
        if (latLong != null && latLong.length == 2) {
            result.put(ExifInterface.TAG_GPS_LATITUDE, Math.abs(latLong[0]));
            result.put(ExifInterface.TAG_GPS_LONGITUDE, Math.abs(latLong[1]));
        }
        return result;
    }

    private HashMap<String, Object> getLatLng(@NonNull Uri uri) {
        HashMap<String, Object> result = new HashMap<>();
        String latitudeStr = "latitude";
        String longitudeStr = "longitude";
        List<String> latlngList = Arrays.asList(latitudeStr, longitudeStr);

        int indexNotPresent = -1;

        String uriScheme = uri.getScheme();

        if (uriScheme == null) {
            return result;
        }

        if (uriScheme.equals("content")) {
            Cursor cursor = context.getContentResolver().query(uri, null, null, null, null);

            if (cursor == null) {
                return result;
            }

            try {
                String[] columnNames = cursor.getColumnNames();
                List<String> columnNamesList = Arrays.asList(columnNames);

                for (String latorlngStr : latlngList) {
                    cursor.moveToFirst();
                    int index = columnNamesList.indexOf(latorlngStr);
                    if (index > indexNotPresent) {
                        Double val = cursor.getDouble(index);
                        // Inserting it as abs as it is the ref the define if the value should be negative or positive
                        if (latorlngStr.equals(latitudeStr)) {
                            result.put(ExifInterface.TAG_GPS_LATITUDE, Math.abs(val));
                        } else {
                            result.put(ExifInterface.TAG_GPS_LONGITUDE, Math.abs(val));
                        }
                    }
                }
            } catch (NullPointerException e) {
                e.printStackTrace();
            } finally {
                try {
                    cursor.close();
                } catch (NullPointerException e) {
                    e.printStackTrace();
                }
            }
        }

        return result;
    }

    private String getFileName(Uri uri) {
        String result = null;
        if (uri.getScheme().equals("content")) {
            Cursor cursor = context.getContentResolver().query(uri, null, null, null, null);
            try {
                if (cursor != null && cursor.moveToFirst()) {
                    result = cursor.getString(cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME));
                }
            } finally {
                cursor.close();
            }
        }
        if (result == null) {
            result = uri.getPath();
            int cut = result.lastIndexOf('/');
            if (cut != -1) {
                result = result.substring(cut + 1);
            }
        }
        return result;
    }

    private static int getOrientation(Context context, InputStream fileInputStream) {
        int rotationDegrees = 0;
        try {
            InputStream in = fileInputStream;
            assert (in != null);
            ExifInterface exifInterface = new ExifInterface(in);
            int orientation = exifInterface.getAttributeInt(ExifInterface.TAG_ORIENTATION, 1);
            switch (orientation) {
                case ExifInterface.ORIENTATION_ROTATE_90:
                    rotationDegrees = 90;
                    break;
                case ExifInterface.ORIENTATION_ROTATE_180:
                    rotationDegrees = 180;
                    break;
                case ExifInterface.ORIENTATION_ROTATE_270:
                    rotationDegrees = 270;
                    break;
            }
        } catch (Exception ignored) {

        }
        return rotationDegrees;
    }

    private static Bitmap getCorrectlyOrientedImage(Context context, Uri photoUri) throws IOException {
        InputStream is = context.getContentResolver().openInputStream(photoUri);
        BitmapFactory.Options dbo = new BitmapFactory.Options();
        dbo.inScaled = false;
        dbo.inSampleSize = 1;
        dbo.inJustDecodeBounds = true;
        BitmapFactory.decodeStream(is, null, dbo);
        if (is != null) {
            is.close();
        }

        int orientation = getOrientation(context, context.getContentResolver().openInputStream(photoUri));

        Bitmap srcBitmap;
        is = context.getContentResolver().openInputStream(photoUri);
        srcBitmap = BitmapFactory.decodeStream(is);
        if (is != null) {
            is.close();
        }

        if (orientation > 0) {
            Matrix matrix = new Matrix();
            matrix.postRotate(orientation);

            srcBitmap = Bitmap.createBitmap(srcBitmap, 0, 0, srcBitmap.getWidth(),
                    srcBitmap.getHeight(), matrix, true);
        }

        return srcBitmap;
    }

    public static int calculateInSampleSize(
            BitmapFactory.Options options, int reqWidth, int reqHeight) {
        // Raw height and width of image
        final int height = options.outHeight;
        final int width = options.outWidth;
        int inSampleSize = 1;

        if (height > reqHeight || width > reqWidth) {

            final int halfHeight = height / 2;
            final int halfWidth = width / 2;

            // Calculate the largest inSampleSize value that is a power of 2 and keeps both
            // height and width larger than the requested height and width.
            while ((halfHeight / inSampleSize) >= reqHeight
                    && (halfWidth / inSampleSize) >= reqWidth) {
                inSampleSize *= 2;
            }
        }

        return inSampleSize;
    }

    private void finishWithSuccess(List imagePathList) {
        if (pendingResult != null)
            pendingResult.success(imagePathList);
        clearMethodCallAndResult();
    }

    private void finishWithSuccess(HashMap<String, Object> hashMap) {
        if (pendingResult != null)
            pendingResult.success(hashMap);
        clearMethodCallAndResult();
    }

    private void finishWithSuccess() {
        if (pendingResult != null)
            pendingResult.success(true);
        clearMethodCallAndResult();
    }

    private void finishWithAlreadyActiveError(Result result) {
        if (result != null)
            result.error("already_active", "Image picker is already active", null);
    }

    private void finishWithError(String errorCode, String errorMessage) {
        if (pendingResult != null)
            pendingResult.error(errorCode, errorMessage, null);
        clearMethodCallAndResult();
    }

    private void clearMethodCallAndResult() {
        methodCall = null;
        pendingResult = null;
    }

    private boolean setPendingMethodCallAndResult(
            MethodCall methodCall, Result result) {
        if (pendingResult != null) {
            return false;
        }

        this.methodCall = methodCall;
        pendingResult = result;
        return true;
    }
}
