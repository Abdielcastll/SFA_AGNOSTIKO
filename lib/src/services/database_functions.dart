import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/models/transaction_args.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';

import '../models/user_rol_model.dart';

// Funciones de Visitas

Future createVisitData(
  String userUid,
  String clientDocumentId,
  DateTime date,
) async {
  print('////// CREAR VISITA EN PROCESO /////');
  final lastModified = <String, dynamic>{
    'timestamp': Timestamp.now(),
    'usuario': FirebaseFirestore.instance.collection('usuarios').doc(userUid)
  };

  print(false);
  print(FirebaseFirestore.instance.collection('cliente').doc(clientDocumentId));
  print(false);
  print(FirebaseFirestore.instance.collection('usuarios').doc(userUid));
  print(Timestamp.fromDate(date));
  print(false);
  print(false);
  print(false);
  print(Timestamp.fromDate(DateTime.now()));
  print(Map<String, dynamic>.from(lastModified));
  print(FirebaseFirestore.instance.collection('usuarios').doc(userUid));

  return await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(userUid)
      .collection('visitas')
      .doc()
      .set({
    'cancelada': false,
    'cliente':
        FirebaseFirestore.instance.collection('cliente').doc(clientDocumentId),
    'completada': false,
    'creadoPor': FirebaseFirestore.instance.collection('usuarios').doc(userUid),
    'fecha': Timestamp.fromDate(date),
    'noCobranza': false,
    'noPedido': false,
    'noVisita': false,
    'timestrampRegistro': Timestamp.fromDate(DateTime.now()),
    'ultima modificacion': Map<String, dynamic>.from(lastModified),
    'vendedor': FirebaseFirestore.instance.collection('usuarios').doc(userUid),
  });
}

Future updateVisitData(
  String docId,
  String? status,
  String uid,
  String? commentary,
  context,
) async {
  print('// ACTUALIZAR ESTADO DE LA VISITA //');
  bool isCompleted = false;
  bool isCancelled = false;
  if (status != null) {
    if (status == AppLocalizations.of(context)!.completed) {
      isCompleted = true;
    } else if (status == AppLocalizations.of(context)!.canceled) {
      isCancelled = true;
    }
  } else if (status == null) {
    isCompleted = false;
    isCancelled = false;
  }
  commentary ??= 'No hay comentario';
  return await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(uid)
      .collection('visitas')
      .doc(docId)
      .update({
    'comentario': commentary,
    'cancelada': isCancelled,
    'completada': isCompleted,
  });
}

Future deleteVisit(
  String docId,
  String uid,
) async {
  print('Borrar Visita');
  return await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(uid)
      .collection('visitas')
      .doc(docId)
      .delete();
}

// Funciones de Pedidos

Future createOrder(
  Clients? client,
  String? userUid,
  String? commentary,
  double? masterDiscount,
  List<ShoppingCartProduct> shoppingCart,
  String? negotiation,
  String? deliveryAddress,
  DateTime today,
  double? taxTotal,
  numberOrder,
  double subTotal,
  double totalOfTheOrder,
  int? discountPercentage,
  bool? reduceStock,
) async {
  print('/// CREAR PEDIDO ///');

  final List quantitiesList = [];
  final List productsIds = [];
  final List<Map<dynamic, dynamic>> products = [];

  final Map<String, dynamic> productsStock = {};

  shoppingCart.forEach((element) {
    quantitiesList.add(element.productQuantity);
    productsIds.add(element.code);
    products.add({
      'cantidad': element.productQuantity?.toInt() ?? 0,
      'codigo': element.code?.toString() ?? 'NaN',
      'id': element.code?.toString() ?? 'NaN',
      'idListaDePrecios': client?.prices ?? 'NaN',
      'monto': double.parse((Decimal.parse(element.totalAmount.toString()) *
              Decimal.parse(element.productQuantity.toString()))
          .toString()),
      'nombre': element.name?.toString() ?? 'NaN',
      'precioUnitario': double.parse(element.unitPrice ?? '0.0'),
      'urlFoto': '',
    });
    final productQuantity = <String, dynamic>{
      '${element.code}': element.productQuantity,
    };
    productsStock.addEntries(productQuantity.entries);
  });
  print('productsStock: $productsStock');
  print('Cantidades: $quantitiesList');

  // REDUCE STOCK ON DATABASE

  if (reduceStock == false) {
    final DocumentReference stockPath =
        FirebaseFirestore.instance.collection('stock').doc('productos');

    Map<String, dynamic> currentStock = {};

    await stockPath.get().then(
      (doc) {
        currentStock = doc.data().toString().contains('valores')
            ? doc.get('valores')
            : {'0': 0};
      },
    );
    productsStock.forEach((key, value) async {
      int newValue = (currentStock[key] - value);
      if (newValue <= 0) {
        await stockPath.update({
          'valores.$key': 0,
        });
      } else {
        await stockPath.update({
          'valores.$key': (currentStock[key] - value),
        });
      }
    });
  }
  // GET EXCHANGE RATES

  List<Coin> coins = [];
  await coinCollection.get().then((element) {
    return element.docs.forEach((doc) {
      Coin coin = Coin(
        code: doc.data().toString().contains('codigo')
            ? doc.get('codigo')
            : 'USD',
        exchangeRatio: doc.data().toString().contains('tasaDeCambio')
            ? doc.get('tasaDeCambio')
            : 1,
      );
      coins.add(coin);
    });
  });

  final exchangeRates = getExchangesRatesTest(coins);
  print('exchangeRates: $exchangeRates');

  DocumentReference<Map<String, dynamic>> path = FirebaseFirestore.instance
      .collection('clientes')
      .doc(client!.clientDocumentId)
      .collection('pedidos')
      .doc();
  print('path de la factura: ${path.id}');

  return await path.set(
    {
      'cantidadesProductos': quantitiesList,
      'cliente': FirebaseFirestore.instance
          .collection('clientes')
          .doc(client.clientDocumentId),
      'comentario': commentary,
      'descuentoMaestro': masterDiscount,
      'tipoDeNegociacion': negotiation,
      'direccionEntrega': deliveryAddress == 'Fiscal'
          ? client.fiscalAdress
          : client.dispatchAdress,
      'facturacionFallida': false,
      'facturado': false,
      'fecha': Timestamp.fromDate(DateTime.now()),
      'fechaEntrega': Timestamp.fromDate(today),
      'idsProductos': productsIds,
      'impuesto': taxTotal,
      'ordenDeCompra': numberOrder ?? 0,
      'porcentajeDescuentoMaestro': client.masterDiscount,
      'porcentajeDescuentoAplicado': discountPercentage,
      'productos': products,
      'subtotal': subTotal,
      'tasasDeCambio': exchangeRates,
      'timestampRegistro': Timestamp.fromDate(DateTime.now()),
      'totalAPagar': totalOfTheOrder,
      'ultimaModificacion': Timestamp.fromDate(DateTime.now()),
      'vendedor':
          FirebaseFirestore.instance.collection('usuarios').doc(userUid),
    },
  ).whenComplete(
    () => print('//////////////// PEDIDO CREADO ////////////////'),
  );
}

