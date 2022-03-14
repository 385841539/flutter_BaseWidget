package com.ruedy.flutter_common_plugin.activity;

import android.app.Activity;
import android.os.Bundle;

import androidx.annotation.Nullable;

import com.ruedy.flutter_common_plugin.R;

public class CommonSchemeActivity extends Activity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_scheme);
    }
}
