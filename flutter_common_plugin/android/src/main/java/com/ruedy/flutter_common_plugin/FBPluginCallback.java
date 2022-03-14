package com.ruedy.flutter_common_plugin;

import android.content.Context;

public interface FBPluginCallback {

    void onMethodCall(Context context, String path, String params, FBCallBack callBack);
}