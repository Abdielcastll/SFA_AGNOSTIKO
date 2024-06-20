import 'dart:convert';
import 'dart:io';

import 'package:agnostiko/agnostiko.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pwa_sales2go_flutter/firebase_options.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
//import 'package:tms_agent_communication/tms_agent_communication.dart';
import 'package:collection/collection.dart';

class _MultitenantConfig {
  Map<String, dynamic>? fieldSalesConfig;
  FirebaseApp? baseApp;
  FirebaseApp? tenantApp;

  //final _tmsAgentCommunication =
  //    TmsAgentCommunication(appId: 'com.agnostiko.field_sales');

  // _MultitenantConfig() {
  //   _tmsAgentCommunication.streamConfigChanges.stream.listen((configs) async {
  //     if (configs == null) {
  //       return;
  //     }

  //     final fsConfig = configs.firstWhereOrNull(
  //         (element) => element['templateName'] == 'Field Sales');

  //     if (fsConfig == null) {
  //       return;
  //     }

  //     await saveConfigFile(fsConfig);

  //     fieldSalesConfig = await readLocalFile();
  //   });
  // }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File?> get _localFile async {
    try {
      final path = await _localPath;
      final file = File('$path/field_sales-config.json');

      return file;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> readLocalFile() async {
    try {
      final file = await _localFile;

      if (file == null) return null;

      final fileString = await file.readAsString();
      return json.decode(fileString);
    } catch (e) {
      return null;
    }
  }

  Future<bool> initialize() async {
    try {
      print("init multitenant");
      // if (!await validateLocalFile()) {
      //   final config = await getAppConfig();
      //   await saveConfigFile(config);
      // }
      //fieldSalesConfig = await readLocalFile();

      final tenantInfo = await getTenantFirebaseDatabase();

      tenantApp = await Firebase.initializeApp(
        name: 'tenant-app',
        options: tenantInfo,
      );
      baseApp = await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCoOXpe8Y3eI7yo85ExuFKHJ9q8OvuDG_g",
          authDomain: "multitenant-example-1.firebaseapp.com",
          projectId: "multitenant-example-1",
          storageBucket: "multitenant-example-1.appspot.com",
          messagingSenderId: "473200255429",
          appId: "1:473200255429:web:08f7d3d72d91394d68abac",
        ),
      );
      print('options change try');
      try {
        await Firebase.initializeApp(
          options: tenantInfo,
        );
      } catch (e) {
        print('tried: ' + e.toString());
      }
      RemoteConfigProvider provider = RemoteConfigProvider();
      provider.getRemoteConfig();
      return true;
    } catch (e) {
      throw Exception(
          'No se pudo inicializar la configuracion Multitenant: $e');
    }
  }

  Future<bool> initializePhone() async {
    try {
      tenantApp = await Firebase.initializeApp(
        name: 'tenant-app',
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      RemoteConfigProvider provider = RemoteConfigProvider();
      provider.getRemoteConfig();
      return true;
    } catch (e) {
      throw Exception(
          'No se pudo inicializar la configuracion Multitenant: $e');
    }
  }

  Future<FirebaseOptions> getTenantFirebaseDatabase() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCoOXpe8Y3eI7yo85ExuFKHJ9q8OvuDG_g",
        authDomain: "multitenant-example-1.firebaseapp.com",
        projectId: "multitenant-example-1",
        storageBucket: "multitenant-example-1.appspot.com",
        messagingSenderId: "473200255429",
        appId: "1:473200255429:web:08f7d3d72d91394d68abac",
      ),
    );
    baseApp = await Firebase.initializeApp(
      name: 'base-app',
      options: const FirebaseOptions(
        apiKey: "AIzaSyCoOXpe8Y3eI7yo85ExuFKHJ9q8OvuDG_g",
        authDomain: "multitenant-example-1.firebaseapp.com",
        projectId: "multitenant-example-1",
        storageBucket: "multitenant-example-1.appspot.com",
        messagingSenderId: "473200255429",
        appId: "1:473200255429:web:08f7d3d72d91394d68abac",
      ),
    );

    //TODO ver como hacer el mail dinamico sin que se truene
    var tenantInfo = await FirebaseFirestore.instanceFor(app: baseApp!)
        .collection('clientes')
        .where('usuarios', arrayContains: 'vendedorretail1@example.com')
        .get();

    if (tenantInfo.docs.isEmpty) {
      throw Exception('Tenant no registrado en Firebase');
    }

    // Assuming only one document should match the query
    final tenantDoc = tenantInfo.docs.first;
    final mapAppConfig = tenantDoc.get('webAppConfig') as Map<String, dynamic>;

    print(mapAppConfig);

    return FirebaseOptions(
      apiKey: mapAppConfig['apiKey']!,
      authDomain: mapAppConfig['authDomain']!,
      projectId: mapAppConfig['projectId']!,
      storageBucket: mapAppConfig['storageBucket']!,
      messagingSenderId: mapAppConfig['messagingSenderId']!,
      appId: mapAppConfig['appId']!,
    );
  }

  Future<Map<String, dynamic>> getAppConfig() async {
    const configs = null; //await _tmsAgentCommunication.getConfig;
    if (configs == null) {
      throw Exception('Error al recibir la configuracion del dispositivo');
    }

    final fsConfig = configs.firstWhereOrNull(
        (element) => element['templateName'] == 'Field Sales');

    if (fsConfig == null) {
      throw Exception(
          'La configuracion no cuenta con la informacion de Field Sales');
    }

    print(fsConfig);
    return fsConfig;
  }

  Future<File?> saveConfigFile(Map<String, dynamic> config) async {
    final file = await _localFile;

    if (file == null) return null;

    config['expiration_time'] =
        DateTime.now().add(Duration(days: 7)).millisecondsSinceEpoch;

    final contents = json.encode(config);

    return await file.writeAsString(contents);
  }

  Future<bool> validateLocalFile() async {
    try {
      final localConfig = await readLocalFile();

      if (localConfig == null) return false;

      if (localConfig['expiration_time'] <
          DateTime.now().millisecondsSinceEpoch) return false;

      return true;
    } catch (e) {
      return false;
    }
  }
}

final multitenantConfig = _MultitenantConfig();
