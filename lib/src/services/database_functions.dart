import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
) async {
  print('/// CREAR PEDIDO ///');

  final String totalAsString = totalOfTheOrder.toStringAsFixed(4);
  // var correlativeNumber = await FirebaseFirestore.instance
  //     .collection('config')
  //     .doc('contador_pedidos')
  //     .get()
  //     .then((value) {
  //   return value['numero'];
  // });
  // configDoc.get().then((value) => print('testing: ${value['numero']}'));
  // await FirebaseFirestore.instance
  //     .collection('config')
  //     .doc('contador_pedidos')
  //     .update({'numero': correlativeNumber + 1});
  // print(configDoc);
  // print(correlativeNumber);
  final List quantitiesList = [];
  final List productsIds = [];
  final List<Map<dynamic, dynamic>> products = [];
  final Map<String, double> exchangeRate = {
    'BTC': 0.00011,
    'EUR': 0.89,
    'VED': 4.58,
    'MXN': 19.43
  };
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
    print('Cantidad de producto: ${element.code}: ${element.productQuantity}');
  });
  print('Cantidades: $quantitiesList');
  print(
      'Cliente: ${FirebaseFirestore.instance.collection('clientes').doc(client!.clientDocumentId)}');
  print('IDs: $productsIds');
  print('Productos: $products');
  // print('Ordernes: ${correlativeNumber}');
  // print('nueva: ${correlativeNumber + 1}');

  // return await FirebaseFirestore.instance
  //     .collection('config')
  //     .doc('contador_pedidos')
  //     .update({'numero': correlativeNumber + 1}).whenComplete(
  //   () async {
  return await FirebaseFirestore.instance
      .collection('clientes')
      .doc(client.clientDocumentId)
      .collection('pedidos')
      .doc()
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
      'facturado': false,
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
      'tasasDeCambio': exchangeRate,
      'timestampRegistro': Timestamp.fromDate(DateTime.now()),
      'totalAPagar': double.parse(totalAsString),
      'ultimaModificacion': Timestamp.fromDate(DateTime.now()),
      'vendedor':
          FirebaseFirestore.instance.collection('usuarios').doc(userUid),
    },
  );
  // },
  // return await FirebaseFirestore.instance
  //     .collection('clientes')
  //     .doc(client!.clientDocumentId)
  //     .collection('pedidos')
  //     .doc()
  //     .set({
  //   'cantidadesProductos': quantitiesList,
  //   'cliente': FirebaseFirestore.instance
  //       .collection('clientes')
  //       .doc(client.clientDocumentId),
  //   'comentario': commentary,
  //   'descuentoMaestro': masterDiscount,
  //   'tipoDeNegociacion': negotiation,
  //   'direccionEntrega': deliveryAddress == 'Fiscal'
  //       ? client.fiscalAdress
  //       : client.dispatchAdress,
  //   'facturacionFallida': false,
  //   'facturado': false,
  //   'fecha': Timestamp.fromDate(DateTime.now()),
  //   'fechaEntrega': Timestamp.fromDate(today),
  //   'idsProductos': productsIds,
  //   'impuesto': taxTotal,
  //   'nroCorrelativo': correlativeNumber + 1,
  //   'ordenDeCompra': numberOrder ?? 0,
  //   'porcentajeDescuentoMaestro': client.masterDiscount,
  //   'productos': products,
  //   'subtotal': subTotal,
  //   'tasasDeCambio': exchangeRate,
  //   'timestampRegistro': Timestamp.fromDate(DateTime.now()),
  //   'totalAPagar': double.parse(totalAsString),
  //   'ultimaModificacion': Timestamp.fromDate(DateTime.now()),
  //   'vendedor': FirebaseFirestore.instance.collection('usuarios').doc(userUid),
  // });
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
      .delete();
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
  final discount = masterDiscount;
  final date = orderDate;
  final tax = taxTotal;
  final String totalAsString = totalOfTheOrder.toStringAsFixed(4);

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

  print(clientID);
  print(discount);
  print(date);
  print(tax);
  print(totalAsString);
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
      'descuentoMaestro': discount,
      'fecha': Timestamp.fromDate(DateTime.now()),
      'impuesto': tax,
      'montoTotal': double.parse(totalAsString),
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
    }).whenComplete(() async {
      return await FirebaseFirestore.instance
          .collection('config')
          .doc('contador_pedidos')
          .update({'numero': correlativeNumber + 1});
    }).whenComplete(() =>
            Fluttertoast.showToast(msg: 'Factura ${correlativeNumber + 1}'));
  });
}

