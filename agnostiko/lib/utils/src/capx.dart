import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:flutter/services.dart';

import '../../cards/cards.dart';
import '../../emv/emv.dart';
import '../../ped/ped.dart';

/// Implementación de "Capítulo X" para esquema de encriptado de México.
class CapX {
  /// Índice de llave DUKPT a utilizar para el encriptado bajo "Capítulo X".
  final int keyIndex;

  CapX(int dukptIndex) : keyIndex = dukptIndex;

  /// Verifica si la llave de "Capítulo X" está cargada en el índice [keyIndex].
  Future<bool> checkKeyExists() {
    return cryptoDUKPTCheckKeyExists(keyIndex);
  }

  /// Encriptado de datos bajo esquema DUKPT de acuerdo a "Capítulo X".
  ///
  /// El KSN se incrementa automáticamente en 1 tras cada encriptado con este
  /// método debido a limitaciones de ciertas plataformas. Por lo tanto, se
  /// recomienda armar una sola cadena de bytes con todos los bloques (de 8
  /// bytes cada uno) a encriptar bajo un mismo KSN.
  ///
  /// Igualmente, si se desea aumentar el KSN en cierta cantidad mayor a 1, se
  /// puede llamar este método en un loop para logar dicho resultado.
  ///
  /// Falla si la llave no ha sido correctamente inicializada anteriormente o
  /// hay algún error durante el encriptado
  Future<DUKPTResult> encrypt(Uint8List data) {
    return cryptoDUKPTEncrypt(keyIndex, data, CipherMode.ECB);
  }

  /// Obtiene el Tag 57(Track 2) directamente encriptado del kernel EMV
  ///
  /// Puede retornar nulo si no se encuentra el tag
  ///
  /// El track 2 se paddea automáticamente con 'F' a la derecha para completar
  /// los bloques para el encriptado DES
  ///
  /// Falla si la llave no ha sido correctamente inicializada anteriormente o
  /// hay algún error durante el encriptado
  Future<DUKPTResult?> getEncryptedTag57() {
    return EmvModule.instance.getDUKPTEncryptedTagValue(
      0x57, // Tag 57 - Track 2 Equivalent Data
      keyIndex,
      CipherMode.ECB,
    );
  }

  /// Obtiene la data de tracks de banda magnética directamente encriptados
  ///
  /// Los tracks se paddean automáticamente con 'F' a la derecha para completar
  /// los bloques para el encriptado DES
  ///
  /// Falla si la llave no ha sido correctamente inicializada anteriormente o
  /// hay algún error durante el encriptado
  Future<DUKPTEncryptedTracksData?> getEncryptedMagneticTracks() async {
    return getDUKPTEncryptedTracksData(keyIndex, CipherMode.ECB);
  }

  /// Llave de transporte encriptada con llave RSA ubicada en [rsaKeyPath].
  ///
  /// La ruta del [rsaKeyPath] es relativa a los assets de la aplicación.
  ///
  /// Falla si el archivo no existe o si hay error al parsear la llave RSA.
  Future<TransportKey> getEncryptedTransportKey(String rsaKeyPath) async {
    final publicPem = await rootBundle.loadString(rsaKeyPath);
    final publicKey = RSAKeyParser().parse(publicPem) as RSAPublicKey;
    return cryptoGenerateTransportKey(publicKey);
  }

  /// Carga la llave IPEK con el KSN inicial y la K0 encriptada del Host.
  ///
  /// La llave K0 del Host deberá venir encriptada con la llave de transporte
  /// obtenida mediante [getEncryptedTransportKey].
  ///
  /// OJO: la llave de transporte es aleatoria y varía en cada objeto [CapX].
  /// Solo se debe utilizar una vez para inicialización de la llave DUKPT.
  Future<void> loadEncryptedIPEK(Uint8List ksn, Uint8List encryptedIPEK) async {
    await cryptoLoadIPEK(keyIndex, ksn, encryptedIPEK, useTransportKey: true);
  }

  /// Incrementa el contador KSN asociado a la llave DUKPT
  Future<void> incrementKSN() async {
    await cryptoDUKPTIncrementKSN(keyIndex);
  }
}
