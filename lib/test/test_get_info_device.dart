// import 'dart:html';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoadInfo extends StatefulWidget {
  LoadInfo({Key? key}) : super(key: key);

  @override
  State<LoadInfo> createState() => _LoadInfoState();
}

class _LoadInfoState extends State<LoadInfo> {
  String text = '///Loading///';
  @override
  void initState() {
    super.initState();
    loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoadInfo'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            text,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  void loadInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      // for Example: "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"
      print('Web - running on ${webBrowserInfo.browserName}');
      setState(() {
        text = 'Web - running on ${webBrowserInfo.browserName}';
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('IOs - running on ${iosInfo.utsname.machine}');
      setState(() {
        text = 'IOs - running on ${iosInfo.utsname.machine}';
      });
      // for Example: 'iPod7,1'
      setState(() {
        text = iosInfo.toMap().toString();
      });
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Android - running on ${androidInfo.model}');
      // for Example: 'Nexus 6P'
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      print(windowsInfo.toMap().toString());
    }
  }
}
