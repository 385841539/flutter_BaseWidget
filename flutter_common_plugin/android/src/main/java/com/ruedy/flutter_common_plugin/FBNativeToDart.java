package com.ruedy.flutter_common_plugin;

public class FBNativeToDart {
    public static void sendEvent(String name, Object args) {
        sendEvent(name, args, null);
    }

    public static void sendEvent(String name, Object args, CallResult callback) {
        FlutterCommonPlugin.sendEvent(name, args, callback);

    }
}