//Registrar pagos de Tarjeta de Credito/Debito

Future registerDebitCreditCardPayment(InvoiceData data) async {
  priceReturnToOriginal(productPrice, coin) {
    double correctAmount = double.parse(productPrice.toStringAsFixed(4));
    if (coin!.contains('USD')) {
      return correctAmount;
    } else if (coin.contains('VED')) {
      return double.parse((correctAmount / 4.58).toString());
    } else if (coin.contains('EUR')) {
      return double.parse((correctAmount / 0.89).toString());
    } else if (coin.contains('MXN')) {
      return double.parse((correctAmount / 19.43).toString());
    } else if (coin.contains('BTC')) {
      return double.parse((correctAmount / 0.00011).toString());
    } else {
      return double.parse((correctAmount / 4.58).toString());
    }
  }

  Client client = data.client;
  var invoiceDocumentID = data.invoiceDocumentID;
  var currency = data.currency;
  var amount = data.amount;
  var totalOfTheOrder = data.totalOfTheOrder;
  var currentCoin = data.currentCoin;
  var date = data.date;
  var remaining = data.remaining;

  print('/// Registrar pago en factura: $invoiceDocumentID ///');

  final Map<String, double> exchangeRate = {
    'BTC': 0.00011,
    'EUR': 0.89,
    'VED': 4.58,
    'MXN': 19.43,
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

  const cancelled = false;
  final selectedCurrency = currency.toString();
  const concillied = false;
  final timestampDate = Timestamp.fromDate(date);
  const method = 'Tarjeta Debito/Credito';
  final paidAmount = amount;

  try {
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
            'monto': priceReturnToOriginal(paidAmount, currentCoin),
            'montoOriginal': priceReturnToOriginal(paidAmount, currentCoin),
            // 'nroNotaCredito': 0,
            'tasaDeCambio': selectedCoinExchangeRate,
          },
        ],
      ),
    }).whenComplete(() {
      print(
          'remaining de proceso: ${priceToCurrencySelected(remaining, currency)}');
      print('Amount de proceso: ${priceToCurrencySelected(amount, currency)}');
      print(
          'restante total: ${priceToCurrencySelected(remaining, currency) - priceToCurrencySelected(amount, currency)}');
      var total = priceToCurrencySelected(remaining, currency) -
          priceToCurrencySelected(amount, currency);
      try {
        if (total <= 0) {
          FirebaseFirestore.instance
              .collection('clientes')
              .doc(client.clientDocumentId)
              .collection('facturas')
              .doc(invoiceDocumentID)
              .update({
            'pagada': true,
          });
        }
      } catch (e) {
        print(e);
      }
    });
  } catch (e) {
    print(e);
  }

  if (paidAmount > remaining) {
    Fluttertoast.showToast(
      msg: 'La cantidad pagada excede de la deuda pendiente',
      backgroundColor: myTheme.colorScheme.secondary,
      textColor: Colors.white,
    );
  }
}

//Registrar pagos de cheques

