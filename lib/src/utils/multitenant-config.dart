import 'dart:convert';
import 'dart:io';

import 'package:agnostiko/agnostiko.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tms_agent_communication/tms_agent_communication.dart';
import 'package:collection/collection.dart';

class _MultitenantConfig {
  Map<String, dynamic>? fieldSalesConfig;
  FirebaseApp? baseApp;
  FirebaseApp? tenantApp;

  final _tmsAgentCommunication =
      TmsAgentCommunication(appId: 'com.agnostiko.field_sales');

  _MultitenantConfig() {
    _tmsAgentCommunication.streamConfigChanges.stream.listen((configs) async {
      if (configs == null) {
        return;
      }

      final fsConfig = configs.firstWhereOrNull(
          (element) => element['templateName'] == 'Field Sales');

      if (fsConfig == null) {
        return;
      }

      await saveConfigFile(fsConfig);

      fieldSalesConfig = await readLocalFile();
    });
  }

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
      if (!await validateLocalFile()) {
        final config = await getAppConfig();
        await saveConfigFile(config);
      }

      fieldSalesConfig = await readLocalFile();

      final tenantInfo = await getTenantFirebaseDatabase();

      tenantApp =
          await Firebase.initializeApp(name: 'tenant-app', options: tenantInfo);

      return true;
    } catch (e) {
      throw Exception(
          'No se pudo inicializar la configuracion Multitenant: $e');
    }
  }

  Future<FirebaseOptions> getTenantFirebaseDatabase() async {
    baseApp = await Firebase.initializeApp(
        name: 'base-app',
        options: const FirebaseOptions(
            apiKey: "AIzaSyCoOXpe8Y3eI7yo85ExuFKHJ9q8OvuDG_g",
            authDomain: "multitenant-example-1.firebaseapp.com",
            projectId: "multitenant-example-1",
            storageBucket: "multitenant-example-1.appspot.com",
            messagingSenderId: "473200255429",
            appId: "1:473200255429:web:08f7d3d72d91394d68abac"));

    final tenantDoc = fieldSalesConfig!['cliente_id'];

    final tenantInfo = await FirebaseFirestore.instanceFor(app: baseApp!)
        .collection('clientes')
        .doc(tenantDoc)
        .get();

    print(tenantInfo.exists);

    if (!tenantInfo.exists) {
      throw Exception('Tenant no registrado en Firebase');
    }

    final mapAppConfig = tenantInfo.get('webAppConfig') as Map<String, dynamic>;

    print(mapAppConfig);

    return FirebaseOptions(
        apiKey: mapAppConfig['apiKey']!,
        authDomain: mapAppConfig['authDomain']!,
        projectId: mapAppConfig['projectId']!,
        storageBucket: mapAppConfig['storageBucket']!,
        messagingSenderId: mapAppConfig['messagingSenderId']!,
        appId: mapAppConfig['appId']!);
  }

  Future<Map<String, dynamic>> getAppConfig() async {
    final configs = await _tmsAgentCommunication.getConfig;

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