Future deleteOrder(
  String docId,
  String clientId,
) async {
  print('Borrar pedido');
  return await FirebaseFirestore.instance
      .collection('clientes')
      .doc(clientId)
      .collection('pedidos')
      .doc(docId)
      .delete()
      .whenComplete(
        () => print('//////////////// PEDIDO BORRADO ////////////////'),
      );
}

// Funciones de Facturas

Future createInvoice(
  Client client,
  masterDiscount,
  orderDate,
  double? taxTotal,
  double totalOfTheOrder,
  String? orderDocumentID,
  subTotalOfTheOrder,
  userID,
) async {
  print('/// CREAR FACTURA ///');

  final clientID = FirebaseFirestore.instance
      .collection('clientes')
      .doc(client.clientDocumentId);
  final date = orderDate;

  var correlativeNumber = await FirebaseFirestore.instance
      .collection('config')
      .doc('contador_pedidos')
      .get()
      .then((value) {
    return value['numero'];
  });
  const isPaid = false;
  final payments = [];
  final order = FirebaseFirestore.instance
      .collection('clientes')
      .doc(client.clientDocumentId)
      .collection('pedidos')
      .doc(orderDocumentID);
  final discountPercentage = client.masterDiscount;
  final referenceCreditNote = [];
  final subTotal = subTotalOfTheOrder;
  final register = Timestamp.fromDate(DateTime.now());
  final lastModification = <String, dynamic>{
    'timestamp': register,
    'usuario': FirebaseFirestore.instance.collection('usuarios').doc(userID),
  };
  final seller = FirebaseFirestore.instance.collection('usuarios').doc(userID);

  // GET EXCHANGE RATES

  List<Coin> coins = [];
  await coinCollection.get().then((element) {
    return element.docs.forEach((doc) {
      Coin coin = Coin(
        code: doc.data().toString().contains('codigo')
            ? doc.get('codigo')
            : 'USD',
        exchangeRatio: doc.data().toString().contains('tasaDeCambio')
            ? doc.get('tasaDeCambio')
            : 1,
      );
      coins.add(coin);
    });
  });

  final exchangeRates = getExchangesRatesTest(coins);
  print('exchangeRates: $exchangeRates');

  print(clientID);
  print(masterDiscount);
  print(date);
  print(taxTotal);
  print(totalOfTheOrder);
  print(isPaid);
  print(payments);
  print(order);
  print(discountPercentage);
  print(referenceCreditNote);
  print(subTotal);
  print(register);
  print(lastModification);
  print(seller);
  print(correlativeNumber);
  print(correlativeNumber + 1);

  await FirebaseFirestore.instance
      .collection('clientes')
      .doc(client.clientDocumentId)
      .collection('pedidos')
      .doc(orderDocumentID)
      .update({
    'facturado': true,
    'nroCorrelativo': correlativeNumber + 1
  }).whenComplete(() async {
    return await FirebaseFirestore.instance
        .collection('clientes')
        .doc(client.clientDocumentId)
        .collection('facturas')
        .doc()
        .set({
      'cliente': clientID,
      'descuentoMaestro': masterDiscount,
      'fecha': Timestamp.fromDate(DateTime.now()),
      'impuesto': taxTotal,
      'montoTotal': totalOfTheOrder,
      'nroCorrelativo': correlativeNumber + 1,
      'pagada': isPaid,
      'pagos': payments,
      'pedido': order,
      'porcentajeDescuentoMaestro': discountPercentage,
      'porcentajeImpuesto': 16,
      'referenciaNotasCredito': referenceCreditNote,
      'subtotal': subTotal,
      'timestampRegistro': register,
      'ultimaModificacion': lastModification,
      'vendedor': seller,
      'tasasDeCambio': exchangeRates,
    }).whenComplete(() async {
      return await FirebaseFirestore.instance
          .collection('config')
          .doc('contador_pedidos')
          .update({'numero': correlativeNumber + 1});
    }).whenComplete(() =>
            Fluttertoast.showToast(msg: 'Factura ${correlativeNumber + 1}'));
  }).whenComplete(
    () => print('//////////////// FACTURA CREADA ////////////////'),
  );
}

//Registrar pagos de Tarjeta de Credito/Debito

