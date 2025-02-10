class BackofficeAuthData {
  static final BackofficeAuthData _instance = BackofficeAuthData._internal();

  String? apiKey;
  String? terminalId;
  String? merchantId;

  factory BackofficeAuthData() {
    return _instance;
  }

  BackofficeAuthData._internal();

  void updateFromResponse(Map<String, dynamic> response) {
    apiKey = response['merchant']?['api_key'];
    terminalId = response['terminal']?['id'].toString();
    merchantId = response['merchant']?['id'].toString();
  }

  void clear() {
    apiKey = null;
    terminalId = null;
    merchantId = null;
  }
}
