

[![Pub](https://img.shields.io/pub/v/serial_communication)]
# Serial communication!
An Android Plugin for Serial Communication
This Plugin wants to provide a simple API to connect, read and write data through theses serial ports.
The supported features are:
 * Listing the available serial ports on the device, including USB to serial adapters
 * Configuring serial ports (baud rate, stop bits, permission, ...) 
 * Providing standard InputStream and OutputStream 
# Description
This Plug In enables the communication with the
**USB**
**RS232**
**RS485**
**UART**
 The plugin detect the available serial ports on your device and allow you to commuincate.

**Supported platforms:**
  * Android
       
## Video tutorial
In order to completely understand you can view our sample video in which we are using an android Lcm module having
Click the image below to watch the video:

[![IMAGE ALT TEXT](https://i.postimg.cc/T1YCPsSH/Screenshot-2022-09-12-at-11-16-36-AM.png)](https://www.youtube.com/watch?v=bee2AHQpeGK4 "Click to open")
## Getting Started
Add a dependency to your pubspec.yaml
~~~
dependencies:
	serial_communication: version
~~~
include the usbserial package at the top of your dart file.
~~~
import ‘package:serial_communication/serial_communication.dart’
~~~

## 🔧 Android Setup #

## ❓ Usage  
If you encounter any issues please refer to the API docs and the sample code in the  `example`  directory before opening a request on Github.

### Example app[](https://pub.dev/packages/flutter_local_notifications#example-app)

The  [`example`](https://github.com/mahad555/serialCommunication/blob/main/example/lib/main.dart)  directory has a sample application that demonstrates the features of this plugin.
***

**Initialisation**
The first step is call the startSerial() method and subscribe the
 StreamSubscription 

## **Start Serial**

startSerial method  will open the transaction stream
~~~
  @override
  void initState() {
    super.initState();
   _serialCommunication.startSerial().listen(_updateConnectionStatus);
    getSerialList();
  }
  
 void  _updateConnectionStatus(SerialResponse? result) async {
logData = result!.logChannel ?? "";
receivedData = result.readChannel ?? "";
});
}
~~~
By calling the startSerial() it will provide you the SerialResponse in the form of stream data

**SerialResponse**
     In Serial Response you will get the following type
      1)  Log Channel (type:String)
      2)  Read Channel  (type:String)

Log Channel:
In the log channel you wll get the repsone when you open any port 
,close any port , transmit data (TX).

Read Channel:
In the Read channel you wll get the Recived data (RX)

## **Available Devices**

 The getAvailablePorts() method  will return you all the available device
~~~
serialList = await  serialCommunication.getAvailablePorts();
~~~

## **Open**

 openPort method  will open the serial communication
Its has 3 required parameter 
 { **DataFormat** dataFormat, **String** serialPort, **int** baudRate }
~~~
serialCommunication.openPort(
dataFormat: DataFormat.ASCII,
serialPort: serialList.first,
baudRate: serialCommunication.baudRateList.first)
~~~

## **Close**

closePort method  will close the port if you have opened any port
~~~
serialCommunication.closePort();
~~~

## **Send Command**
sendCommand method  will send your message 
Its has 1 required parameter  {**String**  message}
~~~
serialCommunication.sendCommand(message: "message");
~~~


## Clear

**clearLog** method  will clear the Log channel
**clearRead** method  will clear the Read channel

~~~
serialCommunication.clearLog();
serialCommunication.clearRead();
~~~

## Destroy
**destroy** method  will destroy the resources
~~~
@override
void  dispose() {
serialCommunication.destroy();
super.dispose();
}
~~~

* * *
*  **Baud Rate**
   To get the Standard baud rates list
   call the `SerialCommunication().baudRateList`
   it will return the integer list of standard baud rate
   
*  **Data Format**
The Data format is used to convert the data type
To pass the data format in the open()  method parameter
   For ascii format
   call the `DataFormat.ASCII`
   
   For hex_String format
   call the `DataFormat.HEX_STRING`

# Contribution

Any help from the open-source community is always welcome and needed:

-   Found an issue?
    -   Please fill a bug report with details.
-   Wish a feature?
    -   Open a feature request with use cases.
-   Are you using and liking the project?
    -   Promote the project: create an article, do a post or make a donation.
-   Are you a developer?
    -   Fix a bug and send a pull request.
    -   Implement a new feature.
    -   Improve the Unit Tests.
-   Have you already helped in any way?
    -   **Many thanks from me, the contributors and everybody that uses this project!**

    ## Maintainers 

-   [Mahad Asghar](https://github.com/felangel)
     







