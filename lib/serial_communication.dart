import 'dart:convert';

import 'serial_communication_platform_interface.dart';

///DataFormat for TX and RX
enum DataFormat { ASCII, HEX_STRING }

/// SerialCommunication handles the serial communication.
class SerialCommunication {
  Stream<SerialResponse> startSerial() {
    return SerialCommunicationPlatform.instance.startSerial();
  }

  /// [openPort] method to call the open api with the specified [dataFormat],[serialPort],[baudRate].
  /// The [dataFormat] used will be [ASCII], unless otherwise
  /// specified.
  ///
  /// The [serialPort] and [baudRate] arguments cannot be null.
  Future<String?> openPort(
      {DataFormat? dataFormat,
      required String serialPort,
      required int baudRate}) {
    return SerialCommunicationPlatform.instance.openPort(
        dataFormat: dataFormat ?? DataFormat.ASCII,
        serialPort: serialPort,
        baudRate: baudRate);
  }

  /// [getAvailablePorts] : Listing the available serial ports on the device,
  /// including USB to serial adapters
  Future<List<String>?> getAvailablePorts() {
    return SerialCommunicationPlatform.instance.getAvailablePorts();
  }

  /// [closePort] : close the opened port
  /// if you opened any port and want other available serial port
  /// call this closePort api to close the previous port
  Future<String?> closePort() {
    return SerialCommunicationPlatform.instance.closePort();
  }

  /// Creates a [sendCommand] with the specified [message].
  /// used as TX transmitter
  Future<String?> sendCommand({required String message}) {
    return SerialCommunicationPlatform.instance.sendCommand(message: message);
  }

  /// [clearLog] method will clear the Log channel
  Future<String?> clearLog() {
    return SerialCommunicationPlatform.instance.clearLog();
  }

  /// [clearRead] method will clear the Read channel
  Future<String?> clearRead() {
    return SerialCommunicationPlatform.instance.clearRead();
  }

  /// [destroy] method will clear resources and destroy
  /// the background threads
  Future<String?> destroy() {
    return SerialCommunicationPlatform.instance.destroyResources();
  }

  ///Standard baud rates list
  ///it will return the integer list of standard baud rate
  final List<int> baudRateList = [
    50,
    75,
    110,
    134,
    150,
    200,
    300,
    600,
    1200,
    1800,
    2400,
    4800,
    9600,
    14400,
    19200,
    38400,
    57600,
    115200,
    128000,
    230400,
    460800,
    500000,
    576000,
    921600,
    1000000,
    1152000,
    1500000,
    2000000,
    2500000,
    3000000,
    3500000,
    4000000
  ];
}

class SerialResponse {
  final String? logChannel;
  final String? readChannel;
  SerialResponse({
    this.logChannel,
    this.readChannel,
  });

  factory SerialResponse.fromMap(Map<String, dynamic> map) {
    return SerialResponse(
      logChannel: map['LogChannel'],
      readChannel: map['readChannel'],
    );
  }

  factory SerialResponse.fromJson(String source) =>
      SerialResponse.fromMap(json.decode(source));
}