Future registerDebitCreditCardPayment(
    InvoiceData data, int? stan, int referenceNumber, String currencyCode,
    {refund = false}) async {
  stan ??= 0;

  Client client = data.client;
  var invoiceDocumentID = data.invoiceDocumentID;
  var currency = data.currency;
  var amount = data.amount;
  var date = data.date;
  var coinExchangeRatio = data.coinExchangeRatio;

  print('/// Registrar pago por TARJETA en factura: $invoiceDocumentID ///');

  const cancelled = false;
  final selectedCurrency = currency.toString();
  const concillied = false;
  final timestampDate = Timestamp.fromDate(date);
  const method = 'Tarjeta Debito/Credito';
  final paidAmount = amount;

  final newPay = <String, dynamic>{
    'anulado': cancelled,
    'codigoMoneda': selectedCurrency,
    'conciliado': concillied,
    'fecha': timestampDate,
    'metodo': method,
    // 'monto': priceReturnToOriginal(paidAmount, currentCoin),
    'monto': priceDividedbyItsExchangeRatio(
        amount: paidAmount, exchange: coinExchangeRatio),
    'montoOriginal': paidAmount,
    'tasaDeCambio': data.coinExchangeRatio,
    'stan': stan,
    'referenceNumber': referenceNumber,
    'currencyCode': currencyCode,
  };

  if (refund) {
    newPay.addAll({'refund': true});
  }
  try {
    return await FirebaseFirestore.instance
        .collection('clientes')
        .doc(client.clientDocumentId)
        .collection('facturas')
        .doc(invoiceDocumentID)
        .update({
      'pagos': FieldValue.arrayUnion(
        [newPay],
      ),
    });
  } catch (e) {
    print(e);
  }
}

//Registrar pagos de cheques

Future registerBankCheckPayment({
  double? coinExchangeRatio,
  double? originalAmount,
  Client? client,
  String? invoiceDocumentID,
  String? currency,
  double? amount,
  double? totalOfTheOrder,
  String? currentCoin,
  String? bank,
  String? accountNumber,
  String? accountHolder,
  File? imageFile,
  DateTime? date,
  double? remaining,
}) async {
  String? banksDocumentsID;
  await FirebaseFirestore.instance
      .collection('bancos')
      .where('nombre', isEqualTo: bank)
      .get()
      .then((document) {
    document.docs.forEach((element) {
      banksDocumentsID = element.reference.id;
    });
  });

  const cancelled = false;
  final selectedCurrency = currency.toString();
  const concillied = false;
  final timestampDate = Timestamp.fromDate(date!);
  const method = 'Cheque';
  final paidAmount = amount;
  final selectedBank =
      FirebaseFirestore.instance.collection('bancos').doc(banksDocumentsID);
  final account = accountNumber;
  final holder = accountHolder;
  const nroCN = 0;
  final selectedExchangedRate = coinExchangeRatio;

  try {
    return await FirebaseFirestore.instance
        .collection('clientes')
        .doc(client!.clientDocumentId)
        .collection('facturas')
        .doc(invoiceDocumentID)
        .update({
      'pagos': FieldValue.arrayUnion(
        [
          <String, dynamic>{
            'anulado': cancelled,
            'codigoMoneda': selectedCurrency,
            'conciliado': concillied,
            'fecha': timestampDate,
            'metodo': method,
            'monto': paidAmount,
            'montoOriginal': originalAmount,
            'banco': FirebaseFirestore.instance
                .collection('bancos')
                .doc(banksDocumentsID),
            'nroCuenta': int.parse(accountNumber!),
            'titular': accountHolder,
            // 'nroNotaCredito': 0,
            'tasaDeCambio': selectedExchangedRate,
          },
        ],
      ),
    });
  } catch (e) {
    print(e);
  }
}

//Registrar pagos de cripto

