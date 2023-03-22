import 'package:cloud_firestore/cloud_firestore.dart';

class Invoices {
  final clientIdReference;
  final masterDiscountAmount;
  final orderDate;
  final double taxAmount;
  final totalAmount;
  final correlativeNumber;
  final isPaid;
  final payments;
  final orderIdReference;
  final masterDiscountPercentage;
  final taxPercentage;
  final creditNotesReference;
  final subTotalAmount;
  final registerDate;
  final lastModified;
  final seller;
  final invoiceDocumentID;

  Invoices({
    this.clientIdReference,
    this.masterDiscountAmount,
    this.orderDate,
    required this.taxAmount,
    this.totalAmount,
    this.correlativeNumber,
    this.isPaid,
    this.payments,
    this.orderIdReference,
    this.masterDiscountPercentage,
    this.taxPercentage,
    this.creditNotesReference,
    this.subTotalAmount,
    this.registerDate,
    this.lastModified,
    this.seller,
    this.invoiceDocumentID,
  });
}

List<Invoices> accountInvoicesFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return Invoices(
      clientIdReference: doc.data().toString().contains('cliente')
          ? doc.get('cliente').id
          : 'NaN',
      masterDiscountAmount: doc.data().toString().contains('descuentoMaestro')
          ? doc.get('descuentoMaestro')
          : 'NaN',
      orderDate: doc.data().toString().contains('fecha')
          ? doc.get('fecha')
          : Timestamp.fromDate(DateTime(2222)),
      taxAmount:
          doc.data().toString().contains('impuesto') ? doc.get('impuesto') : 0,
      totalAmount: doc.data().toString().contains('montoTotal')
          ? doc.get('montoTotal')
          : 0,
      correlativeNumber: doc.data().toString().contains('nroCorrelativo')
          ? doc.get('nroCorrelativo')
          : 0,
      isPaid:
          doc.data().toString().contains('pagada') ? doc.get('pagada') : false,
      payments: doc.data().toString().contains('pagos') ? doc.get('pagos') : [],
      orderIdReference: doc.data().toString().contains('pedido')
          ? doc.get('pedido').id
          : 'NaN',
      masterDiscountPercentage:
          doc.data().toString().contains('porcentajeDescuentoMaestro')
              ? doc.get('porcentajeDescuentoMaestro')
              : 0,
      taxPercentage: doc.data().toString().contains('porcentajeImpuesto')
          ? doc.get('porcentajeImpuesto')
          : 0,
      creditNotesReference:
          doc.data().toString().contains('referenciaNotasCredito')
              ? doc.get('referenciaNotasCredito')
              : 0,
      subTotalAmount:
          doc.data().toString().contains('subtotal') ? doc.get('subtotal') : 0,
      registerDate: doc.data().toString().contains('timestampRegistro')
          ? doc.get('timestampRegistro')
          : Timestamp.fromDate(DateTime(2222)),
      lastModified: doc.data().toString().contains('ultimaModificacion')
          ? doc.get('ultimaModificacion')
          : [],
      seller: doc.data().toString().contains('vendedor')
          ? doc.get('vendedor').id
          : 'NaN',
      invoiceDocumentID: doc.reference.id,
    );
  }).toList();
}

class CreditNotes {
  final clientIdReference;
  final paymentsData;
  final date;
  final totalAmount;
  final correlativeNumber;
  final payments;
  final refCreatedBy;
  final refPayments;
  final isValid;
  final isEliminated;

  CreditNotes({
    this.clientIdReference,
    this.paymentsData,
    this.date,
    this.totalAmount,
    this.correlativeNumber,
    this.payments,
    this.refCreatedBy,
    this.refPayments,
    this.isValid,
    this.isEliminated,
  });
}

List<CreditNotes> accountCreditNotesFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return CreditNotes(
      clientIdReference: doc.data().toString().contains('cliente')
          ? doc.get('cliente').id
          : 'NaN',
      paymentsData: doc.data().toString().contains('datosDePago')
          ? doc.get('datosDePago')
          : 'NaN',
      date: doc.data().toString().contains('fecha') ? doc.get('fecha') : 'NaN',
      totalAmount: doc.data().toString().contains('montoTotal')
          ? doc.get('montoTotal')
          : 0,
      correlativeNumber: doc.data().toString().contains('nroCorrelativo')
          ? doc.get('nroCorrelativo')
          : 0,
      isValid: doc.data().toString().contains('vigente')
          ? doc.get('vigente')
          : 'NaN',
      isEliminated: doc.data().toString().contains('eliminado')
          ? doc.get('eliminado')
          : false,
    );
  }).toList();
}
// doc.data().toString().contains('modificado') ? doc.get('modificado') : 'NaN',