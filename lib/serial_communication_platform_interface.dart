import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:serial_communication/serial_communication.dart';
import 'serial_communication_method_channel.dart';

abstract class SerialCommunicationPlatform extends PlatformInterface {
  /// Constructs a SerialCommunicationPlatform.
  SerialCommunicationPlatform() : super(token: _token);

  static final Object _token = Object();

  static SerialCommunicationPlatform _instance =
      MethodChannelSerialCommunication();

  /// The default instance of [SerialCommunicationPlatform] to use.
  ///
  /// Defaults to [MethodChannelSerialCommunication].
  static SerialCommunicationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SerialCommunicationPlatform] when
  /// they register themselves.
  static set instance(SerialCommunicationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Thrown by operations that have not been implemented yet.
  /// a [UnsupportedError] all things considered. This mistake is just planned for
  /// use during improvement.
  Stream<SerialResponse> startSerial() {
    throw UnimplementedError('startSerial() has not been implemented.');
  }

  /// Thrown by operations that have not been implemented yet.
  /// a [UnsupportedError] all things considered. This mistake is just planned for
  /// use during improvement.
  Future<String?> openPort(
      {required DataFormat dataFormat,
      required String serialPort,
      required int baudRate}) {
    throw UnimplementedError('openSerial() has not been implemented.');
  }

  /// Thrown by operations that have not been implemented yet.
  /// a [UnsupportedError] all things considered. This mistake is just planned for
  /// use during improvement.
  Future<List<String>?> getAvailablePorts() {
    throw UnimplementedError('getAvailablePorts() has not been implemented.');
  }

  /// Thrown by operations that have not been implemented yet.
  /// a [UnsupportedError] all things considered. This mistake is just planned for
  /// use during improvement.
  Future<String?> closePort() {
    throw UnimplementedError('closeSerial() has not been implemented.');
  }

  /// Thrown by operations that have not been implemented yet.
  /// a [UnsupportedError] all things considered. This mistake is just planned for
  /// use during improvement.
  Future<String?> sendCommand({required String message}) {
    throw UnimplementedError('sendCommand() has not been implemented.');
  }

  /// Thrown by operations that have not been implemented yet.
  /// a [UnsupportedError] all things considered. This mistake is just planned for
  /// use during improvement.

  Future<String?> clearLog() {
    throw UnimplementedError('clearLog() has not been implemented.');
  }

  /// Thrown by operations that have not been implemented yet.
  /// a [UnsupportedError] all things considered. This mistake is just planned for
  /// use during improvement.
  Future<String?> clearRead() {
    throw UnimplementedError('clearRead() has not been implemented.');
  }

  /// Thrown by operations that have not been implemented yet.
  /// a [UnsupportedError] all things considered. This mistake is just planned for
  /// use during improvement.
  Future<String?> destroyResources() {
    throw UnimplementedError('destroyResources() has not been implemented.');
  }
}