Future registerCriptoPayment(
  Client client,
  invoiceDocumentID,
  currency,
  amount,
  totalOfTheOrder,
  transactionId,
  imageFile,
  date,
  remaining,
) async {
  print('/// Registrar pago en BTC en factura: $invoiceDocumentID ///');

  print('Datos Recibidos: ////////////////');
  print('client: $client');
  print('invoiceDocumentID: $invoiceDocumentID');
  print('currency: $currency');
  print('amount: $amount');
  print('totalOfTheOrder: $totalOfTheOrder');
  print('transactionId: $transactionId');
  print('imageFile: $imageFile');
  print('date: $date');
  print('remaining: $remaining');

  final Map<String, double> exchangeRate = {
    'BTC': 0.00011,
    'EUR': 0.89,
    'VED': 4.58,
    'MXN': 19.43
  };

  late var selectedCoinExchangeRate;

  if (currency.toString().contains('USD')) {
    selectedCoinExchangeRate = 1;
  } else if (currency.toString().contains('VED')) {
    selectedCoinExchangeRate = exchangeRate['VED'];
  } else if (currency.toString().contains('EUR')) {
    selectedCoinExchangeRate = exchangeRate['EUR'];
  } else if (currency.toString().contains('BTC')) {
    selectedCoinExchangeRate = exchangeRate['BTC'];
  } else if (currency.toString().contains('MXN')) {
    selectedCoinExchangeRate = exchangeRate['MXN'];
  }

  const nulled = false;
  final codeCurrency = currency.toString();
  const concillied = false;
  final paymentDate = Timestamp.fromDate(date);
  const method = 'Criptomoneda';
  final paymentAmount = double.parse(amount);
  final originalAmount = double.parse(amount);
  final transactionID = transactionId;
  final exancheRates = selectedCoinExchangeRate;

  print('Datos a Registrar: ////////////////');

  print('nulled: $nulled');
  print('codeCurrency: $codeCurrency');
  print('concillied: $concillied');
  print('paymentDate: $paymentDate');
  print('method: $method');
  print('paymentAmount: $paymentAmount');
  print('originalAmount: $originalAmount');
  print('transactionID: $transactionID');
  print('exancheRates: $exancheRates');

  // try {
  //   print('Pago registrado correctamente');
  //   return await FirebaseFirestore.instance
  //       .collection('clientes')
  //       .doc(client.clientDocumentId)
  //       .collection('facturas')
  //       .doc(invoiceDocumentID)
  //       .update({
  //     'pagos': FieldValue.arrayUnion(
  //       [
  //         <String, dynamic>{
  //           'anulado': nulled,
  //           'codigoMoneda': codeCurrency,
  //           'conciliado': concillied,
  //           'fecha': paymentDate,
  //           'metodo': method,
  //           'monto': paymentAmount,
  //           'montoOriginal': originalAmount,
  //           'idTransaccion': transactionID,
  //           'tasaDeCambio': selectedCoinExchangeRate,
  //         },
  //       ],
  //     ),
  //   }).whenComplete(() {
  //     print(
  //         'remaining de proceso: ${priceToCurrencySelected(remaining!, currency!)}');
  //     print('Amount de proceso: ${priceToCurrencySelected(amount!, currency)}');
  //     print(
  //         'restante total: ${priceToCurrencySelected(remaining!, currency!) - priceToCurrencySelected(amount!, currency)}');
  //     var total = priceToCurrencySelected(remaining!, currency!) -
  //         priceToCurrencySelected(amount!, currency);
  //     try {
  //       if (total <= 0) {
  //         FirebaseFirestore.instance
  //             .collection('clientes')
  //             .doc(client.clientDocumentId)
  //             .collection('facturas')
  //             .doc(invoiceDocumentID)
  //             .update({
  //           'pagada': true,
  //         });
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   });
  // } catch (e) {
  //   print(e);
  // }
}

//Registro de deposito
Future registerDepositPayment({
  double? coinExchangeRatio,
  double? originalAmount,
  Client? client,
  String? invoiceDocumentID,
  String? currency,
  double? amount,
  double? totalOfTheOrder,
  String? currentCoin,
  String? bank,
  String? accountNumber,
  String? voucherNumber,
  File? imageFile,
  DateTime? date,
  double? remaining,
}) async {
  print('/// Registrar deposito en factura: $invoiceDocumentID ///');

  print('Datos Recibidos: //////////////////////');
  print(' client: ${client!.name}');
  print('  invoiceDocumentID: $invoiceDocumentID');
  print('  currency: $currency');
  print('  amount: $amount');
  print('  totalOfTheOrder: $totalOfTheOrder');
  print('  currentCoin: $currentCoin');
  print('  bank: $bank');
  print('  accountNumber: $accountNumber');
  print('  voucherNumber: $voucherNumber');
  print('  imageFile: $imageFile');
  print('  date: $date');
  print('  remaining: $remaining');

  String? banksDocumentsID;
  await FirebaseFirestore.instance
      .collection('bancos')
      .where('nombre', isEqualTo: bank)
      .get()
      .then((document) {
    for (var element in document.docs) {
      banksDocumentsID = element.reference.id;
    }
  });

  // final convertedAmount =
  //     (doubleAmount / selectedCoinExchangeRate).toStringAsFixed(4);

  print('Datos a Registrar: //////////////////////////////');

  const cancelled = false;
  final selectedCurrency = currency.toString();
  const concillied = false;
  final timestampDate = Timestamp.fromDate(date!);
  const method = 'Deposito';
  final paidAmount = double.parse(amount.toString());
  final selectedBank =
      FirebaseFirestore.instance.collection('bancos').doc(banksDocumentsID);
  final account = int.parse(accountNumber!);
  final voucher = voucherNumber;
  final selectedExchangedRate = coinExchangeRatio;

  try {
    print('Pago registrado correctamente');
    return await FirebaseFirestore.instance
        .collection('clientes')
        .doc(client.clientDocumentId)
        .collection('facturas')
        .doc(invoiceDocumentID)
        .update({
      'pagos': FieldValue.arrayUnion(
        [
          <String, dynamic>{
            'anulado': cancelled,
            'codigoMoneda': selectedCurrency,
            'conciliado': concillied,
            'fecha': timestampDate,
            'metodo': method,
            'monto': paidAmount,
            'montoOriginal': originalAmount,
            'banco': selectedBank,
            'nroCuenta': account,
            'nroVoucher': voucher,
            // 'nroNotaCredito': 0,
            'tasaDeCambio': selectedExchangedRate,
          },
        ],
      ),
    });
  } catch (e) {
    print(e);
  }
}

//Registrar pagos de efectivo

Future registerMoneyPayment({
  double? coinExchangeRatio,
  double? originalAmount,
  Client? client,
  String? invoiceDocumentID,
  String? currency,
  double? amount,
  double? totalOfTheOrder,
  File? imageFile,
  DateTime? date,
}) async {
  print('Registrando dinero');
  try {
    return await FirebaseFirestore.instance
        .collection('clientes')
        .doc(client!.clientDocumentId)
        .collection('facturas')
        .doc(invoiceDocumentID)
        .update({
      'pagos': FieldValue.arrayUnion(
        [
          <String, dynamic>{
            'anulado': false,
            'codigoMoneda': currency,
            'conciliado': false,
            'fecha': Timestamp.now(),
            'metodo': 'Efectivo',
            'monto': amount,
            'montoOriginal': originalAmount,
            'tasaDeCambio': coinExchangeRatio,
          },
        ],
      ),
    });
  } catch (e) {
    print(e);
  }
}

