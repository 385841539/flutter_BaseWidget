package com.ruedy.flutter_base_lib;


import io.flutter.app.FlutterApplication;

public class JKApplication extends FlutterApplication {

    private static JKApplication jkApplication;

    @Override
    public void onCreate() {
        super.onCreate();
        jkApplication = this;
        DartChannelUtil.init(this);

    }
    
    public  static JKApplication getApplication(){
        return  jkApplication;
    }
}
