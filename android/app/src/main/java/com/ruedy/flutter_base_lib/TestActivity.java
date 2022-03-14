package com.ruedy.flutter_base_lib;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import androidx.annotation.Nullable;

import com.ruedy.flutter_common_plugin.CallResult;
import com.ruedy.flutter_common_plugin.FlutterCommonPlugin;

public class TestActivity extends Activity {

    private static final String TAG = "TestActivity";
    int i = 0;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout_testactivity);
    }

    public void jumpFlutter(View view) {
        startActivity(new Intent(this, MainActivity.class));
        new Thread(

                new Runnable() {
                    @Override
                    public void run() {
                        try {
                            Thread.sleep(3000);
                            runOnUiThread(new Runnable() {
                                @Override
                                public void run() {

//                                    startActivity(new Intent(TestActivity.this, TestActivity.class));

                                }
                            });
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
                }

        ).start();
    }

    public void sendForFlutter(View view) {
        String pro = "nativeToDart://test/more_activity_listen";
        FlutterCommonPlugin.sendEvent(pro, "" + (i++), new CallResult() {
            @Override
            public void success(@Nullable Object result) {
                Log.e(TAG, "success: --- " + result);
            }

            @Override
            public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                Log.e(TAG, "errorCode_success: --- " + errorMessage);

            }
        });

    }
}
