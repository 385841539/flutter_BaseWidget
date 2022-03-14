import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('MultiImagePicker', () {
    const MethodChannel channel = MethodChannel('multi_image_picker');

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        if (methodCall.method == 'requestOriginal' ||
            methodCall.method == 'requestThumbnail') {
          return true;
        }
        return [
          {'identifier': 'SOME_ID_1'},
          {'identifier': 'SOME_ID_2'}
        ];
      });

      log.clear();
    });

    group('#pickImages', () {
      test('passes max images argument correctly', () async {
        await MultiImagePicker.pickImages(maxImages: 5);

        expect(
          log,
          <Matcher>[
            isMethodCall('pickImages', arguments: <String, dynamic>{
              'maxImages': 5,
              'enableCamera': false,
              'iosOptions': CupertinoOptions().toJson(),
              'androidOptions': MaterialOptions().toJson(),
              'selectedAssets': [],
            }),
          ],
        );
      });

      test('passes selected assets correctly', () async {
        Asset asset = Asset("test", "test.jpg", 100, 100);
        await MultiImagePicker.pickImages(
          maxImages: 5,
          selectedAssets: [asset],
        );

        expect(
          log,
          <Matcher>[
            isMethodCall('pickImages', arguments: <String, dynamic>{
              'maxImages': 5,
              'enableCamera': false,
              'iosOptions': CupertinoOptions().toJson(),
              'androidOptions': MaterialOptions().toJson(),
              'selectedAssets': [asset.identifier],
            }),
          ],
        );
      });

      test('passes cuppertino options argument correctly', () async {
        CupertinoOptions cupertinoOptions = CupertinoOptions(
          backgroundColor: '#ffde05',
          selectionCharacter: 'A',
          selectionFillColor: '#004ed5',
          selectionShadowColor: '#05e43d',
          selectionStrokeColor: '#0f5e4D',
          selectionTextColor: '#ffffff',
        );

        await MultiImagePicker.pickImages(
            maxImages: 5, cupertinoOptions: cupertinoOptions);

        expect(
          log,
          <Matcher>[
            isMethodCall('pickImages', arguments: <String, dynamic>{
              'maxImages': 5,
              'enableCamera': false,
              'iosOptions': cupertinoOptions.toJson(),
              'androidOptions': MaterialOptions().toJson(),
              'selectedAssets': [],
            }),
          ],
        );
      });

      test('passes meterial options argument correctly', () async {
        MaterialOptions materialOptions = MaterialOptions(
          actionBarTitle: "Aciton bar",
          allViewTitle: "All view title",
          actionBarColor: "#aaaaaa",
          actionBarTitleColor: "#bbbbbb",
          lightStatusBar: false,
          statusBarColor: '#abcdef',
          startInAllView: true,
          useDetailsView: true,
          selectCircleStrokeColor: "#ffffff",
        );
        await MultiImagePicker.pickImages(
            maxImages: 5, materialOptions: materialOptions);

        expect(
          log,
          <Matcher>[
            isMethodCall('pickImages', arguments: <String, dynamic>{
              'maxImages': 5,
              'enableCamera': false,
              'androidOptions': materialOptions.toJson(),
              'iosOptions': CupertinoOptions().toJson(),
              'selectedAssets': [],
            }),
          ],
        );
      });

      test('does not accept a negative images count', () {
        expect(
          MultiImagePicker.pickImages(maxImages: -10),
          throwsArgumentError,
        );
      });
    });

    test('requestOriginal accepts correct params', () async {
      const String id = 'SOME_ID';
      const int quality = 100;
      await MultiImagePicker.requestOriginal(id, quality);

      expect(
        log,
        <Matcher>[
          isMethodCall('requestOriginal', arguments: <String, dynamic>{
            'identifier': id,
            'quality': quality,
          }),
        ],
      );
    });

    group('#requestThumbnail', () {
      const String id = 'SOME_ID';
      const int width = 100;
      const int height = 200;
      const int quality = 100;
      test('accepts correct params', () async {
        await MultiImagePicker.requestThumbnail(id, width, height, quality);

        expect(
          log,
          <Matcher>[
            isMethodCall('requestThumbnail', arguments: <String, dynamic>{
              'identifier': id,
              'width': width,
              'height': height,
              'quality': quality,
            }),
          ],
        );
      });

      test('does not accept a negative width or height', () {
        expect(
          MultiImagePicker.requestThumbnail(id, -100, height, quality),
          throwsArgumentError,
        );

        expect(
          MultiImagePicker.requestThumbnail(id, width, -100, quality),
          throwsArgumentError,
        );
      });
      test('does not accept invalid quality', () {
        expect(
          MultiImagePicker.requestThumbnail(id, -width, height, -100),
          throwsArgumentError,
        );

        expect(
          MultiImagePicker.requestThumbnail(id, width, height, 200),
          throwsArgumentError,
        );
      });
    });
  });
}