//Registrar pagos de trasnferencias nacionales

Future registerTransferPayment({
  double? coinExchangeRatio,
  double? originalAmount,
  Client? client,
  String? invoiceDocumentID,
  String? currency,
  double? amount,
  double? totalOfTheOrder,
  String? currentCoin,
  String? bank,
  String? referenceId,
  File? imageFile,
  DateTime? date,
  double? remaining,
}) async {
  print('/// Registrar Trasnferencia en factura: $invoiceDocumentID ///');

  print('Datos recibidos:////////////////////////////////');

  print('  client: $client');
  print('  invoiceDocumentID: $invoiceDocumentID');
  print('  currency: $currency');
  print('  amount: $amount');
  print('  totalOfTheOrder: $totalOfTheOrder');
  print('  currentCoin: $currentCoin');
  print('  bank: $bank');
  print('  referenceId: $referenceId');
  print('  imageFile: $imageFile');
  print('  date: $date');
  print('  remaining: $remaining');

  String? banksDocumentsID;
  await FirebaseFirestore.instance
      .collection('bancos')
      .where('nombre', isEqualTo: bank)
      .get()
      .then((document) {
    document.docs.forEach((element) {
      banksDocumentsID = element.reference.id;
    });
  });

  print('Datos a registrar://///////////////////////////');
  const cancelled = false;
  final selectedCurrency = currency.toString();
  const concillied = false;
  final timestampDate = Timestamp.fromDate(date!);
  const method = 'Transferencia';
  final paidAmount = double.parse(amount.toString());
  final selectedBank =
      FirebaseFirestore.instance.collection('bancos').doc(banksDocumentsID);
  final referenceID = int.parse(referenceId!);
  final selectedExchangedRate = coinExchangeRatio;

  print('cancelled: $cancelled');
  print('selectedCurrency: $selectedCurrency');
  print('concillied: $concillied');
  print('timestampDate: $timestampDate');
  print('method: $method');
  print('paidAmount: $paidAmount');
  print('selectedBank: $selectedBank');
  print('referenceID: $referenceID');
  print('selectedExchangedRate: $selectedExchangedRate');

  try {
    return await FirebaseFirestore.instance
        .collection('clientes')
        .doc(client!.clientDocumentId)
        .collection('facturas')
        .doc(invoiceDocumentID)
        .update({
      'pagos': FieldValue.arrayUnion(
        [
          <String, dynamic>{
            'anulado': cancelled,
            'codigoMoneda': selectedCurrency,
            'conciliado': concillied,
            'fecha': timestampDate,
            'metodo': method,
            'monto': paidAmount,
            'montoOriginal': originalAmount,
            'banco': selectedBank,
            'nroReferencia': referenceID,
            'tasaDeCambio': selectedExchangedRate,
          },
        ],
      ),
    });
  } catch (e) {
    print(e);
  }
}

//Registrar pagos de trasnferencias internacionales

Future registerTransferInterPayment({
  double? coinExchangeRatio,
  double? originalAmount,
  Client? client,
  String? invoiceDocumentID,
  String? currency,
  double? amount,
  double? totalOfTheOrder,
  String? currentCoin,
  String? bank,
  String? referenceId,
  File? imageFile,
  DateTime? date,
  double? remaining,
}) async {
  print('/// Registrar transferencia inter en factura: $invoiceDocumentID ///');
  print('Datos recibidos:////////////////////////////////');

  print('  client: $client');
  print('  invoiceDocumentID: $invoiceDocumentID');
  print('  currency: $currency');
  print('  amount: $amount');
  print('  totalOfTheOrder: $totalOfTheOrder');
  print('  currentCoin: $currentCoin');
  print('  bank: $bank');
  print('  referenceId: $referenceId');
  print('  imageFile: $imageFile');
  print('  date: $date');
  print('  remaining: $remaining');

  String? banksDocumentsID;
  await FirebaseFirestore.instance
      .collection('bancos')
      .where('nombre', isEqualTo: bank)
      .get()
      .then((document) {
    document.docs.forEach((element) {
      banksDocumentsID = element.reference.id;
    });
  });

  print('Datos a registrar://///////////////////////////');
  const cancelled = false;
  final selectedCurrency = currency.toString();
  const concillied = false;
  final timestampDate = Timestamp.fromDate(date!);
  const method = 'Transferencia Internacional';
  final paidAmount = double.parse(amount.toString());
  final selectedBank =
      FirebaseFirestore.instance.collection('bancos').doc(banksDocumentsID);
  final referenceID = int.parse(referenceId!);
  final selectedExchangedRate = coinExchangeRatio;

  print('cancelled: $cancelled');
  print('selectedCurrency: $selectedCurrency');
  print('concillied: $concillied');
  print('timestampDate: $timestampDate');
  print('method: $method');
  print('paidAmount: $paidAmount');
  print('selectedBank: $selectedBank');
  print('referenceID: $referenceID');
  print('selectedExchangedRate: $selectedExchangedRate');

  try {
    return await FirebaseFirestore.instance
        .collection('clientes')
        .doc(client!.clientDocumentId)
        .collection('facturas')
        .doc(invoiceDocumentID)
        .update({
      'pagos': FieldValue.arrayUnion(
        [
          <String, dynamic>{
            'anulado': cancelled,
            'codigoMoneda': selectedCurrency,
            'conciliado': concillied,
            'fecha': timestampDate,
            'metodo': method,
            'monto': paidAmount,
            'montoOriginal': originalAmount,
            'banco': selectedBank,
            'nroReferencia': referenceID,
            'tasaDeCambio': selectedExchangedRate,
          },
        ],
      ),
    });
  } catch (e) {
    print(e);
  }
}

