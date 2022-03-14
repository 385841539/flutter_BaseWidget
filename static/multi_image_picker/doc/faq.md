# FAQ

## How I can access the images the user has picked?

When you invoke the image picker and the user picks some images, as response you will get List of Asset objects. The Asset class have two handy methods which allows you to access the picked image data - `getThumbByteData(width, height)`, which returns a resized image and `getByteData()` which returns the original hight quality image. Those methods are asynchronous and return the image data as `ByteData`, so you must be careful when to allocate and release this data if you don't need it in different views. For example implementation see the example folder.

## Why the plugin don't return image paths directly?

That's not an easy task when we speak for cross platform compatibility. For example on Android the `ContentResolver` returns content URIs, which not always have a file path. On iOS it gets even more complicated since with iCloud not all of your photos are stored physically on the phone, and there is no way to return the file path immediately without first downloading the original image from iCloud to the phone. Also recent versions of iOS starting form iOS 13 return temporary paths and you have several seconds to do something with that path and after that it will expire.

You can see how one of the core Flutter plugins - the single [image_picker](https://pub.dartlang.org/packages/image_picker), approaches and solves this problem in order to return file paths: it just copies the selected image content to the `tmp` folder and returns the file path from there. Now that works ok when you pick a single image.

But since with the `multi_image_picker` you can pick literally thousands of images on one go, this is not possible.

Another issue on iOS is that starting from iOS 11 all images taken by the camera are stored in [HEIC](https://en.wikipedia.org/wiki/High_Efficiency_Image_File_Format) format. Unfortunately, Flutter still doesn't have codecs to display HEIC images out-of-the-box in with the image widget.

The aim of this plugin is to be fast and efficient, currently you can pick thousands of images in milliseconds, and still have access to the selected images data whenever you need them. The plugin takes care of both Android and iOS platform specific cases and issues, and will reliably return the scaled thumb when you invoke `getThumbByteData` or the original image data when you invoke `getByteData`. You are then free to use this data as you like - display it in image widget or submit the data to a remote API.

If you need file paths after all, you can simply obtain the byte data from the image and save it as a file in the app temporary directory, giving you full control over the file. Bear in mind you are then resposible for clearing the tmp directory once the images are no longer needed.