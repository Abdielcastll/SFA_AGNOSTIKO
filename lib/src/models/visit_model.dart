import 'package:cloud_firestore/cloud_firestore.dart';

class Visits {
  final isCancelled;
  final clientReferenceId;
  final isCompleted;
  final commentary;
  final madeByReferenceId;
  final date;
  final noCobranza;
  final noPedido;
  final noVisita;
  final timeStampRegister;
  final lastModified;
  final sellerReferenceId;

  Visits({
    this.isCancelled,
    this.clientReferenceId,
    this.isCompleted,
    this.commentary,
    this.madeByReferenceId,
    this.date,
    this.noCobranza,
    this.noPedido,
    this.noVisita,
    this.timeStampRegister,
    this.lastModified,
    this.sellerReferenceId,
  });
}

List<Visits> visitsFromSnasphot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return Visits(
      isCancelled: doc.data().toString().contains('cancelada')
          ? doc.get('cancelada')
          : 'NaN',
      clientReferenceId: doc.data().toString().contains('cliente')
          ? doc.get('cliente').id
          : 'NaN',
      isCompleted: doc.data().toString().contains('completed')
          ? doc.get('completed')
          : 'NaN',
      commentary: doc.data().toString().contains('comentario')
          ? doc.get('comentario')
          : 'No hay comentario hecho',
      madeByReferenceId: doc.data().toString().contains('creadoPor')
          ? doc.get('creadoPor').id
          : 'NaN',
      date: doc.data().toString().contains('fecha') ? doc.get('fecha') : 'NaN',
      noCobranza: doc.data().toString().contains('noCobranza')
          ? doc.get('noCobranza')
          : 'NaN',
      noPedido: doc.data().toString().contains('noPedido')
          ? doc.get('noPedido')
          : 'NaN',
      noVisita: doc.data().toString().contains('noVisita')
          ? doc.get('noVisita')
          : 'NaN',
      timeStampRegister: doc.data().toString().contains('timestampRegistro')
          ? doc.get('timestampRegistro')
          : 'NaN',
      lastModified: doc.data().toString().contains('ultimaModificacion')
          ? doc.get('ultimaModificacion')
          : 'NaN',
      sellerReferenceId: doc.data().toString().contains('vendedor')
          ? doc.get('vendedor').id
          : 'NaN',
    );
  }).toList();
}