Future registerBankCheckPayment({
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
  // print('/// Registrar cheque en factura: $invoiceDocumentID ///');
  print('client: $client');
  print('invoiceDocumentID: $invoiceDocumentID');
  print('currency: $currency');
  print('amount: $amount');
  print('totalOfTheOrder: $totalOfTheOrder');
  print('currentCoin: $currentCoin');
  print('bank: $bank');
  print('accountNumber: $accountNumber');
  print('accountHolder: $accountHolder');
  print('imageFile: $imageFile');
  print('date: $date');
  print('remaining: $remaining');
  final Map<String, double> exchangeRate = {
    'BTC': 0.00011,
    'EUR': 0.89,
    'VED': 4.58,
    'MXN': 19.43,
  };

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

  priceReturnToOriginal(productPrice, coin) {
    double correctAmount = double.parse(productPrice.toStringAsFixed(4));
    if (coin!.contains('USD')) {
      return correctAmount;
    } else if (coin.contains('VED')) {
      return double.parse((correctAmount / 4.58).toStringAsFixed(4));
    } else if (coin.contains('EUR')) {
      return double.parse((correctAmount / 0.89).toStringAsFixed(4));
    } else if (coin.contains('MXN')) {
      return double.parse((correctAmount / 19.43).toStringAsFixed(4));
    } else if (coin.contains('BTC')) {
      return double.parse((correctAmount / 0.00011).toStringAsFixed(4));
    } else {
      return double.parse((correctAmount / 4.58).toStringAsFixed(4));
    }
  }

  const cancelled = false;
  final selectedCurrency = currency.toString();
  const concillied = false;
  final timestampDate = Timestamp.fromDate(date!);
  const method = 'Cheque';
  final paidAmount = double.parse(amount.toString());
  final selectedBank =
      FirebaseFirestore.instance.collection('bancos').doc(banksDocumentsID);
  final account = accountNumber;
  final holder = accountHolder;
  const nroCN = 0;
  final selectedExchangedRate = selectedCoinExchangeRate;

  print('Se completo la factura??:');
  print(remaining! - paidAmount <= 0 ? 'Completado' : "Sigue pendiente");

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
            'montoOriginal': paidAmount,
            'banco': FirebaseFirestore.instance
                .collection('bancos')
                .doc(banksDocumentsID),
            'nroCuenta': int.parse(accountNumber!),
            'titular': accountHolder,
            // 'nroNotaCredito': 0,
            'tasaDeCambio': selectedCoinExchangeRate,
          },
        ],
      ),
    }).whenComplete(() {
      print(
          'remaining de proceso: ${priceToCurrencySelected(remaining, currency!)}');
      print('Amount de proceso: ${priceToCurrencySelected(amount!, currency)}');
      print(
          'restante total: ${priceToCurrencySelected(remaining, currency) - priceToCurrencySelected(amount, currency)}');
      var total = priceToCurrencySelected(remaining, currency) -
          priceToCurrencySelected(amount, currency);
      try {
        if (total <= 0) {
          FirebaseFirestore.instance
              .collection('clientes')
              .doc(client.clientDocumentId)
              .collection('facturas')
              .doc(invoiceDocumentID)
              .update({
            'pagada': true,
          });
        }
      } catch (e) {
        print(e);
      }
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
  priceReturnToOriginal(productPrice, coin) {
    double correctAmount = double.parse(productPrice.toStringAsFixed(4));
    if (coin!.contains('USD')) {
      return correctAmount;
    } else if (coin.contains('VED')) {
      return double.parse((correctAmount / 4.58).toStringAsFixed(4));
    } else if (coin.contains('EUR')) {
      return double.parse((correctAmount / 0.89).toStringAsFixed(4));
    } else if (coin.contains('MXN')) {
      return double.parse((correctAmount / 19.43).toStringAsFixed(4));
    } else if (coin.contains('BTC')) {
      return double.parse((correctAmount / 0.00011).toStringAsFixed(4));
    } else {
      return double.parse((correctAmount / 4.58).toStringAsFixed(4));
    }
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
            'anulado': nulled,
            'codigoMoneda': codeCurrency,
            'conciliado': concillied,
            'fecha': paymentDate,
            'metodo': method,
            'monto': paymentAmount,
            'montoOriginal': paymentAmount,
            'idTransaccion': transactionID,
            'tasaDeCambio': selectedCoinExchangeRate,
          },
        ],
      ),
    }).whenComplete(() {
      print(
          'remaining de proceso: ${priceToCurrencySelected(remaining!, currency!)}');
      print('Amount de proceso: ${priceToCurrencySelected(amount!, currency)}');
      print(
          'restante total: ${priceToCurrencySelected(remaining!, currency!) - priceToCurrencySelected(amount!, currency)}');
      var total = priceToCurrencySelected(remaining!, currency!) -
          priceToCurrencySelected(amount!, currency);
      try {
        if (total <= 0) {
          FirebaseFirestore.instance
              .collection('clientes')
              .doc(client.clientDocumentId)
              .collection('facturas')
              .doc(invoiceDocumentID)
              .update({
            'pagada': true,
          });
        }
      } catch (e) {
        print(e);
      }
    });
  } catch (e) {
    print(e);
  }
}

