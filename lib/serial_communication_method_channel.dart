import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:serial_communication/serial_communication.dart';

import 'serial_communication_platform_interface.dart';

/// An implementation of [SerialCommunicationPlatform] that uses method channels.
class MethodChannelSerialCommunication extends SerialCommunicationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('embedded_serial');

  ///EventChannel for opening the inputStream and OutputStream
  final eventChannel = const EventChannel("log_tv");

  ///Once this method is called, Operations like [openPort],[closePort] etc...
  ///result will be return from this stream
  ///Providing  InputStream and OutputStream
  ///[startSerial] : return type [SerialResponse]
  @override
  Stream<SerialResponse> startSerial() {
    Stream<SerialResponse> data = eventChannel.receiveBroadcastStream().map(
        (dynamic result) =>
            SerialResponse.fromMap(Map<String, String>.from(result)));

    return data;
  }

  ///Call the delegate availablePorts method to  provide available
  /// serial ports on the device
  ///[getAvailablePorts] : return type [List] of [String]
  @override
  Future<List<String>?> getAvailablePorts() async {
    List<String>? list = await methodChannel
        .invokeListMethod<String>('embeddedSerial/availablePorts');
    return list;
  }

  ///Call the delegate openPort native method to  start the communication
  /// with available port on the device
  /// the native method have three required arguments:
  /// 1) Format of the data
  /// 2) Name of port which you get from the [getAvailablePorts] method
  /// 3) And baud Rate
  /// Once the the port is opened the TX and RX is started
  @override
  Future<String?> openPort(
      {required DataFormat dataFormat,
      required String serialPort,
      required int baudRate}) async {
    final argument = {
      "dataFormat": dataFormat == DataFormat.ASCII ? "true" : "false",
      "serialPort": serialPort,
      "baudRate": baudRate.toString(),
    };
    final version = await methodChannel.invokeMethod<String>(
        'embeddedSerial/open', argument);
    return version;
  }

  ///close the opened port which you have opened from [openPort] this method
  ///At a time you can't opened two ports
  ///Close the previous to open the new
  @override
  Future<String?> closePort() async {
    final version =
        await methodChannel.invokeMethod<String>('embeddedSerial/close');
    return version;
  }

  /// [sendCommand] call the native method to write the transmit data
  /// the argument [message] will be transmit
  @override
  Future<String?> sendCommand({required String message}) async {
    final argument = {
      "message": message,
    };
    final version = await methodChannel.invokeMethod<String>(
        'embeddedSerial/send', argument);
    return version;
  }

  /// [clearLog] will clear the log message
  /// it will empty the previous operation log
  @override
  Future<String?> clearLog() async {
    final version =
        await methodChannel.invokeMethod<String>('embeddedSerial/clearLog');
    return version;
  }

  /// [clearRead] will clear the read message
  /// all the previous RX data will be clear when you call this method
  @override
  Future<String?> clearRead() async {
    final version =
        await methodChannel.invokeMethod<String>('embeddedSerial/clearRead');
    return version;
  }

  /// [destroyResources] will destroy the resources
  /// and clear all the background  threads from the memory.
  @override
  Future<String?> destroyResources() async {
    final version =
        await methodChannel.invokeMethod<String>('embeddedSerial/destroy');
    return version;
  }
}
