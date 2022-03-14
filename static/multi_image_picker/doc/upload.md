# Uploading Images

## Server / API

You can get the original image ByteData and pass it to the http request like this:

```dart
// string to uri
Uri uri = Uri.parse('$_apiEndpoint/some/path');

// create multipart request
MultipartRequest request = http.MultipartRequest("POST", uri);

ByteData byteData = await asset.getByteData();
List<int> imageData = byteData.buffer.asUint8List();

MultipartFile multipartFile = MultipartFile.fromBytes(
  'photo',
  imageData,
  filename: 'some-file-name.jpg',
  contentType: MediaType("image", "jpg"),
);

// add file to multipart
request.files.add(multipartFile);
// send
var response = await request.send();
```

## Firebase

You can pass the image data directly, like this:

```dart
Future saveImage(Asset asset) async {
  ByteData byteData = await asset.getByteData(); // requestOriginal is being deprecated
  List<int> imageData = byteData.buffer.asUint8List();
  StorageReference ref = FirebaseStorage().ref().child("some_image_bame.jpg"); // To be aligned with the latest firebase API(4.0)
  StorageUploadTask uploadTask = ref.putData(imageData);

  return await (await uploadTask.onComplete).ref.getDownloadURL();
}
```
