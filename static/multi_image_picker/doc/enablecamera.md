# Enable Camera

To allow users to take pictures with the camera, while they are browsing the gallery, you can enable the camera by just passing the `enableCamera` parameter like this:

```dart
  resultList = await MultiImagePicker.pickImages(
    maxImages: 300,
    enableCamera: true,
  );
```
