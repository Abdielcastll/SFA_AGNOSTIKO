import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  final productsQuantity;
  final clientDocumentRef;
  final commentary;
  final masterDiscount;
  final deliveryAddress;
  final isInvoiceFailed;
  final isInvoiced;
  final date;
  final deliveryDate;
  final tax;
  final correlativeNumber;
  final orderNumber;
  final percentageMasterDiscount;
  final percentageTax;
  final products;
  final subTotal;
  final exchangeRate;
  final timestampRegister;
  final totalAmount;
  final lastModification;
  final sellerDocumentRef;
  final orderDocumentRef;

  Orders({
    this.productsQuantity,
    this.clientDocumentRef,
    this.commentary,
    this.masterDiscount,
    this.deliveryAddress,
    this.isInvoiceFailed,
    this.isInvoiced,
    this.date,
    this.deliveryDate,
    this.tax,
    this.correlativeNumber,
    this.orderNumber,
    this.percentageMasterDiscount,
    this.percentageTax,
    this.products,
    this.subTotal,
    this.exchangeRate,
    this.timestampRegister,
    this.totalAmount,
    this.lastModification,
    this.sellerDocumentRef,
    this.orderDocumentRef,
  });
}

class ClientOrder {
  final productsQuantity;
  final clientDocumentRef;
  final commentary;
  final masterDiscount;
  final deliveryAddress;
  final isInvoiceFailed;
  final isInvoiced;
  final date;
  final deliveryDate;
  final tax;
  final correlativeNumber;
  final orderNumber;
  final percentageMasterDiscount;
  final percentageTax;
  final products;
  final subTotal;
  final exchangeRate;
  final timestampRegister;
  final totalAmount;
  final lastModification;
  final sellerDocumentRef;
  final orderDocumentRef;

  ClientOrder({
    this.productsQuantity,
    this.clientDocumentRef,
    this.commentary,
    this.masterDiscount,
    this.deliveryAddress,
    this.isInvoiceFailed,
    this.isInvoiced,
    this.date,
    this.deliveryDate,
    this.tax,
    this.correlativeNumber,
    this.orderNumber,
    this.percentageMasterDiscount,
    this.percentageTax,
    this.products,
    this.subTotal,
    this.exchangeRate,
    this.timestampRegister,
    this.totalAmount,
    this.lastModification,
    this.sellerDocumentRef,
    this.orderDocumentRef,
  });
}

List<Orders> ordersFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return Orders(
      productsQuantity: doc.data().toString().contains('cantidadesProductos')
          ? doc.get('cantidadesProductos')
          : 'NaN',
      clientDocumentRef: doc.data().toString().contains('cliente')
          ? doc.get('cliente').id
          : 'NaN',
      commentary: doc.data().toString().contains('comentario')
          ? doc.get('comentario')
          : 'NaN',
      masterDiscount: doc.data().toString().contains('descuentoMaestro')
          ? doc.get('descuentoMaestro')
          : 0,
      deliveryAddress: doc.data().toString().contains('direccionEntrega')
          ? doc.get('direccionEntrega')
          : 'NaN',
      isInvoiceFailed: doc.data().toString().contains('facuracionFallida')
          ? doc.get('facuracionFallida')
          : false,
      isInvoiced: doc.data().toString().contains('facturado')
          ? doc.get('facturado')
          : false,
      date: doc.data().toString().contains('fecha')
          ? doc.get('fecha')
          : Timestamp.fromDate(DateTime.now()),
      deliveryDate: doc.data().toString().contains('fechaEntrega')
          ? doc.get('fechaEntrega')
          : Timestamp.fromDate(DateTime.now()),
      tax: doc.data().toString().contains('impuesto') ? doc.get('impuesto') : 0,
      correlativeNumber: doc.data().toString().contains('nroCorrelativo')
          ? doc.get('nroCorrelativo')
          : 0,
      orderNumber: doc.data().toString().contains('ordenDeCompra')
          ? doc.get('ordenDeCompra')
          : 0,
      percentageMasterDiscount:
          doc.data().toString().contains('procentajeDescuentoMaestro')
              ? doc.get('procentajeDescuentoMaestro')
              : 0,
      percentageTax: doc.data().toString().contains('porcentajeImpuesto')
          ? doc.get('porcentajeImpuesto')
          : 0,
      products: doc.data().toString().contains('productos')
          ? doc.get('productos')
          : 'NaN',
      subTotal:
          doc.data().toString().contains('subtotal') ? doc.get('subtotal') : 0,
      exchangeRate: doc.data().toString().contains('tasasDeCambio')
          ? doc.get('tasasDeCambio')
          : 'NaN',
      timestampRegister: doc.data().toString().contains('timestampRegistro')
          ? doc.get('timestampRegistro')
          : 'NaN',
      totalAmount: doc.data().toString().contains('totalAPagar')
          ? doc.get('totalAPagar')
          : 0,
      lastModification: doc.data().toString().contains('ultimaModificacion')
          ? doc.get('ultimaModificacion')
          : 'NaN',
      sellerDocumentRef: doc.data().toString().contains('vendedor')
          ? doc.get('vendedor').id
          : 'NaN',
      orderDocumentRef: doc.reference.id,
    );
  }).toList();
}

