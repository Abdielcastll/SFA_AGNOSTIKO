class UrlSingleton {
  UrlSingleton._instance();
  static final UrlSingleton _singleton = UrlSingleton._instance();
  factory UrlSingleton() => _singleton;

  //Pharos Produccion
  static String prodEnvURL = 'https://api.pharospayments.com/payments/v1/charge';
  static String prodPharosUsernameApi = "NECS01Oeyx";
  static String prodPharosPasswordApi = "xNjUg5nKwHYgCHgtJrKxdzSZ";
  static String prodBinUrl = 'https://backoffice.pharospayments.com/api/v2/bins/';
  static String prodTicketUrl = 'https://backoffice.pharospayments.com/api/v2/transactions/';

  //Bankaool Produccion
  /*
  static String prodEnvURL = 'https://api.pharospayments.com/payments/bankaool/charge';
  static String prodPharosUsernameApi = "Bankaool_prod01";
  static String prodPharosPasswordApi = "R0VRpBKJE7ZVvdGa6k4tImn6mB5vNsq1";
  static String prodBinUrl = 'https://bankaool.pharospayments.com/api/v2/bins/';
  static String prodTicketUrl = 'https://bankaool.pharospayments.com/api/v2/transactions/';
  */

  //Develop Generic
  static String devEnvURL = 'http://api-sandbox.pharospayments.com/gateway/charge';
  static String devPharosUsernameApi = "NECS01Oeyx";
  static String devPharosPasswordApi = "xNjUg5nKwHYgCHgtJrKxdzSZ";
  static String devBinUrl = 'https://backoffice.pharospayments.com/api/v2/bins/';
  static String devTicketUrl = 'https://backoffice.pharospayments.com/api/v2/transactions/';


  String baseUrl = prodEnvURL;
  String pharosUsernameApi = prodPharosUsernameApi;
  String pharosPasswordApi = prodPharosPasswordApi;
  String binUrl = prodBinUrl;
  String ticketUrl = prodTicketUrl;

  bool _isDev = false;
  bool get isDev => _isDev;
  set isDev(bool value) {
    _isDev = value;
    baseUrl = value ? devEnvURL : prodEnvURL;
    pharosUsernameApi = value? devPharosUsernameApi:prodPharosUsernameApi;
    pharosPasswordApi = value? devPharosPasswordApi:prodPharosPasswordApi;
    binUrl =  value? devBinUrl:prodBinUrl;
    ticketUrl = value? devTicketUrl:prodTicketUrl;
  }
}
