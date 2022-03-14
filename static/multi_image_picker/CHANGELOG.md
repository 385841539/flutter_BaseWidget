# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/)
and this project adheres to [Semantic Versioning](https://semver.org/).

### Change (v4.7.15)

## 2021-02-09

- Bump glide version on Android

### Change (v4.7.14)

## 2020-09-16

- Revert a commit, causing a bug with mage selection on iOS

### Change (v4.7.13)

## 2020-09-09

- Fix picking live images on iOS will now pick the correct image

### Change (v4.7.12)

## 2020-08-22

- README and CHANGELOG fixes for pub.dev

### Change (v4.7.11)

## 2020-08-19

- Fix image picker regression on Android

### Change (v4.7.10)

## 2020-07-31

- Support activity in v1 embedding (https://github.com/Sh1d0w/multi_image_picker/pull/506)
- Fix on iOS can't present picker in some cases (https://github.com/Sh1d0w/multi_image_picker/pull/507)

### Change (v4.6.9)

## 2020-07-22

- Downgrade minimum Flutter version

### Change (v4.6.8)

## 2020-07-21

- Supporting the new Android plugins APIs

### Change (v4.6.7)

## 2020-04-30

- Revert fix resizing an image causes jagged lines on Android

### Change (v4.6.6)

## 2020-04-11

- Fix resizing an image causes jagged lines on Android

### Change (v4.6.5+rc.1)

## 2020-03-27

- Disable iOS 13 swipe to dismiss - to force user to press cancel or done.

### Change (v4.6.4)

## 2020-03-21

- Fix quality parameter on iOS that always was evaluated to 0

### Change (v4.6.4-rc.1)

## 2020-03-21

- Add support for Android minSdkVersion 16 and up & fixing incorrect rotation in Android 10 [#414](https://github.com/Sh1d0w/multi_image_picker/pull/414)

### Change (v4.6.3)

## 2020-03-07

- Revert Adding support for Android API Level 16 and up [#339](https://github.com/Sh1d0w/multi_image_picker/pull/399)

### Change (v4.6.2)

## 2020-03-05

- Adding support for Android API Level 16 and up [#339](https://github.com/Sh1d0w/multi_image_picker/pull/399)

### Change (v4.6.1)

## 2020-01-04

- Update FishBun version and remove permission handling from the library. FishBun and BSImagePicker handle permission requests by themselves

### Change (v4.6.0-rc.3)

## 2019-11-21

- Remove direct access to file URL, beacause of breaking change in iOS 13. Please use `getByteData` or `getThumbData` to obtain the images.

### Change (v4.6.0-rc.2)

## 2019-11-20

- Annotate controller type with UIViewController [#316](https://github.com/Sh1d0w/multi_image_picker/pull/316)

### Change (v4.6.0-rc.1)

## 2019-11-08

- BREAKING CHANGE: Compatibility for [breaking change in Flutter 1.10.15](https://groups.google.com/forum/#!topic/flutter-announce/lUKzLAd8OG8)

### Changed (v4.5.9)

## 2019-10-29

- Images that fail to download from iCloud on iOS will now throw `AssetFailedToDownloadException` exception if you try to access the path.

### Changed (v4.5.8)

## 2019-10-09

- `getByteData` and `getThumbByteData` now will return the current image with all adjustments on iOS [#277](https://github.com/Sh1d0w/multi_image_picker/issues/277)

### Changed (v4.5.7)

## 2019-10-06

- Add new option for both Android and iOS `autoCloseOnSelectionLimit`. It will close the image picker as soon as the selection limit is reached.

### Changed (v4.5.6)

## 2019-09-26

- Fix crash on iOS when optimize storage is enabled

### Changed (v4.5.5)

## 2019-09-16

- Update BSImagePicker version to 2.10.2

### Changed (v4.5.4)

## 2019-09-11

- Update BSImagePicker version to 2.10.1

### Changed (v4.5.3)

## 2019-09-03

- Update FishBun to version 0.11.1
- Fixed picking image using camera does not return FilePath [#226](https://github.com/Sh1d0w/multi_image_picker/issues/226)

### Changed (v4.5.2)

## 2019-08-19

- Trying to read images that does not exists will now throw AssetNotFoundException [#222](https://github.com/Sh1d0w/multi_image_picker/issues/222)

### Changed (v4.5.1)

## 2019-08-17

- Permission Denied error now will be correctly thrown on iOS if the user has disabled camera access.

### Changed (v4.5.0+2)

## 2019-08-13

- Don't pin meta package version

### Changed (v4.5.0+1)

## 2019-08-13

- Make thumb provider use non depracated plugin methods
- Temporarily pin meta package version to 1.1.7

### Changed (v4.5.0)

## 2019-08-12

- The plugin now returns file paths as well. To obtain the asset file path use `await asset.filePath`
- Removed `deleteImages` method. This plugin purpose is only to pick images.
- Deprecated `Asset.requestThumbnail` method. Use `Asset.getThumbByteData` instead.
- Deprecated `Asset.requestOriginal` method. Use `Asset.getByteData` instead.
- Deprecated `Asset.requestMetadata` method. Use `Asset.metadata` instead.

### Changed (v4.4.1)

## 2019-08-06

- Pin minimum Flutter version required to 1.7.8

### Changed (v4.4.0)

## 2019-08-06

- Added Material option `textOnNothingSelected` [#201](https://github.com/Sh1d0w/multi_image_picker/issues/201)
- Updated the code to use defaultBinaryMessenger instead of the deprecated BinaryMessenger
- `pickImages` now throws NoImagesSelectedException, PermissionDeniedException and PermissionPermanentlyDeniedExeption in addition to PlatformException. You can implement different logic for handling each case separately now.
- dateTime, dateTimeOriginal and dateTimeDigitized in the Metadata.exif object will now properly be returned as strings. The format is "YYYY:MM:DD HH:MM:SS" with time shown in 24-hour format as per Exif spec.
- Added the ability to change the icons for back and done buttons on Android. For more information see the [documentation](https://sh1d0w.github.io/multi_image_picker/#/theming) and the example app in this repository.

### Changed (v4.3.6)

## 2019-07-18

- Added new Android option useDetailsView to disable details view when clicking on the image and directly select it

### Changed (v4.3.5)

## 2019-07-07

- Update FishBun library to version 0.10.0

### Changed (v4.3.4)

## 2019-06-17

- Do not display GIF images on Android [#180](https://github.com/Sh1d0w/multi_image_picker/issues/180)

### Changed (v4.3.3)

## 2019-05-27

- Methods marked with @UiThread must be executed on the main thread. [#160](https://github.com/Sh1d0w/multi_image_picker/pull/160)

### Changed (v4.3.2)

## 2019-05-18

- Fix resolving gps metadata on Android [#153](https://github.com/Sh1d0w/multi_image_picker/pull/153)

### Changed (v4.3.1)

## 2019-05-13

- Updated FishBun to version 0.9.1

### Changed (v4.3.0)

## 2019-05-12

- Added new option `selectedAssets` which allows you to pre select Assets when opening the image picker

### Changed (v4.2.2)

## 2019-05-08

- Added option to customize the message when max selection limit is reached on Android

### Changed (v4.2.1)

## 2019-05-03

- Remove informationCollector from AssetThumbImageProvider to make the plugin work with latest master version of Flutter [info](https://github.com/flutter/flutter/issues/31962)

### Changed (v4.2.0)

## 2019-04-19

### iOS

- Updated BSImagePicker version to 2.10.0 and Switct version to 5.0

### Changed (v4.1.2)

## 2019-04-14

### Android

- Added an option to start Android picker in "All Photos" closes [#111](https://github.com/Sh1d0w/multi_image_picker/issues/111)
- Added selectCircleStrokeColor closes [#113](https://github.com/Sh1d0w/multi_image_picker/issues/113)

### Changed (v4.1.1)

## 2019-04-14

- Added `AssetThumb` widget, which simplified and handles displaying of thumb images.
- Added `AssetThumbProvider`

### BREAKING CHANGE

- Removed `Asset.thumbData` and `Asset.imageData` getters. They were obsolete as this data was returned from resolved future anyways, there is no point to keep them in the `Asset` object.
- Removed `Asset.releaseThumb`, `Asset.releaseOriginal` and `Asset.release` methods, as they are no longer needed.
- `Asset.requestThumbnail` and `Asset.requestOriginal` now return `Future<ByteData>` as previously returned `Future<dynamic>`

### Changed (v4.0.3)

## 2019-04-12

- Correctly return image name on photos taken with camera on Android

### Changed (v4.0.2)

## 2019-04-03

- Export MaterialOptions to make styling of Android possible.

### Changed (v4.0.1)

## 2019-03-28

- Fixed some deprecation warnings on Android

### Changed (v4.0.0)

## 2019-03-23

### Breaking change

- Replaced Mattise image picker with FishBun on Android. For migration guide see [here](https://sh1d0w.github.io/multi_image_picker/#/upgrading). [#95](https://github.com/Sh1d0w/multi_image_picker/pull/95)

### Changed (v3.0.23)

## 2019-03-12

- Fix Matisse version

### Changed (v3.0.22)

## 2019-03-02

- Send Thumb and Original image data via separate channels [#80](https://github.com/Sh1d0w/multi_image_picker/pull/80)

### Changed (v3.0.21)

## 2019-02-27

- Added ability to delete array of Assets from the filesystem [#79](https://github.com/Sh1d0w/multi_image_picker/pull/79)

### Changed (v3.0.14)

## 2019-02-17

- Fix failing build on Android

### Changed (v3.0.13)

## 2019-02-13

- Display only images in the picker on Android [#73](https://github.com/Sh1d0w/multi_image_picker/pull/73)

### Changed (v3.0.12)

## 2019-02-05

- Use custom fork of Matisse until it adds AndroidX support.

### Changed (v3.0.11)

## 2019-01-29

### BREAKING CHANGE

- Migrate from the deprecated original Android Support Library to AndroidX. This shouldn't result in any functional changes, but it requires any Android apps using this plugin to [also migrate](https://developer.android.com/jetpack/androidx/migrate) if they're using the original support library.

### Changed (v2.4.11)

## 2019-01-23

### BREAKING CHANGE

- Renamed Metadata properties to lowerCamelCase in order to resolve https://github.com/dart-lang/sdk/issues/35732

### Changed (v2.3.33)

## 2019-01-23

- Correctly handle LensSpecification and SubjectArea metadata

### Changed (v2.3.32)

## 2019-01-14

- Fix possible bug with permissions on Android

### Changed (v2.3.31)

## 2019-01-12

- Add original image name to the Asset class

### Changed (v2.3.29)

## 2019-01-07

- Fix bug with permissions on Android

### Changed (v2.3.28)

## 2018-12-29

- Remove static_library definition on iOS

### Changed (v2.3.27)

## 2018-12-24

- Fix memory leak on Android

### Changed (v2.3.26)

## 2018-12-21

- Bump Android and iOS versions

### Changed (v2.3.25)

## 2018-12-21

- Pub page preview fixes

### Changed (v2.3.23)

## 2018-12-21

- Removed deprecated meta data tag on Android

### Changed (v2.3.22)

## 2018-12-20

- Added `requestMetadata()` method to the Asset class

### Changed (v2.3.01)

## 2018-12-18

- Added `takePhotoIcon` option to ios customization settings

### Changed (v2.3.00)

## 2018-12-13

### BREAKING CHANGE

- Android - renamed authorities to `android:authorities="YOUR_PACKAGE_NAME_HERE.multiimagepicker.fileprovider"`. Please update your manifest file to avoid errors.

### Changed (v2.2.61)

## 2018-12-13

- Added custom file provider to avoid collisions with other plugins. See README for example implementation

### Changed (v2.2.55)

## 2018-11-19

### Fixed

- Define module_headers as per http://blog.cocoapods.org/CocoaPods-1.5.0/

### Changed (v2.2.54)

## 2018-11-19

### Fixed

- Add s.static_framework = true as per https://github.com/flutter/flutter/issues/14161

### Changed (v2.2.53)

## 2018-11-08

### Fixed

- Added new optional parameter `quality` to `requestThumb` and `requestOriginal` methods.

### Changed (v2.2.52)

## 2018-11-07

### Fixed

- Don't rescale the image when decoding it on Android

### Changed (v2.2.50)

## 2018-11-07

### Fixed

- Correctly handle image orientation on Android phones [ref](https://stackoverflow.com/questions/14066038/why-does-an-image-captured-using-camera-intent-gets-rotated-on-some-devices-on-a?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa)

### Changed (v2.2.47)

## 2018-11-06

### Changed

- Increase thumb quality on Android

### Changed (v2.2.45)

## 2018-11-06

### Fixed

- Ask for CAMERA permission on Android, and fix opening of the picker after permission grant.

### Changed (v2.2.44)

## 2018-11-06

### Fixed

- Use correct application id on Android devices when setting up the camera provider

### Changed (v2.2.43)

## 2018-11-02

### Fixed

- requestOriginal now works correctly on Android

### Changed (v2.2.42)

## 2018-11-02

### Fixed

- Use app specific content provider, updated README.md

### Changed (v2.2.41)

## 2018-11-02

### Changed

- Commented out example file provider as it gets included in production bundle. If you want to test the example just uncomment it in the android manifest.

### Changed (v2.2.40)

## 2018-11-02

### Added

- Added new picker option `enableCamera` which allows the user to take pictures directly from the gallery. For more info how to enable this please see README.md

### Changed (v2.2.30)

## 2018-10-28

### Fixed

- iOS 12 and Swift 4.2 language fixes
- Important: In your XCode build setting you must set Swift Version to 4.2

### Changed (v2.2.10)

## 2018-09-19

### Changed

- Update Image picker library to support Swift 4.2 and XCode 10
- Remove obsolette file path in the asset class

### Changed (v2.1.26)

## 2018-09-10

### Fixed

- Fixed path not passed to the Asset class [#7](https://github.com/Sh1d0w/multi_image_picker/pull/7)

### Changed (v2.1.25)

## 2018-09-07

### Added

- Add Real file path and allow to refresh image gallery [#6](https://github.com/Sh1d0w/multi_image_picker/pull/6) (thanks CircleCurve)

### Changed (v2.1.23)

## 2018-08-31

### Added

- Improved the docs

### Changed (v2.1.22)

## 2018-08-28

### Added

- Add originalWidth, originalHeight, isPortrait and isLandscape getters for the Asset class

### Changed (v2.1.21)

## 2018-08-24

### Added

- Add release(), releaseOriginal() and releaseThumb() methods to help clean up the image data when it is no longer needed

### Changed (v2.1.02)

## 2018-08-20

### Fix

- Fix null pointer exception on Android when finishing from another activity (thanks to xia-weiyang)

### Changed (v2.1.01)

## 2018-08-16

### Change

- Add getters to Asset class

### Changed (v2.1.00)

## 2018-08-16

### BREAKING CHANGE

- Asset's `requestThumbnail` and `requestOriginal` methods now will return Future<ByteData>. Removed the method callbacks.

### Changed (v2.0.04)

## 2018-08-16

### Fixed

- Correctly crop the thumb on iOS

### Changed (v2.0.03)

## 2018-08-16

### Added

- Allow network access to download images present only in iCloud

### Changed (v2.0.02)

## 2018-08-16

### Fixed

- Improve thumbs quality on iOS to always deliver best of it

### Changed (v2.0.01)

## 2018-08-16

### Fixed

- Fix picking original image on Android was not triggering properly the callback

### Changed (v2.0.0)

## 2018-08-15

### BREAKING CHANGE

- The plugin have been redesigned to be more responsive and flexible.
- pickImages method will no longer return List<File>, instead it will return List<Asset>
- You can then request asset thumbnails or the original image, which will load asyncrhoniously without blocking the main UI thred. For more info see the examples directory.

### Added

- `Asset` class, with methods `requestThumbnail(int width, int height, callback)` and `requestOriginal(callback)`

### Changed (v1.0.53)

## 2018-08-13

### Fixed

- Fix crash on iOS when picking a lot of images.

### Changed (v1.0.52)

## 2018-08-12

### Fixed

- Picking images on iOS now will properly handle PHAssets

### Changed (v1.0.51)

## 2018-08-07

### Changed

- Fix a crash on Android caused by closing and reopening the gallery

### Changed (v1.0.5)

## 2018-08-07

### Add

- Support iOS and Android customizations

### Changed (v1.0.4)

## 2018-08-06

### Changed

- iOS: Add missing super.init() call in the class constructor

### Changed (v1.0.3)

## 2018-08-05

### Changed

- Changed sdk: ">=2.0.0-dev.28.0 <3.0.0"

### Changed (v1.0.2)

## 2018-08-05

### Added

- Add Support for Dart 2 in pubspec.yaml file

### Changed (v1.0.1)

## 2018-08-05

### Added

- Initial release with basic support for iOS and Android
