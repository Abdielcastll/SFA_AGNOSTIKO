import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/models/transaction_args.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/utils/multitenant-config.dart';

import '../models/user_rol_model.dart';

// Funciones de Visitas
final firebase =
    FirebaseFirestore.instanceFor(app: multitenantConfig.tenantApp!);

final storage = FirebaseStorage.instanceFor(app: multitenantConfig.tenantApp!);

final CollectionReference bancosRef = bancosRef;
final CollectionReference catalogoProductosRef =
    firebase.collection('catalogo_productos');
final CollectionReference catalogosRef = firebase.collection('catalogos');
final CollectionReference categoriasRef = firebase.collection('categorias');
final CollectionReference clientesRef = firebase.collection('clientes');
final CollectionReference configRef = firebase.collection('config');
final CollectionReference descuentosRef = firebase.collection('descuentos');
final CollectionReference disenosRef = firebase.collection('disenos');
final CollectionReference dispositivosRef = firebase.collection('dispositivos');
final CollectionReference equiposRef = firebase.collection('equipos');
final CollectionReference lineasRef = firebase.collection('lineas');
final CollectionReference listaDePreciosRef =
    firebase.collection('listas_de_precios');
final CollectionReference marcasRef = firebase.collection('marcas');
final CollectionReference monedasRef = firebase.collection('monedas');
final CollectionReference productosRef = firebase.collection('productos');
final CollectionReference promocionesRef = firebase.collection('promociones');
final CollectionReference rolesRef = firebase.collection('roles');
final CollectionReference stockRef = firebase.collection('stock');
final CollectionReference subcategoriasRef =
    firebase.collection('subcategorias');
final CollectionReference tamanosRef = firebase.collection('tamanos');
final CollectionReference tiposIdRef = firebase.collection('tipos_id');
final CollectionReference usuariosRef = firebase.collection('usuarios');
final CollectionReference zonasRef = firebase.collection('zonas');

Future<List<String>> getUserDevices(String id) async {
  final devicesDocs =
      await usersCollection.doc(id).collection("dispositivos").get();
  final devices = <String>[];
  for (var element in devicesDocs.docs) {
    devices.add(element.id);
  }

  return devices;
}

