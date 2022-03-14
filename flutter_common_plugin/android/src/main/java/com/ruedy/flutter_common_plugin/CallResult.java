package com.ruedy.flutter_common_plugin;

import android.util.Log;

import io.flutter.plugin.common.MethodChannel;

public abstract class CallResult implements MethodChannel.Result {


    @Override
    public void notImplemented() {

        if (BuildConfig.DEBUG) {
            Log.e("CallResult", "notImplemented: -- ");
        }
    }
}
