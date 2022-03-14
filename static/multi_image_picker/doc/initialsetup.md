# Initial setup

## iOS
You need to add those strings to your Info.plist file in order the plugin to work:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Example usage description</string>
<key>NSCameraUsageDescription</key>
<string>Example usage description</string>
```

>**Important** The plugin is written in Swift, so your project needs to have Swift support enabled. If you've created the project using `flutter create -i swift [projectName]` you are all set. If not, you can enable Swift support by opening the project with XCode, then choose `File -> New -> File -> Swift File`. XCode will ask you if you wish to create Bridging Header, click yes.

The plugin supports Swift Version 5.0. Make sure you have this version set in your `Build Settings -> SWIFT_VERSION`

Also you need to add `platform :ios, '9.0'` on top of your `ios/Podfile` .

## Android

You need to request those permissions in AndroidManifest.xml in order the plugin to work:

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.CAMERA" />
```

For example code usage, please see [here](https://github.com/Sh1d0w/multi_image_picker/blob/master/example/lib/main.dart)