//Registro de deposito
Future registerDepositPayment({
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

  final Map<String, double> exchangeRate = {
    'BTC': 0.00011,
    'EUR': 0.89,
    'VED': 4.58,
    'MXN': 19.43
  };

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
  priceReturnToOriginal(productPrice, coin) {
    double correctAmount = double.parse(productPrice.toStringAsFixed(4));
    if (coin!.contains('USD')) {
      return correctAmount;
    } else if (coin.contains('VED')) {
      return double.parse((correctAmount / 4.58).toStringAsFixed(4));
    } else if (coin.contains('EUR')) {
      return double.parse((correctAmount / 0.89).toStringAsFixed(4));
    } else if (coin.contains('MXN')) {
      return double.parse((correctAmount / 19.43).toStringAsFixed(4));
    } else if (coin.contains('BTC')) {
      return double.parse((correctAmount / 0.00011).toStringAsFixed(4));
    } else {
      return double.parse((correctAmount / 4.58).toStringAsFixed(4));
    }
  }
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
  final selectedExchangedRate = selectedCoinExchangeRate;

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
            'montoOriginal': paidAmount,
            'banco': selectedBank,
            'nroCuenta': account,
            'nroVoucher': voucher,
            // 'nroNotaCredito': 0,
            'tasaDeCambio': selectedCoinExchangeRate,
          },
        ],
      ),
    }).whenComplete(() {
      print(
          'remaining de proceso: ${priceToCurrencySelected(remaining!, currency!)}');
      print('Amount de proceso: ${priceToCurrencySelected(amount!, currency)}');
      print(
          'restante total: ${priceToCurrencySelected(remaining, currency) - priceToCurrencySelected(amount, currency)}');
      var total = priceToCurrencySelected(remaining, currency) -
          priceToCurrencySelected(amount, currency);
      try {
        if (total <= 0) {
          FirebaseFirestore.instance
              .collection('clientes')
              .doc(client.clientDocumentId)
              .collection('facturas')
              .doc(invoiceDocumentID)
              .update({
            'pagada': true,
          });
        }
      } catch (e) {
        print(e);
      }
    });
  } catch (e) {
    print(e);
  }
}

//Registrar pagos de efectivo

