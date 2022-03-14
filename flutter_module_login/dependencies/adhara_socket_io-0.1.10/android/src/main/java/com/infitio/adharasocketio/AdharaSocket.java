package com.infitio.adharasocketio;

import android.util.Log;
import android.os.Handler;
import android.os.Looper;

import org.json.JSONArray;
import org.json.JSONObject;

import com.google.gson.Gson;

import java.lang.reflect.Array;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.socket.client.Ack;
import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;


class AdharaSocket implements MethodCallHandler {

    final Socket socket;
    private final MethodChannel channel;
    private static final String TAG = "Adhara:Socket";
    private Options options;

    private void log(String message){
        if(this.options.enableLogging){
            Log.d(TAG, message);
        }
    }

    private AdharaSocket(MethodChannel channel, Options options) throws URISyntaxException {
        this.channel = channel;
        this.options = options;
        log("Connecting to... "+options.uri);
        socket = IO.socket(options.uri, this.options);
    }

    static AdharaSocket getInstance(Registrar registrar, Options options) throws URISyntaxException{
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "adhara_socket_io:socket:"+String.valueOf(options.index));
        AdharaSocket _socket = new AdharaSocket(channel, options);
        channel.setMethodCallHandler(_socket);
        return _socket;
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        switch (call.method) {
            case "connect": {
                log("Connecting....");
                socket.connect();
                result.success(null);
                break;
            }
            case "on": {
                final String eventName = call.argument("eventName");
                log("registering::"+eventName);
                socket.on(eventName, new Emitter.Listener() {

                    @Override
                    public void call(Object... args) {
                        log("Socket triggered::"+eventName);
                        final Map<String, Object> arguments = new HashMap<>();
                        arguments.put("eventName", eventName);
                        List<String> argsList = new ArrayList<>();

                        Ack ack = null;

                        for(Object arg : args){
                            if((arg instanceof JSONObject)
                                    || (arg instanceof JSONArray)){
                                argsList.add(arg.toString());
                            }
                            else if (arg instanceof Ack) {
                                ack = (Ack) arg;
                            }
                            else if(arg!=null){
                                argsList.add(arg.toString());
                            }
                        }

                        arguments.put("args", argsList);

                        final Ack finalAck = ack;

                        final Handler handler = new Handler(Looper.getMainLooper());
                        handler.post(new Runnable() {
                            @Override
                            public void run() {
                                channel.invokeMethod("incoming", arguments);

                                if (finalAck != null) {
                                    finalAck.call();
                                }
                            }
                        });
                    }

                });
                result.success(null);
                break;
            }
            case "off": {
                final String eventName = call.argument("eventName");
                log("un-registering:::"+eventName);
                socket.off(eventName);
                result.success(null);
                break;
            }
            case "emit": {
                final String eventName = call.argument("eventName");
                final List data = call.argument("arguments");
                log("emitting:::"+data+":::to:::"+eventName);
                Object[] array = {};
                if(data!=null){
                    array = new Object[data.size()];
                    for(int i=0; i<data.size(); i++){
                        Object datum = data.get(i);
                        System.out.println(datum);
                        System.out.println(datum.getClass());
                        if(datum instanceof Map){
                            array[i] = new JSONObject((Map)datum);
                        }else if(datum instanceof Collection){
                            array[i] = new JSONArray((Collection) datum);
                        }else{
                            array[i] = datum;
                            /*try{
                                array[i] = new JSONObject(datum.toString());
                            }catch (JSONException jse){
                                try{
                                    array[i] = new JSONArray(datum.toString());
                                }catch (JSONException jse2){
                                    array[i] = datum;
                                }
                            }*/
                        }
                    }
                }

                final Boolean ack = call.argument("ack");
                if (ack) {
                    final Integer ackTimeout = call.argument("ackTimeout");

                    final Timer timer = new Timer();
                    timer.schedule(new TimerTask() {
                        @Override
                        public void run() {
                            final List<String> list = new ArrayList<>();
                            list.add("NO ACK");

                            final Handler handler = new Handler(Looper.getMainLooper());
                            handler.post(new Runnable() {
                                @Override
                                public void run() {
                                    result.success(list);
                                }
                            });
                        }
                    }, ackTimeout * 1000);

                    socket.emit(eventName, array, new Ack() {
                        @Override
                        public void call(Object... args) {
                            timer.cancel();

                            List<Object> argsList = new ArrayList<>();
                            for(Object arg : args){
                                if (arg instanceof JSONObject) {
                                    JSONObject jsonObject = (JSONObject) arg;
                                    HashMap map = new Gson().fromJson(jsonObject.toString(), HashMap.class);
                                    argsList.add(map);
                                }
                                else if(arg instanceof JSONArray){
                                    JSONArray jsonArray = (JSONArray) arg;
                                    ArrayList array = new Gson().fromJson(jsonArray.toString(), ArrayList.class);
                                    argsList.add(array);
                                }else if(arg!=null){
                                    argsList.add(arg.toString());
                                }
                            }

                            final List<Object> finalArgsList = argsList;

                            final Handler handler = new Handler(Looper.getMainLooper());
                            handler.post(new Runnable() {
                                @Override
                                public void run() {
                                    result.success(finalArgsList);
                                }
                            });

                        }
                    });
                }
                else {
                    socket.emit(eventName, array);
                    result.success(null);
                }
                break;
            }
            case "isConnected": {
                log("connected:::");
                result.success(socket.connected());
                break;
            }
            case "disconnect": {
                log("disconnected:::");
                socket.disconnect();
                result.success(null);
                break;
            }
            default: {
                result.notImplemented();
            }
        }
    }

    public static class Options extends IO.Options {

        String uri;
        int index;
        public Boolean enableLogging = false;

        Options(int index, String uri){
            this.index = index;
            this.uri = uri;
        }

    }

}