ClientOrder orderFromdocument(doc) {
  return ClientOrder(
    productsQuantity: doc.data().toString().contains('cantidadesProductos')
        ? doc.get('cantidadesProductos')
        : 'NaN',
    clientDocumentRef: doc.data().toString().contains('cliente')
        ? doc.get('cliente').id
        : 'NaN',
    commentary: doc.data().toString().contains('comentario')
        ? doc.get('comentario')
        : 'NaN',
    masterDiscount: doc.data().toString().contains('descuentoMaestro')
        ? doc.get('descuentoMaestro')
        : 0,
    deliveryAddress: doc.data().toString().contains('direccionEntrega')
        ? doc.get('direccionEntrega')
        : 'NaN',
    isInvoiceFailed: doc.data().toString().contains('facuracionFallida')
        ? doc.get('facuracionFallida')
        : false,
    isInvoiced: doc.data().toString().contains('facturado')
        ? doc.get('facturado')
        : false,
    date: doc.data().toString().contains('fecha')
        ? doc.get('fecha')
        : Timestamp.fromDate(DateTime.now()),
    deliveryDate: doc.data().toString().contains('fechaEntrega')
        ? doc.get('fechaEntrega')
        : Timestamp.fromDate(DateTime.now()),
    tax: doc.data().toString().contains('impuesto') ? doc.get('impuesto') : 0,
    correlativeNumber: doc.data().toString().contains('nroCorrelativo')
        ? doc.get('nroCorrelativo')
        : 0,
    orderNumber: doc.data().toString().contains('ordenDeCompra')
        ? doc.get('ordenDeCompra')
        : 0,
    percentageMasterDiscount:
        doc.data().toString().contains('procentajeDescuentoMaestro')
            ? doc.get('procentajeDescuentoMaestro')
            : 0,
    percentageTax: doc.data().toString().contains('porcentajeImpuesto')
        ? doc.get('porcentajeImpuesto')
        : 0,
    products: doc.data().toString().contains('productos')
        ? doc.get('productos')
        : 'NaN',
    subTotal:
        doc.data().toString().contains('subtotal') ? doc.get('subtotal') : 0,
    exchangeRate: doc.data().toString().contains('tasasDeCambio')
        ? doc.get('tasasDeCambio')
        : 'NaN',
    timestampRegister: doc.data().toString().contains('timestampRegistro')
        ? doc.get('timestampRegistro')
        : 'NaN',
    totalAmount: doc.data().toString().contains('totalAPagar')
        ? doc.get('totalAPagar')
        : 0,
    lastModification: doc.data().toString().contains('ultimaModificacion')
        ? doc.get('ultimaModificacion')
        : 'NaN',
    sellerDocumentRef: doc.data().toString().contains('vendedor')
        ? doc.get('vendedor').id
        : 'NaN',
    orderDocumentRef: doc.reference.id,
  );
}
