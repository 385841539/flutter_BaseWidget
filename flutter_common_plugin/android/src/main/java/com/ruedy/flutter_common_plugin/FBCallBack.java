package com.ruedy.flutter_common_plugin;

import androidx.annotation.Nullable;

public interface FBCallBack<T> {

    void success(T result);

    void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails);

    void notImplemented();
}
