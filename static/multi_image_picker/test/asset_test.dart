import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Asset', () {
    const MethodChannel channel = MethodChannel('multi_image_picker');

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return true;
      });

      log.clear();
    });

    test('constructor set the identifier correctly', () {
      const String id = 'SOME_ID';
      Asset asset = Asset(id, 'some name', 100, 100);
      expect(
        asset.identifier,
        equals(id),
      );
    });

    test('constructor set the name correctly', () {
      const String name = 'Some Name';
      Asset asset = Asset('1', name, 100, 100);
      expect(
        asset.name,
        equals(name),
      );
    });

    test('thumbData can not have negative dimensions', () async {
      Asset asset = Asset('_identifier', 'some name', 50, 50);

      expect(
        asset.requestThumbnail(-100, 10),
        throwsArgumentError,
      );

      expect(
        asset.requestThumbnail(10, -100),
        throwsArgumentError,
      );
    });

    test('asset has correct dimensions', () async {
      Asset asset = Asset('_identifier', 'some name', 50, 40);

      expect(
        asset.originalWidth,
        equals(50),
      );

      expect(
        asset.originalHeight,
        equals(40),
      );
    });

    test('asset isLandscape and isPortrait work', () async {
      Asset asset1 = Asset('_identifier', 'some name', 50, 40);
      Asset asset2 = Asset('_identifier', 'some name', 40, 50);

      expect(
        asset1.isLandscape,
        equals(true),
      );

      expect(
        asset1.isPortrait,
        equals(false),
      );

      expect(
        asset2.isLandscape,
        equals(false),
      );

      expect(
        asset2.isPortrait,
        equals(true),
      );
    });
  });
}
