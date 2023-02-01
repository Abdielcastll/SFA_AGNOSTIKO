import 'package:agnostiko/agnostiko.dart';
import 'package:pwa_sales2go_flutter/src/models/account_balance_model.dart';
import 'dart:typed_data';
import '../services/utils/emv.dart';

enum EntryMode {
  Manual,
  Magstripe,
  Contact,
  Contactless,
}

class TransactionArgs {
  final PlatformInfo platformInfo;

  bool showNumericKeyboard = true;
  List<CardType> supportedCardTypes;
  EntryMode entryMode;
  bool isFallback = false;
  int emvTransactionType;

  int? amountInCents;
  String? pan;
  String? expDate;
  String? cvv;
  String? clearTrack1;
  String? clearTrack2;
  int? stan;

  Stream<dynamic>? emvStream;

  int? remainingPinTries;

  /// Aquí seteamos los tags relevantes tras el comando 1st GENERATE AC
  Map<int, Uint8List?>? firstGenerateTags;

  /// Aquí seteamos los tags relevantes tras el comando 2nd GENERATE AC
  Map<int, Uint8List?>? secondGenerateTags;

  InfoTags? infoTags;

  EmvTransactionInfo? transactionInfo;

  Invoices? invoice;

  TransactionArgs({
    required this.platformInfo,
    required this.entryMode,
    required this.showNumericKeyboard,
    required this.supportedCardTypes,
    required this.emvTransactionType,
    this.amountInCents,
    this.pan,
    this.expDate,
    this.cvv,
    this.stan,
  });
}