// Pago directo desde el checkout

Future<int> completePaymentProcess(
  Clients? client,
  String? userUid,
  String? commentary,
  double? masterDiscount,
  List<ShoppingCartProduct> shoppingCart,
  String? negotiation,
  String? deliveryAddress,
  DateTime today,
  double? taxTotal,
  numberOrder,
  double subTotal,
  double totalOfTheOrder,
  int? discountPercentage,
  randomID,
) async {
  print('CREAR PEDIDO COMPLETADO');
  final String totalAsString = totalOfTheOrder.toStringAsFixed(4);
  final List quantitiesList = [];
  final List productsIds = [];
  final List<Map<dynamic, dynamic>> products = [];
  final Map<String, dynamic> productsStock = {};

  // print('Cantidad de producto: ${element.code}: ${element.productQuantity}');
  // GET EXCHANGE RATES

  List<Coin> coins = [];
  await coinCollection.get().then((element) {
    return element.docs.forEach((doc) {
      Coin coin = Coin(
        code: doc.data().toString().contains('codigo')
            ? doc.get('codigo')
            : 'USD',
        exchangeRatio: doc.data().toString().contains('tasaDeCambio')
            ? doc.get('tasaDeCambio')
            : 1,
      );
      coins.add(coin);
    });
  });

  final exchangeRates = getExchangesRatesTest(coins);
  print('exchangeRates: $exchangeRates');

  shoppingCart.forEach((element) {
    quantitiesList.add(element.productQuantity);
    productsIds.add(element.code);
    products.add({
      'cantidad': element.productQuantity?.toInt() ?? 0,
      'codigo': element.code?.toString() ?? 'NaN',
      'id': element.code?.toString() ?? 'NaN',
      'idListaDePrecios': client?.prices ?? 'NaN',
      'monto': double.parse(element.totalAmount ?? '0') *
          int.parse(element.productQuantity.toString()),
      'nombre': element.name?.toString() ?? 'NaN',
      'precioUnitario': double.parse(element.unitPrice ?? '0.0'),
      'urlFoto': '',
    });
    final productQuantity = <String, dynamic>{
      // '${element.code}':
      //     (element.availableStock! - (element.productQuantity)!.toInt()),
      '${element.code}': element.productQuantity,
    };
    productsStock.addEntries(productQuantity.entries);
    // print('Cantidad de producto: ${element.code}: ${element.productQuantity}');
  });
  print('Cantidades: $quantitiesList');
  print(
      'Cliente: ${FirebaseFirestore.instance.collection('clientes').doc(client!.clientDocumentId)}');
  print('IDs: $productsIds');
  print('Productos: $products');

  // REDUCE STOCK ON DATABASE

  final DocumentReference stockPath =
      FirebaseFirestore.instance.collection('stock').doc('productos');
  // final Map<String, dynamic> originalStock = {
  //   '026229570704': 398,
  //   '1AC1K0003': 100,
  //   '1AC1K003': 100,
  //   'P1S0001': 46,
  //   'P1S0002': 65,
  //   'P1S0003': 102,
  //   'P1S0004': 48,
  //   'P1S0005': 51,
  //   'P1S0006': 23,
  //   'P1S0007': 12,
  //   'P1S0008': 41,
  //   'P1S0009': 20,
  //   'P1S0010': 12,
  //   'P1S9911': 154,
  //   'P1S0012': 37,
  //   'P1S0013': 321,
  //   'P1S0014': 560,
  //   'P1S0015': 500,
  //   'P1S0016': 480,
  //   'P1S0017': 410,
  //   'P1S0018': 359,
  //   'P1S0019': 387,
  //   'P1S0020': 326,
  //   'P1S0021': 403,
  //   'P1S0022': 369,
  //   'P1S0023': 247,
  //   'P1S0024': 501,
  //   'P1S0025': 58,
  //   'P1S0026': 26,
  //   'P1S0027': 87,
  //   'P1S0028': 49,
  //   'P1S0029': 5,
  //   'P1S0030': 3,
  // };
  Map<String, dynamic> currentStock = {};

  await stockPath.get().then(
    (doc) {
      currentStock = doc.data().toString().contains('valores')
          ? doc.get('valores')
          : {'0': 0};
    },
  );
  print('Modifying stock');
  productsStock.forEach((key, value) async {
    int newValue = (currentStock[key] - value);
    if (newValue <= 0) {
      await stockPath.update({
        'valores.$key': 0,
      });
    } else {
      await stockPath.update({
        'valores.$key': (currentStock[key] - value),
      });
    }
  });

  await FirebaseFirestore.instance
      .collection('clientes')
      .doc(client.clientDocumentId)
      .collection('pedidos')
      .doc(randomID)
      .set(
    {
      'cantidadesProductos': quantitiesList,
      'cliente': FirebaseFirestore.instance
          .collection('clientes')
          .doc(client.clientDocumentId),
      'comentario': commentary,
      'descuentoMaestro': masterDiscount,
      'tipoDeNegociacion': negotiation,
      'direccionEntrega': deliveryAddress == 'Fiscal'
          ? client.fiscalAdress
          : client.dispatchAdress,
      'facturacionFallida': false,
      'facturado': true,
      'fecha': Timestamp.fromDate(DateTime.now()),
      'fechaEntrega': Timestamp.fromDate(today),
      'idsProductos': productsIds,
      'impuesto': double.parse(taxTotal!.toStringAsFixed(4)),
      'nroCorrelativo': 'NaN',
      'ordenDeCompra': numberOrder ?? 0,
      'porcentajeDescuentoMaestro': client.masterDiscount,
      'porcentajeDescuentoAplicado': discountPercentage,
      'productos': products,
      'subtotal': subTotal,
      'tasasDeCambio': exchangeRates,
      'timestampRegistro': Timestamp.fromDate(DateTime.now()),
      'totalAPagar': double.parse(totalAsString),
      'ultimaModificacion': Timestamp.fromDate(DateTime.now()),
      'vendedor':
          FirebaseFirestore.instance.collection('usuarios').doc(userUid),
    },
  );
  print('/// CREAR FACTURA ///');

  final clientID = FirebaseFirestore.instance
      .collection('clientes')
      .doc(client.clientDocumentId);
  final discount = masterDiscount;
  final date = Timestamp.fromDate(DateTime.now());
  final tax = taxTotal;

  var correlativeNumber = await FirebaseFirestore.instance
      .collection('config')
      .doc('contador_pedidos')
      .get()
      .then((value) {
    return value['numero'];
  });
  const isPaid = false;
  final payments = [];
  final order = FirebaseFirestore.instance
      .collection('clientes')
      .doc(client.clientDocumentId)
      .collection('pedidos')
      .doc(randomID);
  final masterDiscountPercentage = client.masterDiscount;
  final referenceCreditNote = [];
  final subTotalInvoice = subTotal;
  final register = Timestamp.fromDate(DateTime.now());
  final lastModification = <String, dynamic>{
    'timestamp': register,
    'usuario': FirebaseFirestore.instance.collection('usuarios').doc(userUid),
  };
  final seller = FirebaseFirestore.instance.collection('usuarios').doc(userUid);

  print(clientID);
  print(discount);
  print(date);
  print(tax);
  print(totalAsString);
  print(isPaid);
  print(payments);
  print(order);
  print(masterDiscountPercentage);
  print(referenceCreditNote);
  print(subTotal);
  print(register);
  print(lastModification);
  print(seller);
  print(correlativeNumber);
  print(correlativeNumber + 1);

  await FirebaseFirestore.instance
      .collection('clientes')
      .doc(client.clientDocumentId)
      .collection('pedidos')
      .doc(randomID)
      .update({'facturado': true, 'nroCorrelativo': correlativeNumber + 1});
  await FirebaseFirestore.instance
      .collection('clientes')
      .doc(client.clientDocumentId)
      .collection('facturas')
      .doc(randomID)
      .set({
    'cliente': clientID,
    'descuentoMaestro': discount,
    'fecha': Timestamp.fromDate(DateTime.now()),
    'impuesto': double.parse(tax.toStringAsFixed(4)),
    'montoTotal': double.parse(totalAsString),
    'nroCorrelativo': correlativeNumber + 1,
    'pagada': isPaid,
    'pagos': payments,
    'pedido': order,
    'porcentajeDescuentoMaestro': masterDiscountPercentage,
    'porcentajeImpuesto': 16,
    'referenciaNotasCredito': referenceCreditNote,
    'subtotal': subTotalInvoice,
    'timestampRegistro': register,
    'ultimaModificacion': lastModification,
    'vendedor': seller,
    'tasasDeCambio': exchangeRates,
  }).whenComplete(() async {
    return await FirebaseFirestore.instance
        .collection('config')
        .doc('contador_pedidos')
        .update({'numero': correlativeNumber + 1});
  }).whenComplete(() =>
          Fluttertoast.showToast(msg: 'Factura ${correlativeNumber + 1}'));
  // await test().whenComplete(() {
  //   print('2: $randomID');
  // });

  return correlativeNumber + 1;
}

