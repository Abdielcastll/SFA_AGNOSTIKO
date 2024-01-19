import 'dart:async';

import 'package:flutter/material.dart';
import 'package:agnostiko/agnostiko.dart';

import '../../../dialogs/cancel_transaction_dialog.dart';
import '../../models/transaction_args.dart';

class PinInputView extends StatefulWidget {
  static String route = "/pinInput";

  @override
  _PinInputViewState createState() => _PinInputViewState();
}

class _PinInputViewState extends State<PinInputView> {
  final _pinTextController = TextEditingController();

  Timer? countdownTimer;
  Duration timerDuration = const Duration(seconds: 30);

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  // Step 5
  void resetTimer() {
    stopTimer();
    setState(() => timerDuration = const Duration(seconds: 30));
    startTimer();
  }

  // Step 6
  void setCountDown() async {
    const reduceSecondsBy = 1;
    final seconds = timerDuration.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      setState(() {
        countdownTimer!.cancel();
      });
      await cancelPinEntry();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Tiempo de espera agotado en PIN"),
      ));
    } else {
      setState(() {
        timerDuration = Duration(seconds: seconds);
      });
    }
  }

  String? _pinError;

  TransactionArgs? transactionArgs;
  int? remainingPinTries;

  @override
  void initState() {
    super.initState();
    // startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) => _emvEventLoop());
  }

  @override
  void dispose() {
    transactionArgs = null;
    remainingPinTries = null;
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (transactionArgs == null) {
      transactionArgs =
          ModalRoute.of(context)?.settings.arguments as TransactionArgs;

      remainingPinTries = transactionArgs?.remainingPinTries;
    }

    String appBarText;
    if (transactionArgs?.emvTransactionType == EmvTransactionType.Refund) {
      appBarText = "refund";
    } else {
      appBarText = "sale";
    }

    return WillPopScope(
      onWillPop: cancelTransactionDialogFn(context),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(appBarText),
        ),
        body: Column(children: [
          TextField(
            autofocus: true,
            controller: _pinTextController,
            decoration: InputDecoration(
              labelText: "PIN ($remainingPinTries)",
              errorText: _pinError,
            ),
            obscureText: true,
            readOnly: true,
            style: const TextStyle(fontSize: 40),
            textAlign: TextAlign.center,
          ),
          Expanded(child: Container()),
        ]),
      ),
    );
  }

  void _emvEventLoop() async {
    final emvStream = transactionArgs?.emvStream;
    if (emvStream == null) return;

    try {
      await for (IEmvEvent event in emvStream) {
        if (!mounted) return; // si la pantalla no está activa cancelamos

        if (event is EmvPinRequestedEvent) {
          await _onPinRequested(event);
        }
      }
    } catch (e) {
      print("EMV Error: $e");
    }
  }

  Future<void> _onPinRequested(EmvPinRequestedEvent event) async {
    // cuando cambie el valor de intentos de PIN restantes...
    if (this.remainingPinTries != event.remainingTries) {
      setState(() {
        this.remainingPinTries = event.remainingTries;
      });
      _pinError = "PIN Erroneo";
    }

    startTimer();
    print('startTimer');

    final pinEntryStream = startOfflinePinEntry(PinEntryParameters(
      timeout: 120,
      pinRSAData: event.pinRSAData,
      allowedLength: [4, 8, 23, 13, 6],
    ));

    MPOSController.instance.showMessage("PIN:");
    try {
      await for (final event in pinEntryStream) {
        if (!mounted) return;

        if (event is PinFinishedEvent) {
          return emvCompletePin(event.pinResultSw);
        } else if (event is PinCancelledEvent) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("PIN Cancelado"),
          ));
        } else if (event is PinTimeoutEvent) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Tiempo de espera agotado en PIN"),
          ));
        } else if (event is PinInputChangedEvent) {
          resetTimer();
          String bullets = "";
          for (int i = 0; i < event.inputLength; i++) {
            bullets += "*";
          }
          this._pinTextController.text = bullets;
          MPOSController.instance.showMessage("PIN:\n$bullets");
        } else {}
      }
    } catch (e) {
      print("PIN Error: $e");
    }
    // si llegamos aquí, hubo cancelación, timeout o error
    await cancelEmvTransaction();
    print("****************PIN ENTRY CLOSED*****************");
  }
}
