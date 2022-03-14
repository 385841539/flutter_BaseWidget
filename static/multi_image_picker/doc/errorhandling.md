# Error Handling

When you invoke the image picker you can listen for different exeptions.

Currently the plugin throws one of the following exceptions:

- NoImagesSelectedException (when cancel button is pressed)
- PermissionDeniedException (when user has denied image permission)
- PermissionPermanentlyDeniedExeption  (when user has denied image permission permanently)
- PlatformException (generic exeption of something goes relly wrong)

You can handle any of those like this:

```dart
    import 'package:multi_image_picker/multi_image_picker.dart';

    ....

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } on NoImagesSelectedException catch (e) {
      // User pressed cancel, update ui or show alert
    } on Exception catch (e) {
      // Do something
    }
```