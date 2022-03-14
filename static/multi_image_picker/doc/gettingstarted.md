# Getting Started

?> In order to start using multi_image_picker you must have the [Dart SDK](https://www.dartlang.org/install) installed on your machine.

## Installation

The first thing we need to do is add the multi_image_picker package to our `pubspec.yaml` as a dependency.

!> This plugin was migrated from using the deprecated Android Support Library to [AndroidX](https://developer.android.com/jetpack/androidx/). If your project was migrated to use it as well you should install version 4.X.X of the plugin. If you are using the old project structure please use version 2.4.11

```yaml
dependencies:
  multi_image_picker: ^4.6.5
```

Next we need to install the plugin.

!> Make sure to run the following command from the same directory as your `pubspec.yaml` file.

- Run `flutter packages get`

## Import

Now that we have successfully installed multi_image_picker, we can create our `main.dart` and import multi_image_picker.

```dart
import 'package:multi_image_picker/multi_image_picker.dart';
```
