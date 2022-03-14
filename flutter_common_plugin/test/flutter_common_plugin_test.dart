import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_common_plugin/flutter_common_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_common_plugin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterCommonPlugin.platformVersion, '42');
  });
}