Future registerMoneyPayment({
  Client? client,
  String? invoiceDocumentID,
  String? currency,
  double? amount,
  double? totalOfTheOrder,
  File? imageFile,
  DateTime? date,
  double? remaining,
}) async {
  // print('/// Registrar pago en efectivo en factura: $invoiceDocumentID ///');

  // print('Datos recibidos://////////////////////////');

  print('invoiceDocumentID: $invoiceDocumentID');
  print('client: ${client!.name}');
  print('selectedCoin: $currency');
  print('paidAmount: $amount');
  print('totalOfTheOrder: $totalOfTheOrder');
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

  // final doubleAmount = double.parse(amount);
  // final convertedAmount =
  //     (doubleAmount / selectedCoinExchangeRate).toStringAsFixed(8);
  const nulled = false;
  final codeCurrency = currency.toString();
  const concillied = false;
  final paymentDate = Timestamp.fromDate(date!);
  const method = 'Efectivo';
  final paymentAmount = double.parse(amount.toString());
  final originalAmount = double.parse(amount.toString());
  final exancheRates = selectedCoinExchangeRate;

  print('Datos a registrar:///////////////////');
  print('nulled: $nulled');
  print('codeCurrency: $codeCurrency');
  print('concillied: $concillied');
  print('paymentDate: $paymentDate');
  print('method: $method');
  print('paymentAmount: $paymentAmount');
  print('originalAmount: $originalAmount');
  print('exancheRates: $exancheRates');

  try {
    return await FirebaseFirestore.instance
        .collection('clientes')
        .doc(client.clientDocumentId)
        .collection('facturas')
        .doc(invoiceDocumentID)
        .update({
      'pagos': FieldValue.arrayUnion(
        [
          <String, dynamic>{
            'anulado': nulled,
            'codigoMoneda': codeCurrency,
            'conciliado': concillied,
            'fecha': paymentDate,
            'metodo': method,
            'monto': paymentAmount,
            'montoOriginal': originalAmount,
            // 'nroNotaCredito': 0,
            'tasaDeCambio': selectedCoinExchangeRate,
          },
        ],
      ),
    }).whenComplete(() {
      print(
          'remaining de proceso: ${priceToCurrencySelected(remaining!, currency!)}');
      print('Amount de proceso: ${priceToCurrencySelected(amount!, currency)}');
      print(
          'restante total: ${priceToCurrencySelected(remaining, currency) - priceToCurrencySelected(amount, currency)}');
      var total = priceToCurrencySelected(remaining, currency) -
          priceToCurrencySelected(amount, currency);
      try {
        if (total <= 0) {
          print('Factura pagada completamente');
          FirebaseFirestore.instance
              .collection('clientes')
              .doc(client.clientDocumentId)
              .collection('facturas')
              .doc(invoiceDocumentID)
              .update({
            'pagada': true,
          });
        }
      } catch (e) {
        print(e);
      }
    }).whenComplete(() => print('Operación completada satisfactoriamente'));
  } catch (e) {
    print(e);
  }
}

//Registrar pagos de trasnferencias nacionales

Future registerTransferPayment({
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

  final Map<String, double> exchangeRate = {
    'BTC': 0.00011,
    'EUR': 0.89,
    'VED': 4.58,
    'MXN': 19.43
  };

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
  priceReturnToOriginal(productPrice, coin) {
    double correctAmount = double.parse(productPrice.toStringAsFixed(4));
    if (coin!.contains('USD')) {
      return correctAmount;
    } else if (coin.contains('VED')) {
      return double.parse((correctAmount / 4.58).toStringAsFixed(4));
    } else if (coin.contains('EUR')) {
      return double.parse((correctAmount / 0.89).toStringAsFixed(4));
    } else if (coin.contains('MXN')) {
      return double.parse((correctAmount / 19.43).toStringAsFixed(4));
    } else if (coin.contains('BTC')) {
      return double.parse((correctAmount / 0.00011).toStringAsFixed(4));
    } else {
      return double.parse((correctAmount / 4.58).toStringAsFixed(4));
    }
  }
  // final doubleAmount = double.parse(amount);
  // final convertedAmount =
  //     (doubleAmount / selectedCoinExchangeRate).toStringAsFixed(4);

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
  final selectedExchangedRate = selectedCoinExchangeRate;

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
            'montoOriginal': paidAmount,
            'banco': selectedBank,
            'nroReferencia': referenceID,
            'tasaDeCambio': selectedCoinExchangeRate,
          },
        ],
      ),
    }).whenComplete(() {
      print(
          'remaining de proceso: ${priceToCurrencySelected(remaining!, currency!)}');
      print('Amount de proceso: ${priceToCurrencySelected(amount!, currency)}');
      print(
          'restante total: ${priceToCurrencySelected(remaining, currency) - priceToCurrencySelected(amount, currency)}');
      var total = priceToCurrencySelected(remaining, currency) -
          priceToCurrencySelected(amount, currency);
      try {
        if (total <= 0) {
          FirebaseFirestore.instance
              .collection('clientes')
              .doc(client.clientDocumentId)
              .collection('facturas')
              .doc(invoiceDocumentID)
              .update({
            'pagada': true,
          });
        }
      } catch (e) {
        print(e);
      }
    });
  } catch (e) {
    print(e);
  }
}

//Registrar pagos de trasnferencias internacionales

