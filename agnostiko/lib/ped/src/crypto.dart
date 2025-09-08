import "dart:typed_data";

import 'package:pointycastle/asymmetric/api.dart';

import 'package:agnostiko/agnostiko.dart';

const cryptoChannel = const HybridMethodChannel('agnostiko/Crypto');

enum CipherMode {
  ECB,
  CBC,
}

/// Resultado de un encriptado bajo llaves DUKPT.
class DUKPTResult {
  /// Data cifrada bajo DUKPT.
  Uint8List data;

  /// Key Serial Number (KSN) de la llave utilizada para el encriptado.
  Uint8List ksn;

  // Longitud original de la data antes de paddear y encriptar
  int actualDataLen;

  DUKPTResult({
    required this.data,
    required this.ksn,
    required this.actualDataLen,
  });

  Map<String, dynamic> toJson() {
    return {"data": data, "ksn": ksn, "actualDataLen": actualDataLen};
  }

  factory DUKPTResult.fromJson(Map<String, dynamic> json) {
    return DUKPTResult(
      data: json["data"],
      ksn: json["ksn"],
      actualDataLen: json["actualDataLen"],
    );
  }
}

/// Elimina todas las llaves cargadas en el módulo seguro del dispositivo.
Future<void> cryptoDeleteAllKeys() async {
  await cryptoChannel.invokeMethod("deleteAllKeys");
}

/// Elimina la llave DUKPT con índice: [keyIndex]
Future<void> cryptoDUKPTDeleteKey(int keyIndex) async {
  await cryptoChannel.invokeMethod("dukptDeleteKey", keyIndex);
}

/// Contenedor para datos de llave criptográfica de transporte
class TransportKey {
  final Uint8List keyData;
  final Uint8List kcv;

  TransportKey(this.keyData, this.kcv);

  factory TransportKey.fromJson(Map<String, dynamic> data) {
    return TransportKey(data["keyData"], data["kcv"]);
  }

  Map<String, dynamic> toJson() {
    return {"keyData": keyData, "kcv": kcv};
  }
}

/// Genera una llave DES de transporte encriptada con llave pública RSA
///
/// El valor 'en claro' de dicha llave de transporte puede ser luego utilizado
/// para encriptar un IPEK y cargarlo de forma segura(mediante [cryptoLoadIPEK])
Future<TransportKey> cryptoGenerateTransportKey(RSAPublicKey publicKey) async {
  final modulus = publicKey.modulus?.toHexBytes();
  final exponent = publicKey.exponent?.toHexBytes();
  if (modulus == null || exponent == null) {
    throw ArgumentError("modulus or exponent missing");
  }

  final result = await cryptoChannel.invokeMethod("generateTransportKey", {
    "modulus": modulus,
    "exponent": exponent,
  });
  return TransportKey.fromJson(Map<String, dynamic>.from(result));
}

/// Carga de llave IPEK (Initial PIN Encryption Key) para derivación DUKPT.
///
/// El rango recomendado para el índice de la llave es 1-9, el índice 0 no es
/// válido. La longitud de llave soportada es de 128 bits únicamente.
///
/// El parámetro opcional [kekIndex] se utiliza para identificar el índice de
/// la llave precargada en el terminal que se utilizó para encriptar la IPEK.
/// Esta es la forma recomendada de cargar llaves y en algunas marcas el
/// intentar cargar llaves IPEK en claro ya no funciona.
///
/// Si la llave está en claro se puede obviar el parámetro [useTransportKey].
/// En caso de que la llave venga encriptada con una llave de transporte
/// generada anteriormente con [cryptoGenerateTransportKey], se debe setear
/// dicho parámetro a 'true'.
Future<void> cryptoLoadIPEK(
  int keyIndex,
  Uint8List ksn,
  Uint8List ipek, {
  int? kekIndex,
  bool useTransportKey = false,
  Uint8List? kcv
}) async {
  if (ksn.length != 10) {
    throw StateError("La longitud del KSN debe ser 10 bytes.");
  }
  if (ipek.length != 16) {
    throw StateError(
      "La longitud de la llave IPEK debe ser de 16 bytes.",
    );
  }
  await cryptoChannel.invokeMethod("loadIPEK", {
    "keyIndex": keyIndex,
    "ksn": ksn,
    "ipek": ipek,
    "useTransportKey": useTransportKey,
    "kekIndex": kekIndex,
    "kcv": kcv,
  });
}

/// Indica si un grupo DUKPT existe en módulo seguro de acuerdo a su [keyIndex].
Future<bool> cryptoDUKPTCheckKeyExists(int keyIndex) async {
  bool keyExists = await cryptoChannel.invokeMethod(
    "dukptCheckKeyExists",
    keyIndex,
  );
  return keyExists;
}

/// Encriptado de datos bajo llaves DUKPT con algoritmo 3DES
///
/// La longitud de [data] debe ser múltiplo del tamaño de bloque 3DES(8 bytes).
///
/// El parámetro [iv] (Vector de Inicialización) es obligatorio para el modo de
/// encriptado [CipherMode.CBC].
Future<DUKPTResult> cryptoDUKPTEncrypt(
  int keyIndex,
  Uint8List data,
  CipherMode cipherMode, [
  Uint8List? iv,
]) async {
  if (cipherMode == CipherMode.CBC && iv == null) {
    throw StateError(
      "El modo de cifrado 'CBC' requiere un vector de inicialización.",
    );
  }
  if ((data.length % 8) != 0) {
    throw StateError(
      "La longitud del cifrado debe ser múltiplo del tamaño de bloque (8 bytes)",
    );
  }
  final result = await cryptoChannel.invokeMethod("dukptEncrypt", {
    "keyIndex": keyIndex,
    "data": data,
    "cipherMode": cipherMode.index,
    "iv": iv,
  });
  return DUKPTResult.fromJson(Map<String, dynamic>.from(result));
}

/// Retorna el KSN de la llave DUKPT con índice: [keyIndex] o null si no existe
Future<Uint8List?> cryptoDUKPTGetKSN(int keyIndex) async {
  final result = await cryptoChannel.invokeMethod("dukptGetKSN", keyIndex);
  return result as Uint8List?;
}

/// Incrementa el contador KSN asociado a la llave DUKPT con índice [keyIndex]
Future<void> cryptoDUKPTIncrementKSN(int keyIndex) {
  return cryptoChannel.invokeMethod("dukptIncrementKSN", keyIndex);
}

/// Carga llave KEK para pruebas
///
/// NOTA: Este método es solo para uso interno del SDK.
Future<void> loadTestKEK() async {
  await cryptoChannel.invokeMethod("loadTestKEK");
}
