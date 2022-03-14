## Crash when selecting more than maxImages

This is a known bug with Matisse library, until it is fixed there you can fix it for you by adding the strings tranlastions as described [here](https://sh1d0w.github.io/multi_image_picker/#/theming?id=android-customization) .

## Android Support Version Mismatch

?> This error should no longer be present in version 3 of the plugin, as I've migrated it from the deprecated Android Support Library to AndroidX. If you are using multi_image_picker 3.* do not do this.

If you get errors like this:

!> Android dependency 'com.android.support:support-v4' has different version for the compile (X.X.X) and runtime (X.X.X) classpath.

This just means that your project uses several plugins that depend on different version of the support library. The suggested approach here is
to make all of them resolve to the same version, usually the highest one. To do so, in your `android/app/build.grade` go to `dependencies` and
add this:

```gradle
configurations.all {
  resolutionStrategy.eachDependency { DependencyResolveDetails details ->
    if (details.requested.group == 'com.android.support') {
      details.useVersion "27.1.1"
    }
  }
}
```

?> Don't forget to replace 27.1.1 with the highest version that the error you are getting is suggesting.

If you are getting error like this:

!> MultiImagePickerPlugin.java: 283 : error: cannot find symbol ExifInterface.TAG_ISO_SPEED

This also means you have version mismatch and should use the above solution, pinning the version to at least `27.1.1`

## Crash or no action when opening picker on Android API > 18

There have been bug reports about multi_image_picker crashing or failing to open the picker screen on Android versions above 18. See [here](https://github.com/Sh1d0w/multi_image_picker/issues/92) and [here](https://github.com/Sh1d0w/multi_image_picker/issues/93) for example. Check flutter log and look for a message like this:

!> Unhandled Exception: PlatformException(PERMISSION_PERMANENTLY_DENIED, Please enable access to the storage and the camera., null)

If it's there, chances are one of the flutter plugins in your app is setting an `android:maxSdkVersion="18"` attribute on one or all of the permissions in your AndroidManifest.xml. This prevents Android runtime from presenting a corresponding permission request to the user on all versions above 18 and instead reports that it's permanently denied. To fix this issue, you need to instruct Android manifest merger to remove this attribute from permission declarations. Add `tools:remove="android:maxSdkVersion"` to all permissions you declare as part of multi_image_picker's [initial setup](https://sh1d0w.github.io/multi_image_picker/#/initialsetup?id=android):

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" tools:remove="android:maxSdkVersion"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" tools:remove="android:maxSdkVersion"/>
<uses-permission android:name="android.permission.CAMERA" tools:remove="android:maxSdkVersion"/>
```
