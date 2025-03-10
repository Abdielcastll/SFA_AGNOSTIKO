// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:agnostiko/agnostiko.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/core/constants/msi_constants.dart';
import 'package:pwa_sales2go_flutter/core/constants/transaction_result_constants.dart';
import 'package:pwa_sales2go_flutter/dialogs/auto_cancel_dialog.dart';
import 'package:pwa_sales2go_flutter/dialogs/confirm_dialog.dart';
import 'package:pwa_sales2go_flutter/dialogs/custom_alert_dialog.dart';
import 'package:pwa_sales2go_flutter/dialogs/try_again_dialog.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/data/datasources/payment_host_datasource_pharos.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/domain/entitites/bin_entitites/bin_response_entity.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/domain/repositories/payment_repository.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/presentation/dialogs/msi_dialog.dart';
import 'package:pwa_sales2go_flutter/src/models/enums/EUIStates.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/add_payment.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/utils/pinpad_conection.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

/* import '../../config/app_config.dart'; */
import '../../../dialogs/info_dialog.dart';
import '../../services/utils/emv.dart';
import '../../services/utils/counters.dart';
import '../../../pharos/void_response.dart';
import '../../../pharos/pharos.dart';
import '../../../dialogs/cancel_transaction_dialog.dart';
import '../../../dialogs/candidate_list_dialog.dart';
import '../../../dialogs/circular_progress_dialog.dart';
import '../../../dialogs/card_indicator_dialog.dart';
import '../../models/transaction_args.dart';
import '../../pages/emv_transaction_info/emv_transaction_info.dart';
import '../../pages/pin_input/pin_input.dart';
import '../../services/utils/keypad.dart';
import '../../services/utils/comm.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardInputView extends StatefulWidget {
  static String route = "/cardInput";

  @override
  _CardInputViewState createState() => _CardInputViewState();
}

class _CardInputViewState extends State<CardInputView> {
  TransactionArgs? transactionArgs;
  AddPaymentBodyAtt? paymentBody;

  bool _isFallback = false;

  /// Flag para evitar el reingreso a la pantalla de PIN
  bool _pinProcessFlag = false;

  /// Flag para evitar doble proceso de detección
  bool _detectionStarted = false;

  //Contador de intentos de lectura de chip
  int _cardTry = 0;
  bool _onlyChip = false;

  int errorCardCounter = 0;
  EUiStates state = EUiStates.INSERT_CARD;

  List<CardType> _supportedCardTypes = [];
  List<CardType> _expectedCardTypes = [];

