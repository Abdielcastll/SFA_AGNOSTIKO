import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Funciones de Visitas

Future createVisitData(
  String userUid,
  String clientDocumentId,
  DateTime date,
) async {
  print('////// CREAR VISITA EN PROCESO /////');
  final lastModified = <String, dynamic>{
    'timestamp': Timestamp.fromDate(DateTime.now()),
    'usuario': FirebaseFirestore.instance.collection('usuarios').doc(userUid)
  };

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
) async {
  print('/// CREAR PEDIDO ///');

  final String totalAsString = totalOfTheOrder.toStringAsFixed(2);
  final int correlativeNumber = FirebaseFirestore.instance
      .collectionGroup('pedidos')
      .snapshots()
      .toString()
      .length;
  final List quantitiesList = [];
  final List productsIds = [];
  final List<Map<dynamic, dynamic>> products = [];
  final coinsExchangeRates = [];
  await FirebaseFirestore.instance.collection('monedas').get().then((document) {
    // print('Cantidad de documentos en monedas: ${document.docs.length}');
    document.docs.forEach((element) {
      // print(element.data()['tasaDeCambio']);
      coinsExchangeRates.add(element.data()['tasaDeCambio']);
    });
  });
  final Map<String, double> exchangeRate = {
    'BTC': coinsExchangeRates[0],
    'EUR': coinsExchangeRates[1],
    'VED': coinsExchangeRates[2],
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
  print('IDs: $productsIds');
  print('Productos: $products');
  print('Cantidad de pedidos en la DB: $correlativeNumber');
  print('Monedas: $exchangeRate');

  return await FirebaseFirestore.instance
      .collection('clientes')
      .doc(client!.clientDocumentId)
      .collection('pedidos')
      .doc()
      .set({
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
    'fecha': Timestamp.fromDate(today),
    'fechaEntrega': Timestamp.fromDate(today),
    'idsProductos': productsIds,
    'impuesto': taxTotal,
    'nroCorrelativo': correlativeNumber + 1,
    'ordenDeCompra': numberOrder ?? 0,
    'porcentajeDescuentoMaestro': client.masterDiscount,
    'productos': products,
    'subtotal': subTotal,
    'tasasDeCambio': exchangeRate,
    'timestampRegistro': Timestamp.fromDate(DateTime.now()),
    'totalAPagar': double.parse(totalAsString),
    'ultimaModificacion': Timestamp.fromDate(DateTime.now()),
    'vendedor': FirebaseFirestore.instance.collection('usuarios').doc(userUid),
  });
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
  final String totalAsString = totalOfTheOrder.toStringAsFixed(2);
  final int correlativeNumber = FirebaseFirestore.instance
      .collectionGroup('facturas')
      .snapshots()
      .toString()
      .length;
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

  print(correlativeNumber);

  // await FirebaseFirestore.instance
  //     .collection('clientes')
  //     .doc(client.clientDocumentId)
  //     .collection('pedidos')
  //     .doc(orderDocumentID)
  //     .update({
  //   'facturado': true,
  // });
  // Fluttertoast.showToast(msg: 'Factura ${correlativeNumber + 1}');
  // return await FirebaseFirestore.instance
  //     .collection('clientes')
  //     .doc(client.clientDocumentId)
  //     .collection('facturas')
  //     .doc()
  //     .set({
  //   'cliente': clientID,
  //   'descuentoMaestro': discount,
  //   'fecha': Timestamp.fromDate(DateTime.parse(date)),
  //   'impuesto': tax,
  //   'montoTotal': double.parse(totalAsString),
  //   'nroCorrelativo': correlativeNumber + 35,
  //   'pagada': isPaid,
  //   'pagos': payments,
  //   'pedido': order,
  //   'porcentajeDescuentoMaestro': discountPercentage,
  //   'referenciaNotasCredito': referenceCreditNote,
  //   'subtotal': subTotal,
  //   'timestampRegistro': register,
  //   'ultimaModificacion': lastModification,
  //   'vendedor': seller,
  // });
}

//Registrar pagos de cheques

Future registerBankCheckPayment(
  Client client,
  invoiceDocumentID,
  currency,
  amount,
  totalOfTheOrder,
  currentCoin,
  bank,
  accountNumber,
  accountHolder,
  imageFile,
  date,
) async {
  print('/// Registrar cheque en factura: $invoiceDocumentID ///');

  final coinsExchangeRates = [];
  await FirebaseFirestore.instance.collection('monedas').get().then((document) {
    document.docs.forEach((element) {
      coinsExchangeRates.add(element.data()['tasaDeCambio']);
    });
  });
  final Map<String, double> exchangeRate = {
    'BTC': coinsExchangeRates[0],
    'EUR': coinsExchangeRates[1],
    'VED': coinsExchangeRates[2],
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

  if (currency == 'USD') {
    selectedCoinExchangeRate = 1;
  } else if (currency == 'VED') {
    selectedCoinExchangeRate = coinsExchangeRates[2];
  } else if (currency == 'EUR') {
    selectedCoinExchangeRate = coinsExchangeRates[1];
  } else if (currency == 'BTC') {
    selectedCoinExchangeRate = coinsExchangeRates[0];
  }
  final doubleAmount = double.parse(amount);
  final convertedAmount =
      (doubleAmount / selectedCoinExchangeRate).toStringAsFixed(2);

  print('Tasa de cambio a usar: $selectedCoinExchangeRate');
  print('banco: $bank');
  print('bancoID: $banksDocumentsID');
  print('Total en BS: $amount');
  print('Total en USD: $convertedAmount');
  print('Usuario: $accountHolder');
  print('Numero de cuenta: $accountNumber');
  print('fecha de registro: $date');

  return await FirebaseFirestore.instance
      .collection('clientes')
      .doc(client.clientDocumentId)
      .collection('facturas')
      .doc(invoiceDocumentID)
      .update({
    'pagos': FieldValue.arrayUnion(
      [
        <String, dynamic>{
          'anulado': false,
          'codigoMoneda': currency.toString(),
          'conciliado': false,
          'fecha': Timestamp.fromDate(date),
          'metodo': 'Cheque',
          'monto': double.parse(convertedAmount),
          'montoOriginal': totalOfTheOrder,
          'banco': FirebaseFirestore.instance
              .collection('bancos')
              .doc(banksDocumentsID),
          'nroCuenta': int.parse(accountNumber),
          'Titular': accountHolder,
          'nroNotaCredito': 0,
          'tasaDeCambio': selectedCoinExchangeRate,
        },
      ],
    ),
  });
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
) async {
  print('/// Registrar pago en BTC en factura: $invoiceDocumentID ///');

  final coinsExchangeRates = [];
  await FirebaseFirestore.instance.collection('monedas').get().then((document) {
    document.docs.forEach((element) {
      coinsExchangeRates.add(element.data()['tasaDeCambio']);
    });
  });
  final Map<String, double> exchangeRate = {
    'BTC': coinsExchangeRates[0],
    'EUR': coinsExchangeRates[1],
    'VED': coinsExchangeRates[2],
  };

  late var selectedCoinExchangeRate;

  if (currency == 'USD') {
    selectedCoinExchangeRate = 1;
  } else if (currency == 'VED') {
    selectedCoinExchangeRate = coinsExchangeRates[2];
  } else if (currency == 'EUR') {
    selectedCoinExchangeRate = coinsExchangeRates[1];
  } else if (currency == 'BTC') {
    selectedCoinExchangeRate = coinsExchangeRates[0];
  }
  final doubleAmount = double.parse(amount);
  final convertedAmount =
      (doubleAmount / selectedCoinExchangeRate).toStringAsFixed(8);

  print('Tasa de cambio a usar: $selectedCoinExchangeRate');

  print('Total en BTC: $amount');
  print('Total en USD: $convertedAmount');
  print('transaccion: $transactionId');
  print('fecha de registro: $date');

  if (double.parse(convertedAmount) < totalOfTheOrder) {
    return await FirebaseFirestore.instance
        .collection('clientes')
        .doc(client.clientDocumentId)
        .collection('facturas')
        .doc(invoiceDocumentID)
        .update({
      'pagos': FieldValue.arrayUnion(
        [
          <String, dynamic>{
            'anulado': false,
            'codigoMoneda': currency.toString(),
            'conciliado': false,
            'fecha': Timestamp.fromDate(date),
            'metodo': 'Criptomoneda',
            'monto': double.parse(convertedAmount),
            'montoOriginal': totalOfTheOrder,
            'idTransaccion': transactionId,
            'nroNotaCredito': 0,
            'tasaDeCambio': selectedCoinExchangeRate,
          },
        ],
      ),
    });
  } else if (double.parse(convertedAmount) > totalOfTheOrder) {
    Fluttertoast.showToast(msg: 'El monto a pagar es mayor que el de la orden');
  }
}

//Registro de deposito
Future registerDepositPayment(
  Client client,
  invoiceDocumentID,
  currency,
  amount,
  totalOfTheOrder,
  currentCoin,
  bank,
  accountNumber,
  voucherNumber,
  imageFile,
  date,
) async {
  print('/// Registrar deposito en factura: $invoiceDocumentID ///');

  final coinsExchangeRates = [];
  await FirebaseFirestore.instance.collection('monedas').get().then((document) {
    document.docs.forEach((element) {
      coinsExchangeRates.add(element.data()['tasaDeCambio']);
    });
  });
  final Map<String, double> exchangeRate = {
    'BTC': coinsExchangeRates[0],
    'EUR': coinsExchangeRates[1],
    'VED': coinsExchangeRates[2],
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

  if (currency == 'USD') {
    selectedCoinExchangeRate = 1;
  } else if (currency == 'VED') {
    selectedCoinExchangeRate = coinsExchangeRates[2];
  } else if (currency == 'EUR') {
    selectedCoinExchangeRate = coinsExchangeRates[1];
  } else if (currency == 'BTC') {
    selectedCoinExchangeRate = coinsExchangeRates[0];
  }
  final doubleAmount = double.parse(amount);
  final convertedAmount =
      (doubleAmount / selectedCoinExchangeRate).toStringAsFixed(2);

  print('Tasa de cambio a usar: $selectedCoinExchangeRate');
  print('banco: $bank');
  print('bancoID: $banksDocumentsID');
  print('Total en BS: $amount');
  print('Total en USD: $convertedAmount');
  print('voucher: $voucherNumber');
  print('Numero de cuenta: $accountNumber');
  print('fecha de registro: $date');

  return await FirebaseFirestore.instance
      .collection('clientes')
      .doc(client.clientDocumentId)
      .collection('facturas')
      .doc(invoiceDocumentID)
      .update({
    'pagos': FieldValue.arrayUnion(
      [
        <String, dynamic>{
          'anulado': false,
          'codigoMoneda': currency.toString(),
          'conciliado': false,
          'fecha': Timestamp.fromDate(date),
          'metodo': 'Deposito',
          'monto': double.parse(convertedAmount),
          'montoOriginal': totalOfTheOrder,
          'banco': FirebaseFirestore.instance
              .collection('bancos')
              .doc(banksDocumentsID),
          'nroCuenta': int.parse(accountNumber),
          'nroVoucher': voucherNumber,
          'nroNotaCredito': 0,
          'tasaDeCambio': selectedCoinExchangeRate,
        },
      ],
    ),
  });
}

//Registrar pagos de efectivo

Future registerMoneyPayment(client, invoiceDocumentID, currency, amount,
    totalOfTheOrder, imageFile, date) async {
  print('/// Registrar pago en efectivo en factura: $invoiceDocumentID ///');

  final coinsExchangeRates = [];
  await FirebaseFirestore.instance.collection('monedas').get().then((document) {
    document.docs.forEach((element) {
      coinsExchangeRates.add(element.data()['tasaDeCambio']);
    });
  });
  final Map<String, double> exchangeRate = {
    'BTC': coinsExchangeRates[0],
    'EUR': coinsExchangeRates[1],
    'VED': coinsExchangeRates[2],
  };

  late var selectedCoinExchangeRate;

  if (currency == 'USD') {
    selectedCoinExchangeRate = 1;
  } else if (currency == 'VED') {
    selectedCoinExchangeRate = coinsExchangeRates[2];
  } else if (currency == 'EUR') {
    selectedCoinExchangeRate = coinsExchangeRates[1];
  } else if (currency == 'BTC') {
    selectedCoinExchangeRate = coinsExchangeRates[0];
  }
  final doubleAmount = double.parse(amount);
  final convertedAmount =
      (doubleAmount / selectedCoinExchangeRate).toStringAsFixed(8);

  print('Tasa de cambio a usar: $selectedCoinExchangeRate');

  print('Total en BTC: $amount');
  print('Total en USD: $convertedAmount');
  print('fecha de registro: $date');

  if (double.parse(convertedAmount) < totalOfTheOrder) {
    return await FirebaseFirestore.instance
        .collection('clientes')
        .doc(client.clientDocumentId)
        .collection('facturas')
        .doc(invoiceDocumentID)
        .update({
      'pagos': FieldValue.arrayUnion(
        [
          <String, dynamic>{
            'anulado': false,
            'codigoMoneda': currency.toString(),
            'conciliado': false,
            'fecha': Timestamp.fromDate(date),
            'metodo': 'Efectivo',
            'monto': double.parse(convertedAmount),
            'montoOriginal': totalOfTheOrder,
            'nroNotaCredito': 0,
            'tasaDeCambio': selectedCoinExchangeRate,
          },
        ],
      ),
    });
  } else if (double.parse(convertedAmount) > totalOfTheOrder) {
    Fluttertoast.showToast(msg: 'El monto a pagar es mayor que el de la orden');
  }
}

//Registrar pagos de trasnferencias nacionales

Future registerTransferPayment(
  client,
  invoiceDocumentID,
  currency,
  amount,
  totalOfTheOrder,
  currentCoin,
  bank,
  referenceId,
  imageFile,
  date,
) async {
  print('/// Registrar Trasnferencia en factura: $invoiceDocumentID ///');

  final coinsExchangeRates = [];
  await FirebaseFirestore.instance.collection('monedas').get().then((document) {
    document.docs.forEach((element) {
      coinsExchangeRates.add(element.data()['tasaDeCambio']);
    });
  });
  final Map<String, double> exchangeRate = {
    'BTC': coinsExchangeRates[0],
    'EUR': coinsExchangeRates[1],
    'VED': coinsExchangeRates[2],
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

  if (currency == 'USD') {
    selectedCoinExchangeRate = 1;
  } else if (currency == 'VED') {
    selectedCoinExchangeRate = coinsExchangeRates[2];
  } else if (currency == 'EUR') {
    selectedCoinExchangeRate = coinsExchangeRates[1];
  } else if (currency == 'BTC') {
    selectedCoinExchangeRate = coinsExchangeRates[0];
  }
  final doubleAmount = double.parse(amount);
  final convertedAmount =
      (doubleAmount / selectedCoinExchangeRate).toStringAsFixed(2);

  print('Tasa de cambio a usar: $selectedCoinExchangeRate');
  print('banco: $bank');
  print('bancoID: $banksDocumentsID');
  print('Total en BS: $amount');
  print('Total en USD: $convertedAmount');
  print('Ref: $referenceId');

  print('fecha de registro: $date');

  return await FirebaseFirestore.instance
      .collection('clientes')
      .doc(client.clientDocumentId)
      .collection('facturas')
      .doc(invoiceDocumentID)
      .update({
    'pagos': FieldValue.arrayUnion(
      [
        <String, dynamic>{
          'anulado': false,
          'codigoMoneda': currency.toString(),
          'conciliado': false,
          'fecha': Timestamp.fromDate(date),
          'metodo': 'Transferencia',
          'monto': double.parse(convertedAmount),
          'montoOriginal': totalOfTheOrder,
          'banco': FirebaseFirestore.instance
              .collection('bancos')
              .doc(banksDocumentsID),
          'nroReferencia': int.parse(referenceId),
          'nroNotaCredito': 0,
          'tasaDeCambio': selectedCoinExchangeRate,
        },
      ],
    ),
  });
}

//Registrar pagos de trasnferencias internacionales

Future registerTransferInterPayment(
  client,
  invoiceDocumentID,
  currency,
  amount,
  totalOfTheOrder,
  currentCoin,
  bank,
  referenceId,
  imageFile,
  date,
) async {
  print('/// Registrar transferencia inter en factura: $invoiceDocumentID ///');

  final coinsExchangeRates = [];
  await FirebaseFirestore.instance.collection('monedas').get().then((document) {
    document.docs.forEach((element) {
      coinsExchangeRates.add(element.data()['tasaDeCambio']);
    });
  });
  final Map<String, double> exchangeRate = {
    'BTC': coinsExchangeRates[0],
    'EUR': coinsExchangeRates[1],
    'VED': coinsExchangeRates[2],
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

  if (currency == 'USD') {
    selectedCoinExchangeRate = 1;
  } else if (currency == 'VED') {
    selectedCoinExchangeRate = coinsExchangeRates[2];
  } else if (currency == 'EUR') {
    selectedCoinExchangeRate = coinsExchangeRates[1];
  } else if (currency == 'BTC') {
    selectedCoinExchangeRate = coinsExchangeRates[0];
  }
  final doubleAmount = double.parse(amount);
  final convertedAmount =
      (doubleAmount / selectedCoinExchangeRate).toStringAsFixed(2);

  print('Tasa de cambio a usar: $selectedCoinExchangeRate');
  print('banco: $bank');
  print('bancoID: $banksDocumentsID');
  print('Total en BS: $amount');
  print('Total en USD: $convertedAmount');
  print('Ref: $referenceId');

  print('fecha de registro: $date');

  return await FirebaseFirestore.instance
      .collection('clientes')
      .doc(client.clientDocumentId)
      .collection('facturas')
      .doc(invoiceDocumentID)
      .update({
    'pagos': FieldValue.arrayUnion(
      [
        <String, dynamic>{
          'anulado': false,
          'codigoMoneda': currency.toString(),
          'conciliado': false,
          'fecha': Timestamp.fromDate(date),
          'metodo': 'Transferencia-internacional',
          'monto': double.parse(convertedAmount),
          'montoOriginal': totalOfTheOrder,
          'banco': FirebaseFirestore.instance
              .collection('bancos')
              .doc(banksDocumentsID),
          'nroReferencia': int.parse(referenceId),
          'nroNotaCredito': 0,
          'tasaDeCambio': selectedCoinExchangeRate,
        },
      ],
    ),
  });
}
