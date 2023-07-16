import 'dart:convert';
import 'dart:io';

import 'package:agnostiko/agnostiko.dart';
import 'package:tms_agent_communication/tms_agent_communication.dart';
import 'package:collection/collection.dart';

class _MultitenantConfig {
  Map<String, dynamic>? fieldSalesConfig;

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

  final _tmsAgentCommunication =
      TmsAgentCommunication(appId: 'com.agnostiko.field_sales');

  Future<bool> initialize() async {
    try {
      if (!await validateLocalFile()) {
        final config = await getAppConfig();
        await saveConfigFile(config);
      }

      fieldSalesConfig = await readLocalFile();

      print(fieldSalesConfig);

      return true;
    } catch (e) {
      throw Exception(
          'No se pudo inicializar la configuracion Multitenant: $e');
    }
  }

  Future<Map<String, dynamic>> getAppConfig() async {
    final configs = await _tmsAgentCommunication.getConfig;

    if (configs == null) {
      throw Exception('Error al recivir la configuracion del dispositivo');
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