Future registerTransferInterPayment({
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

  final Map<String, double> exchangeRate = {
    'BTC': 0.00011,
    'EUR': 0.89,
    'VED': 4.58,
    'MXN': 19.43
  };

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
  // final doubleAmount = double.parse(amount);
  // final convertedAmount =
  //     (doubleAmount / selectedCoinExchangeRate).toStringAsFixed(4);

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
  final selectedExchangedRate = selectedCoinExchangeRate;
  priceReturnToOriginal(productPrice, coin) {
    double correctAmount = double.parse(productPrice.toStringAsFixed(4));
    if (coin!.contains('USD')) {
      return correctAmount;
    } else if (coin.contains('VED')) {
      return double.parse((correctAmount / 4.58).toStringAsFixed(4));
    } else if (coin.contains('EUR')) {
      return double.parse((correctAmount / 0.89).toStringAsFixed(4));
    } else if (coin.contains('MXN')) {
      return double.parse((correctAmount / 19.43).toStringAsFixed(4));
    } else if (coin.contains('BTC')) {
      return double.parse((correctAmount / 0.00011).toStringAsFixed(4));
    } else {
      return double.parse((correctAmount / 4.58).toStringAsFixed(4));
    }
  }

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
            'montoOriginal': paidAmount,
            'banco': selectedBank,
            'nroReferencia': referenceID,
            'tasaDeCambio': selectedCoinExchangeRate,
          },
        ],
      ),
    }).whenComplete(() {
      print(
          'remaining de proceso: ${priceToCurrencySelected(remaining!, currency!)}');
      print('Amount de proceso: ${priceToCurrencySelected(amount!, currency)}');
      print(
          'restante total: ${priceToCurrencySelected(remaining, currency) - priceToCurrencySelected(amount, currency)}');
      var total = priceToCurrencySelected(remaining, currency) -
          priceToCurrencySelected(amount, currency);
      try {
        if (total <= 0) {
          FirebaseFirestore.instance
              .collection('clientes')
              .doc(client.clientDocumentId)
              .collection('facturas')
              .doc(invoiceDocumentID)
              .update({
            'pagada': true,
          });
        }
      } catch (e) {
        print(e);
      }
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
  final Map<String, double> exchangeRate = {
    'BTC': 0.00011,
    'EUR': 0.89,
    'VED': 4.58,
    'MXN': 19.43
  };
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
    print('Cantidad de producto: ${element.code}: ${element.productQuantity}');
  });
  print('Cantidades: $quantitiesList');
  print(
      'Cliente: ${FirebaseFirestore.instance.collection('clientes').doc(client!.clientDocumentId)}');
  print('IDs: $productsIds');
  print('Productos: $products');

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
      'tasasDeCambio': exchangeRate,
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
  required bool isSpecialContributor,
  required int newClientMasterDiscount,
  required int newClientId,
  required String uid,
  required File? image,
}) async {
  print(' newClientName: $newClientName');
  print('  newClientId: $newClientId');
  print('  newclientPhone: $newclientPhone');
  print('  newClientEmail: $newClientEmail');
  print('  newClientAddress1: $newClientAddress1');
  print('  newClientAddress2: $newClientAddress2');
  print('  newClientMasterDiscount: $newClientMasterDiscount');
  print('  isSpecialContributor: $isSpecialContributor');
  print('  selectedIdType: $selectedIdType');
  print('  newClientSalesZone: $newClientSalesZone');
  print('Document: $selectedIdType$newClientId');
  final clientDocument = clientsCollection.doc('$selectedIdType$newClientId');
  print(clientDocument);
  final lastModified = <String, dynamic>{
    'timestamp': Timestamp.now(),
    'usuario': FirebaseFirestore.instance.collection('usuarios').doc(uid)
  };

  List<String> listnumber = newClientName.split("");
  List<String> output = [];
  for (int i = 0; i < listnumber.length; i++) {
    if (i != listnumber.length - 1) {
      output.add(listnumber[i]);
    }
    List<String> temp = [listnumber[i]];
    for (int j = i + 1; j < listnumber.length; j++) {
      temp.add(listnumber[j]);
      output.add(temp.join());
    }
  }
  print(output.toString());
  print('TEST OUTPUT PHOS');

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
    'zona': FirebaseFirestore.instance
        .collection('zonas')
        .doc('nKw5phIwZMrasraHpzrj'),
  });
}