  bool errorContactless = false;
  String activeMethods = "APROXIME/INSERTE/DESLICE";
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    closeCardReader();
    cancelEmvTransaction();
    super.dispose();
  }

  final pinpadManager = PinpadManager();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    transactionArgs ??= (ModalRoute.of(context)?.settings.arguments! as List)[0]
        as TransactionArgs;

    paymentBody ??= (ModalRoute.of(context)?.settings.arguments! as List)[2]
        as AddPaymentBodyAtt;

    if (_detectionStarted == false) {
      _detectionStarted = true;
      _supportedCardTypes = transactionArgs?.supportedCardTypes ?? [];
      _startCardDetection(_supportedCardTypes);
    }
    final amount = (transactionArgs?.amountInCents ?? 0) / 100;

    final _currencyFormat = NumberFormat.currency(locale: "en", symbol: "\$");

    String appBarText;
    TextStyle style;
    if (transactionArgs?.emvTransactionType == EmvTransactionType.Refund) {
      appBarText = "Reembolso";
      style = const TextStyle(color: Colors.red, fontSize: 32);
    } else {
      appBarText = "Venta";
      style = const TextStyle(color: Colors.green, fontSize: 32);
    }

    return WillPopScope(
      onWillPop: cancelTransactionDialogFn(
        context,
        paymentBody!.client,
        paymentBody!.invoiceNumber,
        true,
      ),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: rawKeypadHandler(
          context,
          onEscape: cancelTransactionDialogFn(
            context,
            paymentBody!.client,
            paymentBody!.invoiceNumber,
            true,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: themeProvider.myTheme.colorScheme.primary,
            foregroundColor: Colors.white,
            title: Text(appBarText),
          ),
          body: Column(mainAxisSize: MainAxisSize.max, children: [
            Expanded(child: Container()),
            Text(
              "Total de la compra:",
              style: style,
            ),
            Text(
              _currencyFormat.format(amount),
              style: style,
            ),
            const Text(""),
            _expectedCardsWidget,
            Expanded(child: Container()),
          ]),
        ),
      ),
    );
  }

  Widget get _expectedCardsWidget {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  activeMethods,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image(
                  image: AssetImage('assets/images/input_tarjeta.gif'),
                  width: 300,
                  height: 300,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(children: [
        Expanded(child: Container()),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "INSERTE/APROXIME/DESLICE",
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image(
                image: AssetImage('assets/images/input_tarjeta.gif'),
                width: 300,
                height: 300,
              ),
            ),
          ],
        ),
        Expanded(child: Container()),
      ]);
    }
  }

  Future<void> checkPinpadConnection() async {
    DeviceType deviceType = await getDeviceType();
    if (deviceType == DeviceType.PINPAD) {
      bool isConnected = await pinpadManager.isConnected();
      if (!isConnected) {
        if (globalRemoteConfig.onlyFullPaymentWithCard!) {
          await cancelPaymentProcess(
              paymentBody!.client, paymentBody!.invoiceNumber);
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error de conexion con el pinpad, vuelve a intentar"),
        ));
        Navigator.popUntil(context, (route) => route.isFirst == true);
      }
    }
  }

  void _startCardDetection(List<CardType> cardTypes) async {
    print('Start Detection');
    print(cardTypes);

    // Map card types to their respective strings
    List<String> methods = [];

    if (cardTypes.contains(CardType.IC)) {
      methods.add("INSERTA");
    }
    if (cardTypes.contains(CardType.Magnetic)) {
      methods.add("DESLIZA");
    }
    if (cardTypes.contains(CardType.RF)) {
      methods.add("ACERCA");
    }

    // Join methods with '/' if there are multiple
    setState(() {
      activeMethods = methods.join('/');
    });

    await checkPinpadConnection();
    // Si no hay tarjetas para leer es que llegamos a un punto de error
    if (cardTypes.isEmpty) {
      Navigator.popUntil(context, (route) => route.isFirst == true);
    }
    Stream<CardDetectedEvent> cardReaderStream;
    try {
      await closeCardReader();
      cardReaderStream = openCardReader(cardTypes: cardTypes, timeout: 40);
    } catch (e) {
      await closeCardReader();
      print('ERRROR OPEN $e');
      cardReaderStream = openCardReader(cardTypes: cardTypes, timeout: 40);
    }

    setState(() {
      state = (_onlyChip || !_supportedCardTypes.contains(CardType.RF))
          ? EUiStates.ONLY_CHIP
          : _isFallback
              ? EUiStates.SWEEP_CARD
              : EUiStates.INSERT_CARD;
      _expectedCardTypes = cardTypes;
      if (cardTypes.isNotEmpty &&
          cardTypes.length == 1 &&
          cardTypes.contains(CardType.Magnetic)) {
        state = EUiStates.SWEEP_CARD;
      }
    });

    try {
      print('try card reader');

      await for (final event in cardReaderStream) {
        print('card reader event: ${event.cardType}');
        // todo hacer caso para timeout de ir a emv result en vacio
        if (!mounted) {
          print('Not mounted');

          return;
        }
        if (event.cardType == CardType.Magnetic) {
          final iv = "0000000000000000".toHexBytes();
          final encryptedTracksData = await getDUKPTEncryptedTracksData(
            1,
            CipherMode.CBC,
            iv,
          );
          _onProcessing(EntryMode.Magstripe);
          await _onMagneticCard(encryptedTracksData);
        } else if (event.cardType == CardType.IC) {
          _onCardInserted();
          await _onICCard();
        } else if (event.cardType == CardType.RF) {
          _onCardInserted();
          await _onRFCard();
        }
      }
    } on ChipCardException {
      print('Chip exception');
      displayCustomDialog(
        dismissible: true,
        context: context,
        alertType: AlertType.USE_CHIP,
        icon: Icons.warning_amber,
        title: 'Alerta',
        messages: ['Su tarjeta tiene chip.', 'Por favor inserte tarjeta'],
        actionButton1: 'Aceptar',
      ).then((value) {
        if (_onlyChip) {
          _startCardDetection([CardType.IC]);
        } else {
          _startCardDetection(
            _supportedCardTypes
                .where((type) => type != CardType.Magnetic)
                .toList(),
          );
        }
      });
    } on TimeoutException {
      print("timeout");
      if (globalRemoteConfig.onlyFullPaymentWithCard!) {
        await cancelPaymentProcess(
            paymentBody!.client, paymentBody!.invoiceNumber);
      }
      await closeCardReader();
      transactionArgs!.responseCode = "88"; //vamos a usar 88 para timeout
      final arguments = (ModalRoute.of(context)?.settings.arguments! as List);
      transactionArgs?.stan = await getSTANCounterAndIncrement();
      Navigator.pushReplacementNamed(context, EmvTransactionInfoView.route,
          arguments: [
            transactionArgs,
            if (arguments.length >= 2) arguments[1] else null,
            if (arguments.length >= 3) arguments[2] else null,
            if (arguments.length >= 4) arguments[3] else null
          ]);
    } catch (e, stackTrace) {
      print('aaaaaaaaaaa');
      print('catch card Detection: $e');
      if (e.toString().contains("CardReaderCancel")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lectura cancelada"),
          ),
        );
        if (globalRemoteConfig.onlyFullPaymentWithCard!) {
          await cancelPaymentProcess(
              paymentBody!.client, paymentBody!.invoiceNumber);
          Navigator.popUntil(context, (route) => route.isFirst == true);
          return;
        } else {
          Navigator.popUntil(context, (route) => route.isFirst == true);
          return;
        }
      } else if (errorCardCounter < 2) {
        errorCardCounter++;
        displayCustomDialog(
          dismissible: true,
          context: context,
          alertType: AlertType.CARD_READER_ERROR,
          icon: Icons.warning_amber,
          title: 'Error en lectura',
          messages: ['Reintente ingresando la tarjeta por CHIP'],
          actionButton1: 'Aceptar',
        ).then((value) {
          setState(() {
            _onlyChip = true;
          });
          _startCardDetection([CardType.IC, CardType.Magnetic]);
        });
      } else if (transactionArgs?.responseCode != '88') {
        print("deteccion2");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error en la deteccion"),
          ),
        );
        await closeCardReader();
        transactionArgs!.responseCode =
            "999"; //vamos a usar 999 para error total
        final arguments = (ModalRoute.of(context)?.settings.arguments! as List);
        transactionArgs?.stan = await getSTANCounterAndIncrement();
        Navigator.pushReplacementNamed(context, EmvTransactionInfoView.route,
            arguments: [
              transactionArgs,
              if (arguments.length >= 2) arguments[1] else null,
              if (arguments.length >= 3) arguments[2] else null,
              if (arguments.length >= 4) arguments[3] else null
            ]);
      } else {
        print("Error: $e");
        print(stackTrace);

        if (globalRemoteConfig.onlyFullPaymentWithCard!) {
          await cancelPaymentProcess(
              paymentBody!.client, paymentBody!.invoiceNumber);
          Navigator.pop(context);
          Navigator.pop(context);
          tryAgainDialog(context);
        } else {
          print("deteccion1");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error en la deteccion"),
            ),
          );
          Navigator.popUntil(context, (route) => route.isFirst == true);
        }
      }
    }

    await closeCardReader();
    print("****************CARD READER CLOSED*****************");
  }

  Future<void> _onICCard() async {
    transactionArgs?.entryMode = EntryMode.Contact;
    showCircularProgressDialog(
        context, AppLocalizations.of(context)!.pleaseWait);
    _runTransaction();
  }

  void Function(bool)? changeRFCardDialogFn;

  Future<void> _onRFCard() async {
    transactionArgs?.entryMode = EntryMode.Contactless;
    changeRFCardDialogFn = showCardIndicatorDialog(context, true);
    _runTransaction();
  }

  Future<void> _runTransaction() async {
    print('==> read_card_page::_runTransaction');

    final amount = transactionArgs?.amountInCents ?? 0;
    final sequenceCounter = await getSequenceCounterAndIncrement();
    //final sequenceCounter = 1;
    final params = EmvTransactionParameters(
      transactionType:
          transactionArgs?.emvTransactionType ?? EmvTransactionType.Goods,
      transactionSequenceCounter: sequenceCounter,
      amount: amount,
    );
    _pinProcessFlag = false;
    final transactionStream = startEmvTransaction(params);
    transactionArgs?.emvStream = transactionStream;
    // ? Si ya se está ejecutando una transacción, se debe asignar el STAN
    transactionArgs?.stan = await getSTANCounterAndIncrement();
    debugPrint("STAN de la transacción ${transactionArgs?.stan}");

    try {
      await for (final event in transactionStream) {
        _onProcessing(transactionArgs!.entryMode!);
        print('* _runTransaction:::_runTransaction.event [$event]');
        if (!mounted) return; // si la pantalla no está activa cancelamos

        if (event is EmvCandidateListEvent) {
          final selectedIndex =
              await showCandidateListDialog(context, event.candidateList) ?? 0;
          emvSelectCandidate(selectedIndex);
        } else if (event is EmvAppSelectedEvent) {
          print('app select evebt');

          await _onAppSelected(event);
        } else if (event is EmvPinRequestedEvent) {
          print('pin  requested evebt');

          await _onPinRequested(event);
        } else if (event is EmvPinpadEntryEvent) {
          print('pinpad pin evebt');

          await _onPinpadEntry();
        } else if (event is EmvOnlineRequestedEvent) {
          print('emv online evebt');

          await _onOnlineRequested(event);
        } else if (event is EmvFinishedEvent) {
          print('emv finished evebt');

          // throw Exception("Generic exception just to track the '999' error");
          return _onEmvFinished(event);
        }
      }
    } on SocketException catch (e) {
      return _processEMVException(e, "Error de conexion");
    } catch (e) {
      print('_runTransaction_otherError');
      print(e);
      return _processEMVException(e, "Error interno");
    }
    print('se cancela en pantalla card input');

    if (!mounted) return;
    // si llegamos aquí es porque se canceló la transacción en esta pantalla

    if (state != EUiStates.NOT_REMOVE_CARD) {
      if (globalRemoteConfig.onlyFullPaymentWithCard!) {
        await cancelPaymentProcess(
            paymentBody!.client, paymentBody!.invoiceNumber);
      }
      Navigator.popUntil(context, (route) => route.isFirst == true);
    }
  }

  void _processEMVException(dynamic e, String message) async {
    await cancelEmvTransaction();

    print('Error EMV $e');
    if (!mounted) return; // si la pantalla no está activa cancelamos
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
    final deviceType = await getDeviceType();
    MPOSController.instance.showHomeScreen();
    String? pan = '';
    try {
      pan = (await EmvModule.instance.getTagValue(0x57))
          ?.toHexStr()
          .split('d')[0];
    } catch (e) {
      await emvPreTransaction(true);
      print("sub error: $e");
    }
    transactionArgs?.pan ??= pan;
    transactionArgs?.responseCode = '999';
    // en caso de error, nos movemos a la pantalla de cierre
    final arguments = (ModalRoute.of(context)?.settings.arguments! as List);
    if (globalRemoteConfig.onlyFullPaymentWithCard!) {
      await cancelPaymentProcess(
        paymentBody!.client,
        paymentBody!.invoiceNumber,
      );
    }
    if (deviceType == DeviceType.PINPAD) {
      showPinpadHome();
    }
    await closeCardReader();
    Navigator.pushReplacementNamed(
      context,
      EmvTransactionInfoView.route,
      arguments: [
        transactionArgs,
        if (arguments.length >= 2) arguments[1] else null,
        if (arguments.length >= 3) arguments[2] else null,
        if (arguments.length >= 4) arguments[3] else null
      ],
    );
  }

  Future<void> _onAppSelected(EmvAppSelectedEvent event) async {
    print("APP SELECTED:");
    print("'${event.appLabel}' - ${event.selectedAid.toHexStr()}");
    await emvConfirmAppSelected();
  }

  Future<void> _onPinRequested(EmvPinRequestedEvent event) async {
    if (_pinProcessFlag) return;

    _pinProcessFlag = true;
    transactionArgs?.remainingPinTries = event.remainingTries;
    Navigator.pop(context); // cerramos el popup de progreso
    Navigator.pushNamed(
      context,
      PinInputView.route,
      arguments: [transactionArgs, paymentBody],
    );
  }

  Future<void> _onPinpadEntry() async {
    print('pinpad entry');
    Navigator.pop(context);
    showCircularProgressDialog(
      context,
      "Por favor ingrese el PIN en el Pinpad.",
    );
    final pinEntryParameters = PinEntryParameters(
      timeout: 50,
      pinRSAData: null,
      allowedLength: [0, 4, 8, 23, 13, 6],
    );
    try {
      print('try pinpad entry');

      await emvConfirmPinpadEntry(pinEntryParameters);
      return;
    } catch (e) {
      print("PIN Error: $e");
    }
    print('acabo pinpad entry en cancelacion timeout o error');
    await checkPinpadConnection();
    await cancelEmvTransaction();
    if (globalRemoteConfig.onlyFullPaymentWithCard!) {
      await cancelPaymentProcess(
          paymentBody!.client, paymentBody!.invoiceNumber);
    }
    print("****************PIN ENTRY CLOSED*****************");
  }

  getCurrencyFromPaymentBody() {
    final addPaymentBody = (ModalRoute.of(context)?.settings.arguments!
        as List)[2] as AddPaymentBodyAtt;

    if (addPaymentBody.currency.toUpperCase().contains('USD')) {
      return '840';
    }
    if (addPaymentBody.currency.toUpperCase().contains('EUR')) {
      return '978';
    }
    if (addPaymentBody.currency.toUpperCase().contains('MXN')) {
      return '484';
    }
    return '484';
  }

  _onCardInserted() {
    print('_onCardInserted Entro');
    setState(() {
      state = EUiStates.NOT_REMOVE_CARD;
    });
  }

  _onProcessing(EntryMode entryMode) {
    print('_onProcessing Entro');
    setState(() {
      state = EUiStates.PROCESSING;
    });
  }

  Future<void> _onOnlineRequested(EmvOnlineRequestedEvent event) async {
    final transactionArgs = this.transactionArgs;

    // si la transacción es CTLSS, hay que esperar a que se retire la tarjeta
    if (transactionArgs?.entryMode == EntryMode.Contactless) {
      changeRFCardDialogFn!(false); // Cambiamos el semáforo a rojo
      await waitUntilRFCardRemoved();
    }

    Navigator.pop(context); // cerramos el popup anterior

    MPOSController.instance
        .showMessage(AppLocalizations.of(context)!.processing);
    showCircularProgressDialog(
        context, AppLocalizations.of(context)!.processing);

    String? responseCode;
    if (transactionArgs != null) {
      // si la transacción solicita ir online, ya tuvimos el 1st GENERATE AC
      transactionArgs.infoTags = await loadInfoTags();
      transactionArgs.firstGenerateTags = await emvGetGenerateCommandTags();

      final currency =
          transactionArgs.currencyCode ?? getCurrencyFromPaymentBody();

      transactionArgs.currencyCode = currency;

      // TODO Este PaymentRepository no debería quedarse aquí
      debugPrint("Check if msi is available");
      final PaymentRepository payment =
          PaymentRepositoryImpl(datasource: PaymentHostDatasourcePharos());
      final BinResponseEntity? binMsi =
          await payment.getAvailableMsi(transactionArgs);
      if (binMsi != null && binMsi.goToMsi) {
        debugPrint("Go to MSI");
        await showConfirmDialog(
          context,
          title: MSIConstants.msiAvailable,
          message: MSIConstants.msiDescription,
          textAccept: MSIConstants.wantPromo,
          onAccept: () async => await showMSIDialog(
              transProvider: transactionArgs,
              binResponse: binMsi,
              context: context),
          textCancel: MSIConstants.noThanks,
          onCancel: () => Navigator.pop(context),
        );
      }
      final pharosMsg = await pharosGenerateSaleMsg(transactionArgs, currency);
      print("PHAROS MSG: ${jsonEncode(pharosMsg)}");

      try {
        final response = await processSalePharos(pharosMsg);
        responseCode = response.resultCode;
        print('responseCode');
        print(responseCode);
        transactionArgs.referenceNumber = response.referenceNumber;
        transactionArgs.authCode = response.authCode;
        transactionArgs.responseCode = response.resultCode;

        await emvCompleteOnline(EmvOnlineResponse(
          authorisationResponseCode: responseCode,
        ));
      } catch (e) {
        final stan = transactionArgs.stan;
        print('errorSale');
        print(e.toString());
        if (stan != null) {
          final response = await runVoidPharos(stan);
          transactionArgs.responseCode = response.resultCode;
          Navigator.pop(context);

          await closeCardReader();
          await emvCompleteOnline(EmvOnlineResponse(
            authorisationResponseCode: '01',
          ));
          await cancelEmvTransaction();

          if (globalRemoteConfig.onlyFullPaymentWithCard!) {
            await cancelPaymentProcess(
              paymentBody!.client,
              paymentBody!.invoiceNumber,
            );
          }
          final arguments =
              (ModalRoute.of(context)?.settings.arguments! as List);
          Navigator.pushReplacementNamed(context, EmvTransactionInfoView.route,
              arguments: [
                transactionArgs,
                if (arguments.length >= 2) arguments[1] else null,
                if (arguments.length >= 3) arguments[2] else null,
                if (arguments.length >= 4) arguments[3] else null
              ]);
        } else {
          Navigator.pop(context);
          throw StateError(
              "La venta falló. El stan no puede ser un valor nulo para el reverso");
        }
      }
    }
  }

  Future<PharosVoidResponse> runVoidPharos(int stan) async {
    print('Tiempo de espera excedido para la venta');
    final pharosVoidMsg = await pharosGenerateVoidMsg(stan.toString());
    print("Pharos Void MSG: $pharosVoidMsg");
    final response = await processVoidPharos(pharosVoidMsg);
    return response;
  }

  void _onEmvFinished(EmvFinishedEvent event) async {
    print('==> read_card_page::_onEmvFinished Entro');
    print(event.transactionInfo.result);

    final transactionArgs = this.transactionArgs;
    transactionArgs?.transactionInfo = event.transactionInfo;

    // si la transacción es CTLSS, y no se fue online hay que esperar a que se retire la tarjeta
    if (transactionArgs?.entryMode == EntryMode.Contactless &&
        !event.transactionInfo.onlineRequested) {
      changeRFCardDialogFn!(false); // Cambiamos el semáforo a rojo
      await waitUntilRFCardRemoved();
    }

    Navigator.pop(context); // quitamos el popup de progreso
    if (event.transactionInfo.result == EmvTransactionResult.Fallback) {
      transactionArgs?.isFallback = true;
      setState(() {
        _cardTry++;
        _isFallback = _cardTry < 3 ? false : true;
      });
      displayCustomDialog(
        dismissible: false,
        context: context,
        alertType: AlertType.FALLBACK_ERROR,
        icon: Icons.warning_amber,
        title: 'Falla lectura chip',
        messages: [
          'Retire su Tarjeta',
          _cardTry < 3
              ? 'Reintente Insertando su Tarjeta'
              : 'Deslice su Tarjeta'
        ],
      ).then((value) {
        switch (_cardTry) {
          case 1:
            _startCardDetection(_supportedCardTypes
                .where((item) =>
                    (item == CardType.IC || item == CardType.Magnetic))
                .toList());
            break;
          case 3:
            _startCardDetection(_supportedCardTypes
                .where((type) => type == CardType.Magnetic)
                .toList());
            break;
          default:
            _startCardDetection(
              _supportedCardTypes.toList(),
            );
        }
      });
    } else {
      if (event.transactionInfo.result == EmvTransactionResult.PinTimeout) {
        if (globalRemoteConfig.onlyFullPaymentWithCard!) {
          await cancelPaymentProcess(
            paymentBody!.client,
            paymentBody!.invoiceNumber,
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Tiempo de ingreso de pin agotado"),
        ));
        Navigator.popUntil(context, (route) => route.isFirst == true);
      } else if (event.transactionInfo.result == EmvTransactionResult.Denied) {
        if (globalRemoteConfig.onlyFullPaymentWithCard!) {
          await cancelPaymentProcess(
            paymentBody!.client,
            paymentBody!.invoiceNumber,
          );
        }
      } else if (event.transactionInfo.result == EmvTransactionResult.Fail) {
        if (globalRemoteConfig.onlyFullPaymentWithCard!) {
          await cancelPaymentProcess(
            paymentBody!.client,
            paymentBody!.invoiceNumber,
          );
        }
      } else if (event.transactionInfo.result ==
          EmvTransactionResult.CmdError) {
        if (globalRemoteConfig.onlyFullPaymentWithCard!) {
          await cancelPaymentProcess(
            paymentBody!.client,
            paymentBody!.invoiceNumber,
          );
        }
      }

      if (event.transactionInfo.onlineRequested &&
          !event.transactionInfo.isContactless) {
        // si la transacción terminó tras irse online, ya el 1st GENERATE AC
        // debería haberse guardado y necesitamos guardar el 2nd GENERATE AC
        // si no es Contactless
        transactionArgs?.secondGenerateTags = await emvGetGenerateCommandTags();
      } else {
        // si la transacción terminó sin irse online, solo hubo 1st GENERATE AC
        transactionArgs?.infoTags = await loadInfoTags();
        transactionArgs?.firstGenerateTags = await emvGetGenerateCommandTags();
      }
      transactionArgs?.pan ??= (await EmvModule.instance.getTagValue(0x57))
          ?.toHexStr()
          .split('d')[0];

      final arguments = (ModalRoute.of(context)?.settings.arguments! as List);
      final deviceType = await getDeviceType();
      if (deviceType == DeviceType.PINPAD) {
        showPinpadHome();
      } else {
        MPOSController.instance.showHomeScreen();
      }
      await closeCardReader();
      Navigator.pushReplacementNamed(context, EmvTransactionInfoView.route,
          arguments: [
            transactionArgs,
            if (arguments.length >= 2) arguments[1] else null,
            if (arguments.length >= 3) arguments[2] else null,
            if (arguments.length >= 4) arguments[3] else null
          ]);
    }
  }

  Future<void> _onMagneticCard(DUKPTEncryptedTracksData? tracksData) async {
    if (!mounted) return;

    transactionArgs?.entryMode = EntryMode.Magstripe;

    final serviceCode = tracksData?.serviceCode;
    if (serviceCode == null) {
      throw StateError("service code missing");
    }
    final isChipCard =
        serviceCode.startsWith("2") || serviceCode.startsWith("6");

    if (!_isFallback &&
        isChipCard &&
        _supportedCardTypes.contains(CardType.IC)) {
      throw ChipCardException();
    } else {
      // Deshabilitado el ingreso de CVV ya que (al menos por ahora) no hay
      // forma segura de ingresar este dato en MPOS
      //_goToCvvInput();
      _doMagneticStripeSale();
    }
  }

  /* void _goToCvvInput() {
    Navigator.pushReplacementNamed(context, CvvInputView.route,
        arguments: transactionArgs);
  } */

  void _doMagneticStripeSale() async {
    final transactionArgs = this.transactionArgs;
    if (transactionArgs == null) return;

    showCircularProgressDialog(
        context, AppLocalizations.of(context)!.processing);

    final currency = getCurrencyFromPaymentBody();

    final pharosMsg = await pharosGenerateSaleMsg(transactionArgs, currency);

    print("PHAROS MSG: ${jsonEncode(pharosMsg)}");
    final response = await processSalePharos(pharosMsg);
    String responseCode = response.resultCode;
    print('responseCode maag');
    print(responseCode);
    transactionArgs.referenceNumber = response.referenceNumber;
    transactionArgs.authCode = response.authCode;
    transactionArgs.responseCode = response.resultCode;
    transactionArgs.transactionInfo = EmvTransactionInfo(
      result: responseCode == '00'
          ? EmvTransactionResult.Approved
          : EmvTransactionResult.Denied,
      pinRequested: false,
      onlineRequested: true,
      scriptResults: Uint8List(0),
      isContactless: false,
    );
    await emvCompleteOnline(EmvOnlineResponse(
      authorisationResponseCode: responseCode,
    ));
    Navigator.pop(context);

    final arguments = (ModalRoute.of(context)?.settings.arguments! as List);
    final deviceType = await getDeviceType();
    if (deviceType == DeviceType.PINPAD) {
      showPinpadHome();
    } else {
      MPOSController.instance.showHomeScreen();
    }
    await closeCardReader();
    Navigator.pushReplacementNamed(context, EmvTransactionInfoView.route,
        arguments: [
          transactionArgs,
          if (arguments.length >= 2) arguments[1] else null,
          if (arguments.length >= 3) arguments[2] else null,
          if (arguments.length >= 4) arguments[3] else null
        ]);
  }
}

/// Error para indicar que se está utilizando banda con una tarjeta de chip.
class ChipCardException implements Exception {
  String toString() => 'ChipCardException';
}
