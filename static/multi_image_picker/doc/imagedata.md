# Accessing Image Data

The `Asset` class have several handy methods that allow you to access either
the original image data or a thumb data.

## Image Data

`async getByteData(quality: int)`

This method will return the original image data, with a given optional quality. The default
quality is 100.

```dart
ByteData byteData = await asset.getByteData();

// or

ByteData byteData = await asset.getByteData(quality: 80);
```

## Thumbnail Data

`async getThumbByteData(width: int, height: int, quality: int)`

This method will return the thumbnail image data, with a given width, height and optional quality.
The default quality is 100.

```dart
ByteData byteData = await asset.getThumbByteData(300, 300);

// or

ByteData byteData = await asset.getThumbByteData(300, 300, quality: 60);
```
