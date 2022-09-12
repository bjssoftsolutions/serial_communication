/*
 * SerialCommunicationPlugin.java
 * Created by: Mahad Asghar on 18/08/2022.
 *
 *  Copyright © 2022 BjsSoftSolution. All rights reserved.
 */


package com.example.serial_communication;

import android.content.Context;
import androidx.annotation.NonNull;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** SerialCommunicationPlugin */
public class SerialCommunicationPlugin implements FlutterPlugin, MethodCallHandler {

  private MethodChannel methodChannel;
  private EventChannel eventChannel;
  OpenCommunication communication = new OpenCommunication();
  private CustomEventHandler receiver;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    setupChannels(flutterPluginBinding.getBinaryMessenger(), flutterPluginBinding.getApplicationContext());
    methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "embedded_serial");
    methodChannel.setMethodCallHandler(this);

  }


  private void setupChannels(BinaryMessenger messenger, Context context) {
    eventChannel = new EventChannel(messenger, "log_tv");
    receiver = new CustomEventHandler();
    eventChannel.setStreamHandler(receiver);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    methodChannel.setMethodCallHandler(null);
    teardownChannels();
  }


  private void teardownChannels() {
    methodChannel.setMethodCallHandler(null);
    eventChannel.setStreamHandler(null);
    receiver.onCancel(null);
    eventChannel = null;
    receiver = null;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    Map<String, String> argments = ((Map<String, String>) call.arguments());
    switch (call.method) {
      case "embeddedSerial/availablePorts":
        final List<String> list = new ArrayList<String>();
        list.addAll(communication.sendDeviceData());
        result.success(list);
        break;
      case "embeddedSerial/open":
        communication.open(argments.get("serialPort"), Boolean.parseBoolean(argments.get("dataFormat")),Integer.parseInt(argments.get("baudRate")));
        break;
      case "embeddedSerial/close":
        communication.close();
        break;
      case "embeddedSerial/send":
        communication.send(argments.get("message"));
        break;
      case "embeddedSerial/clearLog":
        communication.logChannel = "";
        receiver.sendEvent(  Map.of("LogChannel", communication.logChannel, "readChannel", communication.readChannel));
        break;
      case "embeddedSerial/clearRead":
        communication.readChannel = "";
        receiver.sendEvent(  Map.of("LogChannel", communication.logChannel, "readChannel", communication.readChannel));
        break;
      case "embeddedSerial/destroy":
        communication.destroyResources();
        break;
      default:
        result.notImplemented();
    }
  }


}




