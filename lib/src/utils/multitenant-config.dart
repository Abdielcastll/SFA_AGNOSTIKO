import 'dart:convert';
import 'dart:io';

import 'package:agnostiko/agnostiko.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/firebase_options.dart';
import 'package:pwa_sales2go_flutter/src/features/product/domain/repositories/detalle_producto_labels.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth/login/email_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
//import 'package:tms_agent_communication/tms_agent_communication.dart';
import 'package:collection/collection.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

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
        options: const FirebaseOptions(
          apiKey: "AIzaSyCoOXpe8Y3eI7yo85ExuFKHJ9q8OvuDG_g",
          authDomain: "multitenant-example-1.firebaseapp.com",
          projectId: "multitenant-example-1",
          storageBucket: "multitenant-example-1.appspot.com",
          messagingSenderId: "473200255429",
          appId: "1:473200255429:web:08f7d3d72d91394d68abac",
        ),
      );

      var auth1 = FirebaseAuth.instanceFor(app: baseApp!);
      auth1.signInWithEmailAndPassword(
        email: "multitenant_key@apps2go.tech",
        password: "&9Jk#4Lz!wQ8",
      );
      var auth2 = FirebaseAuth.instance;
      auth2.signInWithEmailAndPassword(
        email: "multitenant_key@apps2go.tech",
        password: "&9Jk#4Lz!wQ8",
      );

      String? tenantEmail = sharedPreferences!.getString("tenantEmail");
      await initMultitenantWithEmail(tenantEmail!);

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

  Future<bool> checkExistence(String email) async {
    try {
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
      var auth1 = FirebaseAuth.instanceFor(app: baseApp!);
      auth1.signInWithEmailAndPassword(
        email: "multitenant_key@apps2go.tech",
        password: "&9Jk#4Lz!wQ8",
      );
      var tenantInfo = await FirebaseFirestore.instanceFor(app: baseApp!)
          .collection('clientes')
          .where('usuarios', arrayContains: email)
          .get()
          .timeout(const Duration(seconds: 30));

      if (tenantInfo.docs.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print('error del check existence');
      print(e);
      return false;
    }
  }

  Future<bool> initMultitenantWithEmail(String email) async {
    try {
      var tenantInfo = await FirebaseFirestore.instanceFor(app: baseApp!)
          .collection('clientes')
          .where('usuarios', arrayContains: email)
          .get();

      if (tenantInfo.docs.isEmpty) {
        throw Exception('Tenant no registrado en Firebase');
      }

      // Assuming only one document should match the query
      final tenantDoc = tenantInfo.docs.first;
      final mapAppConfig =
          tenantDoc.get('webAppConfig') as Map<String, dynamic>;

      print(mapAppConfig);

      FirebaseOptions tennantInfo = FirebaseOptions(
        apiKey: mapAppConfig['apiKey']!,
        authDomain: mapAppConfig['authDomain']!,
        projectId: mapAppConfig['projectId']!,
        storageBucket: mapAppConfig['storageBucket']!,
        messagingSenderId: mapAppConfig['messagingSenderId']!,
        appId: mapAppConfig['appId']!,
      );

      tenantApp = await Firebase.initializeApp(
        name: 'tenant-app',
        options: tennantInfo,
      );
      RemoteConfigProvider provider = RemoteConfigProvider();
      provider.getRemoteConfig();
      return true;
    } catch (e) {
      throw (e);
    }
  }

  Future<void> getLabelsDetalleProducto() async {
    try {
      FirebaseFirestore firestore =
          FirebaseFirestore.instanceFor(app: tenantApp!);
      DocumentSnapshot snapshot = await firestore
          .collection('tenant')
          .doc('etiquetas_detalles_producto')
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        DetalleLabels().setValues(
          diseno: data['diseno'] ?? '',
          linea: data['linea'] ?? '',
          tamano: data['tamano'] ?? '',
        );
      }
    } catch (e) {
      print('Error fetching DetalleLabels: $e');
    }
  }

  Future<void> getColorsApp(BuildContext context) async {
    try {
      print("GET COLORES");
      FirebaseFirestore firestore =
          FirebaseFirestore.instanceFor(app: tenantApp!);

      DocumentSnapshot document =
          await firestore.collection('tenant').doc('colores_app').get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        // Parse colors
        Color primaryColor = Color(int.parse(data['primary'], radix: 16));
        Color secondaryColor = Color(int.parse(data['secondary'], radix: 16));
        Color onBackground = Color(int.parse(data['onBackground'], radix: 16));
        Color onPrimaryContainer =
            Color(int.parse(data['onPrimaryContainer'], radix: 16));
        Color onTertiaryContainer =
            Color(int.parse(data['onTertiaryContainer'], radix: 16));

        // Update the theme provider
        Provider.of<ThemeProvider>(context, listen: false).setColors(
          primary: primaryColor,
          secondary: secondaryColor,
          onBackground: onBackground,
          onPrimaryContainer: onPrimaryContainer,
          onTertiaryContainer: onTertiaryContainer,
        );
      } else {
        print('Colors Document does not exist.');
      }
    } catch (e) {
      print('Error fetching colors: $e');
    }
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
