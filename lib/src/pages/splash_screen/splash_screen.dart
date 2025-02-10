import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:agnostiko/agnostiko.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pwa_sales2go_flutter/pharos/pharos.dart';
import 'package:pwa_sales2go_flutter/src/features/product/domain/repositories/backoffice_auth_data.dart';
import 'package:pwa_sales2go_flutter/src/features/product/domain/repositories/backoffice_services.dart';
import 'package:pwa_sales2go_flutter/src/services/utils/comm.dart';
import 'package:pwa_sales2go_flutter/src/services/utils/emv.dart';
import '../../services/utils/keypad.dart';
import '../../services/utils/token.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreenView extends StatefulWidget {
  static String route = "/";
  final bool redirect;

  const SplashScreenView({super.key, this.redirect = true});

  @override
  SplashScreenViewState createState() => SplashScreenViewState();
}

class SplashScreenViewState extends State<SplashScreenView> {
  String _cardMsg = "";
  bool _visibility = false;
  bool _exit = false;
  String _buttonTitle = "";
  bool _invalidToken = false;
  int _initFailedCounter = 0;

  @override
  void initState() {
    super.initState();

    if (widget.redirect) initSplashScreen();
  }

  void loadingCardMsg(String cardMsg) {
    setState(() {
      _cardMsg = cardMsg;
    });
  }

  void setInvalidToken(bool invalidToken) {
    setState(() {
      _invalidToken = invalidToken;
    });
  }

  void loadingVisibility(bool visibility, {bool? exit}) {
    setState(() {
      _visibility = visibility;
      if (exit != null) {
        _exit = exit;
        _exit ? _buttonTitle = 'Salir' : _buttonTitle = 'Reintentar';
      }
    });
  }

  void onTapButton() {
    if (!_exit) {
      loadingCardMsg("");
      loadingVisibility(false);
      initSplashScreen();
    } else {
      exit(0);
    }
  }

  Future<void> loadServerCertificate() async {
    ByteData data = await rootBundle.load('assets/ca/gcloud2.cer');
    SecurityContext context = SecurityContext.defaultContext;
    context.setTrustedCertificatesBytes(data.buffer.asUint8List());
  }

  Future<Uint8List?> _getTokenOnline(String serialNumber) async {
    String? tokenStr;
    Uint8List authToken;
    try {
      authToken = await getToken(serialNumber);
    } catch (e) {
      String cardMsg = 'connectionErrorToken';
      loadingCardMsg(cardMsg);
      loadingVisibility(true, exit: false);
      return null;
    }
    tokenStr = authToken.toHexStr();
    saveToken(tokenStr);
    print("No se tenía un token guardado. Se obtuvo uno nuevo del servidor");
    return authToken;
  }

  Future<Uint8List?> _getLocalToken() async {
    Uint8List? token;
    try {
      token = await checkToken();
      return token;
    } catch (e) {
      setInvalidToken(true);
      return null;
    }
  }

  Future<Uint8List?> _initToken() async {
    Uint8List? authToken;
    bool isTokenExpired;
    try {
      Uint8List? token = await _getLocalToken();
      if (token != null && _invalidToken == false) {
        authToken = token;
        isTokenExpired = validateExpDateToken(authToken);
        if (!isTokenExpired) {
          print("Ya existe un token guardado no vencido");
          return authToken;
        } else {
          setInvalidToken(true);
          print("Token vencido, obteniendo otro online");
          initSplashScreen();
          return null;
        }
      } else {
        String? serialNumber = await getSerialNumber();
        if (serialNumber != null) {
          authToken = await _getTokenOnline(serialNumber);
          return authToken;
        } else {
          String cardMsg = 'serialErrorToken';
          loadingCardMsg(cardMsg);
          loadingVisibility(true, exit: true);
          return null;
        }
      }
    } catch (e) {
      String cardMsg = 'generalErrorToken';
      loadingCardMsg(cardMsg);
      loadingVisibility(true, exit: true);
      return null;
    }
  }

  bool _catchInitFailed({Object? e}) {
    bool initCompleted;
    String cardMsg = 'initError';
    loadingCardMsg(cardMsg);
    loadingVisibility(true, exit: true);
    initCompleted = false;
    return initCompleted;
  }

  bool _catchPlatformException() {
    bool initCompleted;
    if (_initFailedCounter < 3) {
      setInvalidToken(true);
      _initFailedCounter++;
      print("Token inválido, obteniendo otro, intento: $_initFailedCounter");
      initSplashScreen();
      initCompleted = false;
      return initCompleted;
    } else {
      return _catchInitFailed();
    }
  }

