# Image Metadata

To access the image meta data (ExIF, GPS, Device), you can invoke `requestMetadata()` method on the asset class:

```dart
Metadata metadata = await asset.requestMetadata();

print(metadata.gps.gpsDestLatitude);
print(metadata.exif.artist);
print(metadata.device.model);
```

For all available meta data properties, see the [Metadata](https://pub.dartlang.org/documentation/multi_image_picker/latest/metadata/Metadata-class.html) class.

!> On Android 10 and above in order to access the image GPS metadata you need to request permission for `ACCESS_MEDIA_LOCATION`. To do so you can put that permission in your AndroidManifest.xml file and use third party package to request that permission before opening the image picker.