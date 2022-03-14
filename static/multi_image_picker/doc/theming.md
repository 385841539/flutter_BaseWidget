## Android customization

You can customize different parts of the gallery picker. To do so, you can simply pass `materialOptions` param in the `pickImages` call.

```dart
List resultList = await MultiImagePicker.pickImages(
    maxImages: 3,
    materialOptions: MaterialOptions(
        actionBarTitle: "Action bar",
        allViewTitle: "All view title",
        actionBarColor: "#aaaaaa",
        actionBarTitleColor: "#bbbbbb",
        lightStatusBar: false,
        statusBarColor: '#abcdef',
        startInAllView: true,
        selectCircleStrokeColor: "#000000",
        selectionLimitReachedText: "You can't select any more.",
    ),
  );
```

Available options are:
 - actionBarTitle - string
 - allViewTitle - string
 - actionBarColor - HEX string
 - actionBarTitleColor - HEX string
 - actionBarTitleColor - HEX string
 - lightStatusBar - boolean
 - statusBarColor - HEX string
 - startInAllView - boolean
 - useDetailsView - boolean
 - selectCircleStrokeColor - HEX string
 - selectionLimitReachedText - string
 - textOnNothingSelected - string
 - backButtonDrawable - string
 - okButtonDrawable - string
 - autoCloseOnSelectionLimit - automatically close the image picker when selection limit is reached

!> backButtonDrawable and okButtonDrawable must exists as drawable resources under your `android/app/src/res/drawable` folder.

## iOS customization

You can customize different parts of the gallery picker. To do so, you can simply pass `iosOptions` param in the `pickImages` call.

?> The iOS plugin uses System Localizations, meaning it will automatically detect the device language and provide appropriate translations. You don't have to handle that manually like on Android.

```dart
List resultList = await MultiImagePicker.pickImages(
    maxImages: 3,
    cupertinoOptions: CupertinoOptions(
      selectionFillColor: "#ff11ab",
      selectionTextColor: "#ffffff",
      selectionCharacter: "✓",
    ),
  );
```

Available options are:
 - backgroundColor - HEX string
 - selectionFillColor - HEX string
 - selectionShadowColor - HEX string
 - selectionStrokeColor - HEX string
 - selectionTextColor - HEX string
 - selectionCharacter - Unicode character
 - takePhotoIcon - Name of the icon, as defined in your Assets
 - autoCloseOnSelectionLimit - automatically close the image picker when selection limit is reached

> **Note**: To add an icon to your XCode Assets, follow these steps:
> >
> Step 1: Select the asset catalog
>In your project root in XCode click Runner -> Assets.xcassets in the project navigator to bring up the Asset Catalog for the project.
>
>Step 2: Add Image Set
>
>To add an image to the project, create a new image set. Drag the png asset (jpeg won't work) from the Finder to the 1X or 2X slot. In a production app, you should include both the standard (1X) as well as retina (2X) asset. During development, you can add only one asset and XCode will automatically create the other one, although it may look blurry. The name of the Image Set must match what you pass as an option to the plugin.
