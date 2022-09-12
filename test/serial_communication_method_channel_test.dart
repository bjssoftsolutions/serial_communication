import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serial_communication/serial_communication_method_channel.dart';

void main() {
  MethodChannelSerialCommunication platform =
      MethodChannelSerialCommunication();
  const MethodChannel channel = MethodChannel('serial_communication');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getAvailablePorts', () async {
    expect(await platform.getAvailablePorts(), '42');
  });
}
