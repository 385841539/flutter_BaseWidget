package com.ruedy.flutter_base_lib;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.util.Log;


import com.ruedy.flutter_common_plugin.FBCallBack;
import com.ruedy.flutter_common_plugin.FBPluginCallback;
import com.ruedy.flutter_common_plugin.FlutterCommonPlugin;

public class DartChannelUtil {
    private static final String TAG = "DartChannelUtil";

    public static void init(Application application) {

        FlutterCommonPlugin.setFbPluginCallback(new FBPluginCallback() {
            @Override
            public void onMethodCall(Context context, String path, String params, FBCallBack callBack) {


                switch (path) {
                    case "native://open_test1_activity":
                        ((Activity) context).startActivity(new Intent(context, TestActivity.class));
                        break;

                    case "native://test_model":

                        android.util.Log.e("onMethodCall", "onMethodCall: " + path + "---" + params);

                        break;
                    default:
                        break;

                }

                Log.e(TAG, "onMethodCall:---  path:" + path + "---骗人爱马仕：" + params);


            }
        });
    }

}
