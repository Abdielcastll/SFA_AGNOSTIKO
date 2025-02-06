import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../pharos/key_init_response.dart';
import 'package:flutter/foundation.dart';

import 'package:agnostiko/agnostiko.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../pharos/sale_response.dart';
import '../../../pharos/void_response.dart';
import 'iso8583.dart';

//dev
final pharosUsername = "NECS01Oeyx";
//prod
//final pharosUsername = "NecsProd03";

//dev
final pharosPassword = dotenv.env['pharosPasswordSandbox'] ?? '';
//prod
//final pharosPassword = dotenv.env['pharosPasswordProsa'] ?? '';

//  PROD
//const EnvUrl = 'https://api.pharospayments.com/payments/v1/charge';
// DEV
const EnvUrl = 'http://api-sandbox.pharospayments.com/gateway/charge';

Future<Uint8List> getToken(String serialNumber) async {
  final brand = (await getPlatformInfo()).deviceBrand;
  const appId = "com.agnostiko.field_sales";
  var authToken;
  try {
    const productionUrl = "https://insightone-server.agnostiko.com";
    authToken = await getSDKToken(productionUrl, brand, serialNumber, appId);
  } catch (e) {
    try {
      const demoUrl = "https://tms-server-demo.apps2go.tech";
      authToken = await getSDKToken(demoUrl, brand, serialNumber, appId);
    } catch (e) {}
  }
  return authToken;
}

Future<PharosSaleResponse> processSalePharos(
    Map<String, dynamic> pharosMsg) async {
  final usernameAndPassword = pharosUsername + ":" + pharosPassword;
  final bytes = utf8.encode(usernameAndPassword);
  final encoded = base64.encode(bytes);
  final authorizationStr = "Basic " + encoded;

  var header = {"Authorization": authorizationStr};
  try {
    final response = await http
        .post(Uri.parse(EnvUrl), headers: header, body: jsonEncode(pharosMsg))
        .timeout(const Duration(seconds: 60));
    final pharosResponseJson = jsonDecode(response.body.toString());
    final saleResponse = PharosSaleResponse.fromJson(pharosResponseJson);
    print("Pharos Sale response : ${response.body.toString()}");
    return saleResponse;
  } catch (e) {
    return PharosSaleResponse(
      successful: false,
      displayMessage: '',
      resultCode: '01',
      authCode: '',
      referenceNumber: '',
      script1: '',
      script2: '',
      script3: '',
      arpc: '',
      issuerAuthRespCode: '',
    );
  }
}

Future<PharosVoidResponse> processVoidPharos(
    Map<String, dynamic> pharosVoidMsg) async {
  final usernameAndPassword = pharosUsername + ":" + pharosPassword;
  final bytes = utf8.encode(usernameAndPassword);
  final encoded = base64.encode(bytes);
  final authorizationStr = "Basic " + encoded;

  var header = {"Authorization": authorizationStr};
  final response = await http.post(Uri.parse(EnvUrl),
      headers: header, body: jsonEncode(pharosVoidMsg));
  final pharosResponseJson = jsonDecode(response.body.toString());
  final voidResponse = PharosVoidResponse.fromJson(pharosResponseJson);
  print("Pharos Void response : ${response.body.toString()}");
  return voidResponse;
}

Future<IsoMessage> processSale(IsoMessage isoMsg) async {
  final isoBytes = isoMsg.pack();
  final response = await http.get(
    Uri.parse(
      'https://server-agnostiko-web-gnbxyenkeq-ue.a.run.app/sale/${isoBytes.toHexStr().toUpperCase()}',
    ),
  );
  return IsoMessage.unpack(
    response.body.toHexBytes(),
    fieldDefinitions: isoSaleDefinitions,
  );
}

Future<PharosKeyInitResponse> processKeyInitPharos(
    Map<String, dynamic> pharosMsgKeyInit) async {
  final usernameAndPassword = "$pharosUsername:$pharosPassword";
  final bytes = utf8.encode(usernameAndPassword);
  final encoded = base64.encode(bytes);
  final authorizationStr = "Basic $encoded";
  var header = {"Authorization": authorizationStr};
  var body = jsonEncode(pharosMsgKeyInit);
  final response = await http.post(
    Uri.parse(EnvUrl),
    headers: header,
    body: body,
  );
  final pharosResponseJson = jsonDecode(response.body.toString());
  final keyInitResponse = PharosKeyInitResponse.fromJson(pharosResponseJson);
  print("Pharos Key init response: ${response.body.toString()}");
  return keyInitResponse;
}

Future<IsoMessage> processKeyInit(IsoMessage isoMsg) async {
  final isoBytes = isoMsg.pack();
  final response = await http.get(
    Uri.parse(
      'https://server-agnostiko-web-gnbxyenkeq-ue.a.run.app/keyinit/${isoBytes.toHexStr().toUpperCase()}',
    ),
  );
  return IsoMessage.unpack(
    response.body.toHexBytes(),
    fieldDefinitions: isoSaleDefinitions,
  );
}

Future<void> downloadFile(String url, String filePath) async {
  final httpClient = HttpClient();
  httpClient.badCertificateCallback = (cert, host, port) => true;

  final request = await httpClient.getUrl(Uri.parse(url));
  final response = await request.close();
  if (response.statusCode == 200) {
    final bytes = await consolidateHttpClientResponseBytes(response);
    final file = File(filePath);
    await file.writeAsBytes(bytes);
  }
}

void openWebSocketConnection(
  String ipAddress,
  void Function(String, PlatformInfo) onData,
) async {
  final sn = await getSerialNumber();
  final platformInfo = await getPlatformInfo();
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://$ipAddress:4000'),
  );
  print("WebSocket open...");
  channel.sink.add(sn);
  channel.stream.listen(
    (message) {
      onData(message, platformInfo);
    },
    onError: (e) {
      print("ERROR EN CHANNEL: $e");
    },
    onDone: () {
      print("CHANNEL DONE");
    },
    cancelOnError: true,
  );
}

void listenToUdpMulticast(void Function(String, PlatformInfo) onData) async {
  InternetAddress multicastAddress = InternetAddress("239.10.10.100");
  int multicastPort = 4545;
  RawDatagramSocket.bind(InternetAddress.anyIPv4, multicastPort)
      .then((RawDatagramSocket socket) {
    print('Datagram socket ready to receive');
    print('${socket.address.address}:${socket.port}');

    socket.joinMulticast(multicastAddress);
    print('Multicast group joined');

    socket.listen((RawSocketEvent e) {
      Datagram? d = socket.receive();
      if (d == null) return;

      String message = String.fromCharCodes(d.data).trim();
      print('Datagram from ${d.address.address}:${d.port}: $message');
      if (message == 'agnostiko') {
        socket.close();
        openWebSocketConnection(d.address.address, onData);
      }
    });
  });
}
