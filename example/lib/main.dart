import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:serial_communication/serial_communication.dart';

void main() {
  DartPluginRegistrant.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Serial Communication',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String logData = "";
  String receivedData = "";
  String selectedPort = "Select Port";
  int selectedBaudRate = SerialCommunication().baudRateList.first;
  List<String>? serialList = [];
  DataFormat format = DataFormat.ASCII;
  final SerialCommunication serialCommunication = SerialCommunication();

  @override
  void initState() {
    super.initState();
    serialCommunication.startSerial().listen(_updateConnectionStatus);
    getSerialList();
  }

  getSerialList() async {
    serialList = await serialCommunication.getAvailablePorts();
  }

  @override
  void dispose() {
    serialCommunication.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Serial Communication Example'),
        ),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                setupButton(context),
                const Divider(),
                operations(),
                const Divider(),
                sendCommand(),
                const Divider(),
                response()
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell setupButton(BuildContext context) {
    return InkWell(
      onTap: () {
        settingModalBottomSheet(context: context, list: serialList);
      },
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFF2F2F7),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Tap to setup",
                style: mediumStyle.apply(fontSizeFactor: 1),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Device: \n',
                        style: mediumStyle.apply(color: Colors.blue),
                        children: <TextSpan>[
                          TextSpan(
                            text: selectedPort,
                            style: mediumStyle.apply(color: Colors.black54),
                          )
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Baud Rate: \n',
                        style: mediumStyle.apply(color: Colors.blue),
                        children: <TextSpan>[
                          TextSpan(
                            text: "$selectedBaudRate",
                            style: mediumStyle.apply(color: Colors.black54),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Data Format: ',
                  style: mediumStyle.apply(color: Colors.blue),
                  children: <TextSpan>[
                    TextSpan(
                      text: format.name,
                      style: mediumStyle.apply(
                        color: Colors.black54,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget response() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text(
                  "Received Data",
                  style: mediumStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                button(
                    name: "Empty",
                    onPress: () {
                      serialCommunication.clearRead();
                    }),
              ],
            ),
            Column(
              children: [
                const Text(
                  "Operation Log",
                  style: mediumStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                button(
                    name: "Empty",
                    onPress: () {
                      serialCommunication.clearLog();
                    }),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .4,
          child: Row(
            children: [
              log(data: receivedData),
              const VerticalDivider(
                thickness: 2,
              ),
              log(data: logData)
            ],
          ),
        ),
      ],
    );
  }

  Widget log({required String data}) {
    return Expanded(
      child: Scrollbar(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical, //.horizontal
          child: Text(
            data,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget sendCommand() {
    return Material(
      elevation: 4,
      color: const Color(0xFFF2F2F7),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
        child: Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration(hintText: "Write send Command"),
              ),
            ),
            button(
                name: "Send",
                onPress: () {
                  serialCommunication.sendCommand(message: "message");
                })
          ],
        ),
      ),
    );
  }

  Widget operations() {
    return Material(
      elevation: 4,
      color: const Color(0xFFF2F2F7),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Text("OPERATION", style: mediumStyle.apply(color: Colors.black54)),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                button(
                    name: "Open",
                    onPress: () {
                      serialCommunication.openPort(
                          dataFormat: format,
                          serialPort: selectedPort,
                          baudRate: selectedBaudRate);
                    }),
                button(
                    name: "Close",
                    onPress: () {
                      serialCommunication.closePort();
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateConnectionStatus(SerialResponse? result) async {
    setState(() {
      logData = result!.logChannel ?? "";
      receivedData = result.readChannel ?? "";
    });
  }

  Widget button({required String name, required Function() onPress}) {
    return SizedBox(
      height: 40,
      width: 130,
      child: ElevatedButton(
          onPressed: onPress,
          child: Text(
            name,
            style: mediumStyle,
          )),
    );
  }

  settingModalBottomSheet({context, List<String>? list}) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (context, state) {
              return Container(
                  height: 400,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26),
                    ),
                  ),
                  child: ListView(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            verticalDirection: VerticalDirection.down,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                    child: Container(
                                  height: 5,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(90),
                                  ),
                                )),
                              ),
                              const Divider(),
                              listTile(
                                  widget: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      borderRadius: BorderRadius.circular(10),
                                      hint: Text(
                                        selectedPort,
                                        style: mediumStyle.apply(
                                            fontSizeFactor: 0.9),
                                      ),
                                      items: serialList!.map((String? value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child:
                                              Text(value!, style: mediumStyle),
                                        );
                                      }).toList(),
                                      onChanged: (p0) {
                                        updateSelectPort(state, p0!);
                                      },
                                    ),
                                  ),
                                  title: "Serial Port:"),
                              listTile(
                                  widget: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      isExpanded: true,
                                      borderRadius: BorderRadius.circular(10),
                                      hint: Text(
                                        selectedBaudRate.toString(),
                                        style: mediumStyle.apply(
                                            fontSizeFactor: 0.9),
                                      ),
                                      menuMaxHeight: 400.0,
                                      items: serialCommunication.baudRateList
                                          .map((int? value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(value.toString(),
                                              style: mediumStyle),
                                        );
                                      }).toList(),
                                      onChanged: (p0) {
                                        updateSelectBaudRate(state, p0!);
                                      },
                                    ),
                                  ),
                                  title: 'Select the BaudRate:'),
                              listTile(
                                widget: Row(
                                  children: [
                                    Expanded(
                                      child: CheckboxListTile(
                                        title: const Text(
                                          "ASCII",
                                        ),
                                        value: format == DataFormat.ASCII
                                            ? true
                                            : false,
                                        onChanged: (newValue) {
                                          updateDataFormat(
                                              state, DataFormat.ASCII);
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    ),
                                    Expanded(
                                      child: CheckboxListTile(
                                        title: const Text(
                                          "HEX String",
                                        ),
                                        value: format == DataFormat.HEX_STRING
                                            ? true
                                            : false,
                                        onChanged: (newValue) {
                                          updateDataFormat(
                                              state, DataFormat.HEX_STRING);
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    ),
                                  ],
                                ),
                                title: "Data Format",
                              ),
                            ])
                      ]));
            },
          );
        });
  }

  Future<void> updateSelectPort(StateSetter updateState, String value) async {
    updateState(() {
      setState(() {
        selectedPort = value;
      });
    });
  }

  Future<void> updateDataFormat(
      StateSetter updateState, DataFormat value) async {
    updateState(() {
      setState(() {
        format = value;
      });
    });
  }

  Future<void> updateSelectBaudRate(StateSetter updateState, int value) async {
    updateState(() {
      setState(() {
        selectedBaudRate = value;
      });
    });
  }

  Widget listTile({required Widget widget, required String title}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: mediumStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black38,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.only(
                left: 8.0,
              ),
              child: widget),
        ],
      ),
    );
  }
}

const mediumStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
