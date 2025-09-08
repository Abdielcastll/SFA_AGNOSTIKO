class AgnostikoError {
  /// Error general
  static const int FAIL = -1;
  static const int UNSUPPORTED = -2;

  // Errores de módulo crypto

  /// Error básico de módulo crypto
  static const int CRYPTO_ERROR = -300;

  /// Error de validación del KCV suministrado
  static const int KCV_FAILED = -301;

  /// Llave no encontrada
  static const int KEY_MISSING = -302;

  /// KEK no soportado en marca
  static const int KEK_UNSUPPORTED = -303;

  // Errores de pinpad

  /// Error genérico de pinpad
  static const int PINPAD_ERROR = -400;

  /// Error de conexión con el pinpad
  static const int PINPAD_CONNECTION_ERROR = -401;
}
