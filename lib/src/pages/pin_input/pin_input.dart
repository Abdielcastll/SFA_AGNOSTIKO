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

  String? _pinError;

  TransactionArgs? transactionArgs;
  int? remainingPinTries;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _emvEventLoop());
  }

  @override
  void dispose() {
    transactionArgs = null;
    remainingPinTries = null;
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
            style: TextStyle(fontSize: 40),
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
      _pinError = "wrongPIN";
    }

    final pinEntryStream = startOfflinePinEntry(PinEntryParameters(
      timeout: 60,
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("pinCancelled"),
          ));
        } else if (event is PinTimeoutEvent) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("pinTimeout"),
          ));
        } else if (event is PinInputChangedEvent) {
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