// Obtener Rol
Future<UserRole?> getUserRol(String rolId) async {
  final rol =
      await FirebaseFirestore.instance.collection('roles').doc(rolId).get();

  if (!rol.exists) return null;

  return UserRole.fromDocumentSnapshot(rol);
}

// Registrar cliente

Future registerClient({
  required String newClientName,
  required String newclientPhone,
  required String newClientEmail,
  required String newClientAddress1,
  required String newClientAddress2,
  required String selectedIdType,
  required String selectedPricesList,
  required String newClientSalesZone,
  required String uid,
  required bool isSpecialContributor,
  required int newClientMasterDiscount,
  required int newClientId,
  required File? image,
  String? latitude,
  String? longitude,
  userZoneDocument,
}) async {
  // CAMBIOS A LA DIRECCION EN LA DB
  final clientDocument = clientsCollection.doc();
  final storagePath = FirebaseStorage.instance
      .ref()
      .child('imagenes')
      .child('clientes')
      .child(clientDocument.id)
      .child('1');
  print(clientDocument);
  final lastModified = <String, dynamic>{
    'timestamp': Timestamp.now(),
    'usuario': FirebaseFirestore.instance.collection('usuarios').doc(uid)
  };
  checkLocalization(la, lo) {
    double? laDouble = double.tryParse(la);
    double? loDouble = double.tryParse(lo);
    if (laDouble == null && loDouble == null) {
      return null;
    } else {
      return GeoPoint(laDouble!, loDouble!);
    }
  }

  final localization = checkLocalization(latitude, longitude);
  print('GeoPoint: $localization');

  List<String> listnumber = newClientName.split(' ');
  List<String> output = [];
  print(listnumber);
  for (int i = 0; i < listnumber.length; i++) {
    print(listnumber[i]);
    List<String> listnumberSplit = listnumber[i].toLowerCase().split('');
    print(listnumberSplit);
    List<String> temp = [];
    for (int j = 0; j < listnumberSplit.length; j++) {
      print(listnumberSplit[j]);
      temp.add(listnumberSplit[j].toLowerCase());
      output.add(temp.join().toLowerCase());
    }
    print('temp');
    print(temp);
  }
  print(output.toString());
  print('TEST OUTPUT PHOS IN CLIENT CREATION');

  // print('  isSpecialContributor: $isSpecialContributor');
  // print(' newClientName:${newClientName.trim().toUpperCase()}');
  // print('  newClientId: $newClientId');
  // print('  newclientPhone: $newclientPhone');
  // print('  newClientEmail: $newClientEmail');
  // print('  newClientAddress1: $newClientAddress1');
  // print('  newClientAddress2: $newClientAddress2');
  // print('  newClientMasterDiscount: $newClientMasterDiscount');
  // print('  selectedIdType: $selectedIdType');
  // print('  newClientSalesZone: $newClientSalesZone');
  // print('longitude: $latitude');
  // print('latitude: $longitude');
  // print('Document: $selectedIdType$newClientId');
  // print('userZoneDocument: $userZoneDocument');
  print('  activo: true,');
  print(' contribuyenteEspecial: $isSpecialContributor,');
  print(
      ' creadoPor: ${FirebaseFirestore.instance.collection('usuarios').doc(uid)}');
  print(' descuentoMaestro: $newClientMasterDiscount,');
  print(' direccionDespacho: $newClientAddress2,');
  print(' direccionFiscal: $newClientAddress1,');
  print(' email:$newClientEmail,');
  print(' fechaRegistro: ${Timestamp.now()},');
  print(
      ' listaDePrecios: ${FirebaseFirestore.instance.collection('listas_de_precios.doc(selectedPricesList')}');

  print(' modificado: ${Timestamp.now()}');
  print(' nombre: $newClientName,');
  print(' nombreIndice: $output,');
  print(' numeroId: $newClientId,');
  //  print(' prospecto: $false,');
  print(' telefono: $newclientPhone,');
  print(' telefono2: $newclientPhone,');
  print(
      ' tipoId:${FirebaseFirestore.instance.collection('tipos_id').doc(selectedIdType)}');
  //  print('    ');
  print(' ultimaModificacion: ${Map<String, dynamic>.from(lastModified)},');
  print(' zona: $userZoneDocument,');
  print('localizacion: $localization,');

  await clientDocument.set({
    'activo': true,
    'contribuyenteEspecial': isSpecialContributor,
    'creadoPor': FirebaseFirestore.instance.collection('usuarios').doc(uid),
    'descuentoMaestro': newClientMasterDiscount,
    'direccionDespacho': newClientAddress2,
    'direccionFiscal': newClientAddress1,
    'email': newClientEmail,
    'fechaRegistro': Timestamp.now(),
    'listaDePrecios': FirebaseFirestore.instance
        .collection('listas_de_precios')
        .doc(selectedPricesList),
    'modificado': Timestamp.now(),
    'nombre': newClientName,
    'nombreIndice': output,
    'numeroId': newClientId,
    'prospecto': false,
    'telefono': newclientPhone,
    'telefono2': newclientPhone,
    'tipoId':
        FirebaseFirestore.instance.collection('tipos_id').doc(selectedIdType),
    'ultimaModificacion': Map<String, dynamic>.from(lastModified),
    'zona': userZoneDocument,
    if (localization != null) 'localizacion': localization,
  });
  if (image == null) {
    print('No image avaliable');
    return;
  } else {
    print('Image avaliable: $image');
    try {
      await storagePath
          .putFile(image)
          .whenComplete(() => print('Imagen subida'));
    } catch (e) {
      print(e);
      print('Error subiendo la imagen');
    }
  }
}

Future uploadReceiptImage(image, invoiceDocumentId, paymentIndex) async {
  try {
    final storagePath = FirebaseStorage.instance
        .ref()
        .child('imagenes')
        .child('facturas')
        .child('$invoiceDocumentId')
        .child('pagos')
        .child('pago-nro-$paymentIndex');
    if (image == null) {
      print('No image avaliable');
    } else {
      print('Image avaliable: $image');

      await storagePath.putFile(image).whenComplete(
            () => print('Imagen subida'),
          );
    }
  } catch (e) {
    print(e);
    print('error on upload receipt image');
  }
}

Future<List> cancelPayment(
    Client client, String invoiceId, int paymentIndex) async {
  final invoiceSnapshot = await FirebaseFirestore.instance
      .collection('clientes')
      .doc(client.clientDocumentId)
      .collection('facturas')
      .doc(invoiceId)
      .get();

  List payments = invoiceSnapshot.get('pagos');

  final payment = payments[paymentIndex];

  payment['anulado'] = true;
  payment['conciliado'] = false;

  payments[paymentIndex] = payment;

  await FirebaseFirestore.instance
      .collection('clientes')
      .doc(client.clientDocumentId)
      .collection('facturas')
      .doc(invoiceId)
      .update({'pagos': payments, 'pagada': false});

  return payments;
}

checkIfInvoiceIsCompleted(
    {double? remaining, double? paidAmount, client, invoiceDocumentID}) {
  try {
    double total = double.parse((Decimal.parse(remaining!.toString()) -
            Decimal.parse(paidAmount!.toString()))
        .toString());
    print('Verificando si lo que faltaba - lo pagado es igual a 0');
    print('remaining: $remaining');
    print('amount: $paidAmount ');
    print('total: $total');
    if (total <= 0) {
      print('Factura pagada completamente');
      Fluttertoast.showToast(
        msg: 'Factura pagada completamente',
        backgroundColor: myTheme.colorScheme.onPrimaryContainer,
        textColor: Colors.white,
      );
      FirebaseFirestore.instance
          .collection('clientes')
          .doc(client.clientDocumentId)
          .collection('facturas')
          .doc(invoiceDocumentID)
          .update({
        'pagada': true,
      });
    } else {
      print('Factura sigue pendiente');
    }

    return total;
  } catch (e) {
    print(e);
  }
}
