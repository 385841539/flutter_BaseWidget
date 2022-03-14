# Upgrading

This page will list any changes that you have to make when there is a breaking or major version change.

## From version 4.1.1 to version 4.2.0

Updated BSImagePicker version, it now requires your project SWIFT_VERSION to be set to 5.0.

Open XCode -> Build Settings -> SWIFT_VERSION -> Set to 5.0.

## From version 4.0.0 to version 4.1.1

### BREAKING CHANGE
- Removed `Asset.thumbData` and `Asset.imageData` getters. They were obsolete as this data was returned from resolved future anyways, there is no point to keep them in the `Asset` object.
- Removed `Asset.releaseThumb`, `Asset.releaseOriginal` and `Asset.release` methods, as they are no longer needed.
- `Asset.requestThumbnail` and `Asset.requestOriginal` now return `Future<ByteData>` as previously returned `Future<dynamic>`


## From version 3.0.X to version 4.0.0

There is a breaking change on Android. The android image picker was changed from Matisse to FishBun.

The change was because Matisse was not very actively mantained and also requires a lot of effort to be customized via XML styles.

FishBun on other side is very actively mantained and also allows you to pass customization options via Dart code, just like on iOS.

The breaking changes are:

- Removed the `options` parameter from `pickImages` method. There are now two separate parameters that can be passed- `cupertinoOptions` and `materialOptions`. If you previously passed the `options` parameter to customize the iOS look and feel, you have to change that param name to `cupertinoOptions`.
- If you was overriding Mattise styles and localizations via XML, you can safely remove those now. Instead you can pass different customization options directly with `materialOptions` when invoking the image picker.
- No additional comfiguration needed anymore if you want to enable the camera in the gallery. Just pass the `enableCamera` parameter.
- Previously on Android when you take a photo with the camera in the gallery, the image picker was immediately closed, which is exactly the opposite on how it worked on iOS. With this new version both flows are consistent, meaning when you take a picture on Android you will go back to gallery and can select more images, including the one you've just taken.
- You no longer need file provider in your AndroidManifest.xml . You can remove it. Images taken with the camera will appear properly in the gallery now.

## From version 2.4.11 to version 3.0.X

The project has migrated from using the old Android Support Library to [AndroidX](https://developer.android.com/jetpack/androidx/). If you haven't migrated you project to AndroidX yet, please use version 2.4.11 of the plugin.

If you migrated your project to AddroidX you can use version 3 and above of the plugin.

For more information how to migrate your project see [official migration guide](https://developer.android.com/jetpack/androidx/migrate).

!> Before migrating to AndroidX make sure all plugins you use in your project are supporting AndroidX. Recently the Flutter team started to migrate all of their plugins, but you should check the rest of the third party plugins you are using.

## From version 2.3.* to 2.4.11

If you are using the `Metadata` class you have to rename all priperties that you are checking to lowerCamelCase e.g.

- Previously `metadata.exif.Artist`
- Now `metadata.exif.artist`