Future createVisitData(
  String userUid,
  String clientDocumentId,
  DateTime date,
) async {
  final lastModified = <String, dynamic>{
    'timestamp': Timestamp.now(),
    'usuario': usuariosRef.doc(userUid)
  };

  return await usuariosRef.doc(userUid).collection('visitas').doc().set({
    'cancelada': false,
    'cliente': clientesRef.doc(clientDocumentId),
    'completada': false,
    'creadoPor': usuariosRef.doc(userUid),
    'fecha': Timestamp.fromDate(date),
    'noCobranza': false,
    'noPedido': false,
    'noVisita': false,
    'timestrampRegistro': Timestamp.fromDate(DateTime.now()),
    'ultima modificacion': Map<String, dynamic>.from(lastModified),
    'vendedor': usuariosRef.doc(userUid),
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
  return await usuariosRef.doc(uid).collection('visitas').doc(docId).update({
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
  return await usuariosRef.doc(uid).collection('visitas').doc(docId).delete();
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
    final DocumentReference stockPath = stockRef.doc('productos');

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

  DocumentReference<Map<String, dynamic>> path =
      clientesRef.doc(client!.clientDocumentId).collection('pedidos').doc();
  print('path de la factura: ${path.id}');

  return await path.set(
    {
      'cantidadesProductos': quantitiesList,
      'cliente': clientesRef.doc(client.clientDocumentId),
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
      'vendedor': usuariosRef.doc(userUid),
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
  return await clientesRef
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

  final clientID = clientesRef.doc(client.clientDocumentId);
  final date = orderDate;

  var correlativeNumber =
      await configRef.doc('contador_pedidos').get().then((value) {
    return value['numero'];
  });
  const isPaid = false;
  final payments = [];
  final order = clientesRef
      .doc(client.clientDocumentId)
      .collection('pedidos')
      .doc(orderDocumentID);
  final discountPercentage = client.masterDiscount;
  final referenceCreditNote = [];
  final subTotal = subTotalOfTheOrder;
  final register = Timestamp.fromDate(DateTime.now());
  final lastModification = <String, dynamic>{
    'timestamp': register,
    'usuario': usuariosRef.doc(userID),
  };
  final seller = usuariosRef.doc(userID);

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

  await clientesRef
      .doc(client.clientDocumentId)
      .collection('pedidos')
      .doc(orderDocumentID)
      .update({
    'facturado': true,
    'nroCorrelativo': correlativeNumber + 1
  }).whenComplete(() async {
    return await clientesRef
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
      return await configRef
          .doc('contador_pedidos')
          .update({'numero': correlativeNumber + 1});
    }).whenComplete(() {
      if (!globalRemoteConfig.conversionKiosko!) {
        Fluttertoast.showToast(msg: 'Factura ${correlativeNumber + 1}');
      }
    });
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
    return await clientesRef
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
  await bancosRef.where('nombre', isEqualTo: bank).get().then((document) {
    for (var element in document.docs) {
      banksDocumentsID = element.reference.id;
    }
  });

  const cancelled = false;
  final selectedCurrency = currency.toString();
  const concillied = false;
  final timestampDate = Timestamp.fromDate(date!);
  const method = 'Cheque';
  final paidAmount = amount;
  final selectedExchangedRate = coinExchangeRatio;

  try {
    return await clientesRef
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
            'banco': bancosRef.doc(banksDocumentsID),
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
  await bancosRef.where('nombre', isEqualTo: bank).get().then((document) {
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
  final selectedBank = bancosRef.doc(banksDocumentsID);
  final account = int.parse(accountNumber!);
  final voucher = voucherNumber;
  final selectedExchangedRate = coinExchangeRatio;

  try {
    print('Pago registrado correctamente');
    return await clientesRef
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
    return await clientesRef
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
  await bancosRef.where('nombre', isEqualTo: bank).get().then((document) {
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
  final selectedBank = bancosRef.doc(banksDocumentsID);
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
    return await clientesRef
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
  await bancosRef.where('nombre', isEqualTo: bank).get().then((document) {
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
  final selectedBank = bancosRef.doc(banksDocumentsID);
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
    return await clientesRef
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

Future<void> cancelPaymentProcess(Client client, int nroCorrelativo) async {
  Map<String, int> productStockUpdates = {};

  await clientesRef
      .doc(client.clientDocumentId)
      .collection('pedidos')
      .where('nroCorrelativo', isEqualTo: nroCorrelativo)
      .get()
      .then((querySnapshot) {
    for (var doc in querySnapshot.docs) {
      doc.reference.update({'pedidoCancelado': true, 'facturado': true});

      List<dynamic> productos = doc.data()['productos'];
      for (var producto in productos) {
        String id = producto['id'];
        int cantidad = producto['cantidad'];
        productStockUpdates[id] = cantidad;
      }
    }
  });

  await FirebaseFirestore.instance
      .collection('faturas')
      .where('nroCorrelativo', isEqualTo: nroCorrelativo)
      .get()
      .then((querySnapshot) {
    for (var doc in querySnapshot.docs) {
      doc.reference.delete();
    }
  });

  final DocumentReference stockPath = stockRef.doc('productos');
  Map<String, dynamic> currentStock = {};
  await stockPath.get().then(
    (doc) {
      currentStock = doc.data().toString().contains('valores')
          ? doc.get('valores')
          : {'0': 0};
    },
  );

  print('Modifying stock');
  productStockUpdates.forEach((key, value) async {
    int newValue = (currentStock[key] ?? 0) + value;
    await stockPath.update({
      'valores.$key': newValue,
    });
  });
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
      '${element.code}': element.productQuantity,
    };
    productsStock.addEntries(productQuantity.entries);
  });
  print('Cantidades: $quantitiesList');
  print('Cliente: ${clientesRef.doc(client!.clientDocumentId)}');
  print('IDs: $productsIds');
  print('Productos: $products');

  // REDUCE STOCK ON DATABASE

  final DocumentReference stockPath = stockRef.doc('productos');
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

  await clientesRef
      .doc(client.clientDocumentId)
      .collection('pedidos')
      .doc(randomID)
      .set(
    {
      'cantidadesProductos': quantitiesList,
      'cliente': clientesRef.doc(client.clientDocumentId),
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
      'vendedor': usuariosRef.doc(userUid),
    },
  );
  print('/// CREAR FACTURA ///');

  final clientID = clientesRef.doc(client.clientDocumentId);
  final discount = masterDiscount;
  final date = Timestamp.fromDate(DateTime.now());
  final tax = taxTotal;

  var correlativeNumber =
      await configRef.doc('contador_pedidos').get().then((value) {
    return value['numero'];
  });
  const isPaid = false;
  final payments = [];
  final order = clientesRef
      .doc(client.clientDocumentId)
      .collection('pedidos')
      .doc(randomID);
  final masterDiscountPercentage = client.masterDiscount;
  final referenceCreditNote = [];
  final subTotalInvoice = subTotal;
  final register = Timestamp.fromDate(DateTime.now());
  final lastModification = <String, dynamic>{
    'timestamp': register,
    'usuario': usuariosRef.doc(userUid),
  };
  final seller = usuariosRef.doc(userUid);

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

  await clientesRef
      .doc(client.clientDocumentId)
      .collection('pedidos')
      .doc(randomID)
      .update({'facturado': true, 'nroCorrelativo': correlativeNumber + 1});

  await clientesRef
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
    return await configRef
        .doc('contador_pedidos')
        .update({'numero': correlativeNumber + 1});
  }).whenComplete(() {
    if (!globalRemoteConfig.conversionKiosko!) {
      Fluttertoast.showToast(msg: 'Factura ${correlativeNumber + 1}');
    }
  });
  // await test().whenComplete(() {
  //   print('2: $randomID');
  // });

  return correlativeNumber + 1;
}

// Obtener Rol
Future<UserRole?> getUserRol(String rolId) async {
  final rol = await rolesRef.doc(rolId).get();

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
  final storagePath = storage
      .ref()
      .child('imagenes')
      .child('clientes')
      .child(clientDocument.id)
      .child('1');
  print(clientDocument);
  final lastModified = <String, dynamic>{
    'timestamp': Timestamp.now(),
    'usuario': usuariosRef.doc(uid)
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

  await clientDocument.set({
    'activo': true,
    'contribuyenteEspecial': isSpecialContributor,
    'creadoPor': usuariosRef.doc(uid),
    'descuentoMaestro': newClientMasterDiscount,
    'direccionDespacho': newClientAddress2,
    'direccionFiscal': newClientAddress1,
    'email': newClientEmail,
    'fechaRegistro': Timestamp.now(),
    'listaDePrecios': listaDePreciosRef.doc(selectedPricesList),
    'modificado': Timestamp.now(),
    'nombre': newClientName,
    'nombreIndice': output,
    'numeroId': newClientId,
    'prospecto': false,
    'telefono': newclientPhone,
    'telefono2': newclientPhone,
    'tipoId': tiposIdRef.doc(selectedIdType),
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
    final storagePath = storage
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
  final invoiceSnapshot = await clientesRef
      .doc(client.clientDocumentId)
      .collection('facturas')
      .doc(invoiceId)
      .get();

  List payments = invoiceSnapshot.get('pagos');

  final payment = payments[paymentIndex];

  payment['anulado'] = true;
  payment['conciliado'] = false;

  payments[paymentIndex] = payment;

  await clientesRef
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
    print('total: ${total.toStringAsFixed(2)}');
    if (total <= 0.00) {
      print('Factura pagada completamente');
      if (!globalRemoteConfig.conversionKiosko!) {
        Fluttertoast.showToast(
          msg: 'Factura pagada completamente',
          backgroundColor: myTheme.colorScheme.onPrimaryContainer,
          textColor: Colors.white,
        );
      }
      clientesRef
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
