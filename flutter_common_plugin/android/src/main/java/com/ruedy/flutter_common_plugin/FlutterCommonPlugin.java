package com.ruedy.flutter_common_plugin;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.ruedy.flutter_common_plugin.jsonUtil.JsonUtils;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * FlutterCommonPlugin
 */
public class FlutterCommonPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private static MethodChannel channel;
    private static Handler mHandler;
    private Context applicationContext;

    public static Activity currentActivity;
    private int mFinalCount;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        applicationContext = flutterPluginBinding.getApplicationContext();
        if (applicationContext != null) {
            registerActivityCallBack(applicationContext);
        }
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_common_plugin");
        channel.setMethodCallHandler(this);
    }

    private void registerActivityCallBack(Context applicationContext) {

        try {
            Application application = (Application) applicationContext.getApplicationContext();
            application.registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks() {


                @Override
                public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
                    currentActivity = activity;
                }

                @Override
                public void onActivityStarted(@NonNull Activity activity) {
                    mFinalCount++;
                    //如果mFinalCount ==1，说明是从后台到前台
                    if (mFinalCount == 1) {
                        //说明从后台回到了前台
                        listenToFrontGround(activity);
                    }
                }

                @Override
                public void onActivityResumed(@NonNull Activity activity) {
                    currentActivity = activity;
                    mFinalCount--;
                    //如果mFinalCount == 0，说明是前台到后台
                    if (mFinalCount == 0) {
                        //说明从前台回到了后台
                        listenToBackground(activity);
                    }

                }

                @Override
                public void onActivityPaused(@NonNull Activity activity) {

                }

                @Override
                public void onActivityStopped(@NonNull Activity activity) {

                }

                @Override
                public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {

                }

                @Override
                public void onActivityDestroyed(@NonNull Activity activity) {

                }
            });

        } catch (Exception e) {
        }

    }

    private static boolean isFront = false;

    ///回到前台了
    private void listenToFrontGround(Activity activity) {
        isFront = true;
    }


    static boolean isAppFront() {

        return isFront;
    }

    ///回到后台了
    private void listenToBackground(Activity activity) {
        isFront = false;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {

        if (TextUtils.equals(call.method, "native://goToDeskTop")) {

            if (currentActivity != null) {
                Intent intent = new Intent(Intent.ACTION_MAIN);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                intent.addCategory(Intent.CATEGORY_HOME);
                currentActivity.startActivity(intent);
                result.success("goToDeskTop");
            }
            return;
        }
        if (TextUtils.equals(call.method, "native://switchAppToFront")) {
            ///判断如果app 不在前台，则 调到前台的方法


            return;
        }

        if (fbPluginCallback != null) {

            try {
                Context context;
                if (currentActivity != null) {
                    context = currentActivity;

                } else {
                    context = applicationContext;
                }
                fbPluginCallback.onMethodCall(context, call.method, JsonUtils.beanToJson(call.arguments), new FBCallBack<Object>() {

                    @Override
                    public void success(final Object nativeResult) {
                        switchThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(nativeResult);

                            }
                        });
                    }

                    @Override
                    public void error(final String errorCode, @Nullable final String errorMessage, @Nullable final Object errorDetails) {

                        Log.e("errorCode", "error:--  errorCode:" + errorCode + "--message:" + errorMessage);
                        switchThread(new Runnable() {
                            @Override
                            public void run() {
                                try {
                                    result.error(errorCode, errorMessage, errorDetails);
                                } catch (Exception e) {

                                }


                            }
                        });
                    }


                    @Override
                    public void notImplemented() {
                        switchThread(new Runnable() {
                            @Override
                            public void run() {
                                try {
                                    result.notImplemented();
                                } catch (Exception e) {

                                }

                            }
                        });
                    }
                });

            } catch (Exception e) {
                e.printStackTrace();
                result.error("400", e.getMessage(), e.getStackTrace());
            }


        } else {
            result.notImplemented();

        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }


    public static void sendEvent(String name, Object args) {
        sendEvent(name, args, null);
    }

    public static void sendEvent(final String name, final Object args, final CallResult callback) {
        if (channel != null) {
            if (Thread.currentThread().getName() == "main") {
                channel.invokeMethod(name, args, callback);
            } else if (currentActivity != null) {
                currentActivity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod(name, args, callback);
                    }
                });
            }

        }
    }

    static FBPluginCallback fbPluginCallback;


    public static void setFbPluginCallback(FBPluginCallback fbPluginCallback) {
        FlutterCommonPlugin.fbPluginCallback = fbPluginCallback;
    }

    public static void switchThread(Runnable runnable) {
        if (runnable == null) {
            return;
        }
        if (mHandler == null) {
            mHandler = new Handler(Looper.getMainLooper());
        }

        if (Thread.currentThread() == Looper.getMainLooper().getThread()) {
            runnable.run();

        } else {
            mHandler.post(runnable);
        }
    }
}