  Future<bool> _initPos() async {
    bool initCompleted;
    Uint8List? authToken;
    final deviceType = await getDeviceType();

    try {
      if (deviceType == DeviceType.POS) {
        authToken = await _initToken();
        if (authToken == null) {
          initCompleted = false;
          return initCompleted;
        } else {
          await initSDK(authToken: authToken);
        }
      } else if (deviceType == DeviceType.PINPAD) {
        await connectPinpad();
        authToken = await _initToken();
        if (authToken == null) {
          return false;
        } else {
          await initSDK(authToken: authToken);
          await emvPreTransaction();
        }
      } else {
        await initSDK();
      }
      print("Librería Universal de Pagos inicializada!");
      await _validateKeyInitialization();

      initCompleted = true;
    } on PlatformException {
      initCompleted = _catchPlatformException();
      return initCompleted;
    } catch (e) {
      initCompleted = _catchInitFailed(e: e);
      return initCompleted;
    }

    return initCompleted;
  }

  bool isCertificateLoaded = false;
  Future<void> initSplashScreen() async {
    if (!isCertificateLoaded && Platform.isLinux) {
      await loadServerCertificate();
      isCertificateLoaded = true;
    }
    List<bool> future = await Future.wait<bool>([
      _initPos(),
      Future.delayed(const Duration(seconds: 2), () => true),
    ]);
    if (future[0] && future[1] && widget.redirect) {
      Navigator.pushReplacementNamed(context, 'wrapper');
    }
  }

  Future<void> _validateKeyInitialization() async {
    bool keyExists = await cryptoDUKPTCheckKeyExists(1);
    if (keyExists) {
      print('Ya existe la llave');

      _tryKeyInitialization();
    } else {
      _tryKeyInitialization();
    }
  }

  Future<void> _tryKeyInitialization() async {
    // showCircularProgressDialog(context, 'Procesando');
    try {
      await _keyInitializationPharos();

      print('Llaves inicializadas');
    } on SocketException catch (e) {
      Navigator.pop(context);

      print('error ${e.message}');
    } on StateError catch (e) {
      Navigator.pop(context);
      print('error ${e.message}');
    } catch (e) {
      // Navigator.pop(context);
      print('error $e');
    }
  }

  Future<void> _keyInitializationPharos() async {
    AuthService authService = AuthService();
    //todo hacer cambio de mail dinamico dependiendo
    bool success = await authService.authenticateUser(
      "svazquez7@necsweb.com",
      "Sandra123!",
    );

    if (success) {
      print("Authentication success.");
    } else {
      print("Authentication failed.");
    }
    // creamos un objeto de "Capítulo X" para la sesión de inicialización de
    // llaves
    final capx = CapX(1);

    // solicitamos la llave de transporte encriptada mediante su
    // correspondiente llave RSA
    final tk =
        await capx.getEncryptedTransportKey("assets/capx/public_pharos.pem");
    // generamos el mensaje de solicitud para el host
    final pharosMsgKeyInit = await pharosGenerateKeyInitialization(
      cipheredTK: tk.keyData,
      kcv: tk.kcv,
    );
    print('Generar mensaje a pharos');
    print(pharosMsgKeyInit);
    final pharosResponse = await processKeyInitPharos(pharosMsgKeyInit);
    print('pharos responde $pharosResponse');

    final encryptedK0 = pharosResponse.encryptedNewKey;
    final ksn = pharosResponse.newKeyKsn;
    //await capx.loadEncryptedIPEK(ksn.toHexBytes(), encryptedK0.toHexBytes());

    // cargamos la llave fija del entorno de prueba
    // esta llave está encriptada con un KEK de valor '1D7BA112D144429260D2C219A6A80798'
    // la llave en claro es 'A66AB26590D3186E8A4C5A40D6F4F15D'

    //Carga de llaves en terminales de forma manual
    //cosas de dev
    //await loadTestKEK();
    try {
      await cryptoLoadIPEK(
        1,
        ksn.toHexBytes(),
        encryptedK0.toHexBytes(),
        kekIndex: 10,
      );
      var ksno = await cryptoDUKPTGetKSN(1);
      print("setksn: ${ksno!.toHexStr()}");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String label;
    if (_cardMsg == "") {
      label = AppLocalizations.of(context)!.loading;
    } else {
      label = _cardMsg;
    }

    final queryData = MediaQuery.of(context);
    double padding = 15.0;
    final screenHeight = queryData.size.height - (padding * 2);
    final screenWidth = queryData.size.width - (padding * 2);

    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: rawKeypadHandler(
        context,
        onEscape: () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
      ),
      child: Container(
          constraints:
              BoxConstraints(maxWidth: screenWidth, maxHeight: screenHeight),
          color: const Color(0xFF03045E),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: screenHeight / 6),
                height: screenHeight / 3,
                width: 400.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/logo_agnostiko_blanco_eslogan.png',
                    ),
                  ),
                  shape: BoxShape.rectangle,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                color: const Color(0xFF03045E),
                child: ListTile(
                  title: Center(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Visibility(
                visible: !_visibility,
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 120,
                  //size: 150,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Visibility(
                visible: _visibility,
                child: SizedBox(
                  width: 150,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF03045E),
                      elevation: 10,
                      shadowColor: Colors.black45,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Colors.white,
                            width: 3,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      onTapButton();
                    },
                    child: Text(
                      _buttonTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          )
          //child:FlutterLogo(size:MediaQuery.of(context).size.height)
          ),
    );
  }
}
