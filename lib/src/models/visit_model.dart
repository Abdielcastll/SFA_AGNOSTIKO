import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final documentRefId;

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
    this.documentRefId,
  });
}

List<Visits> visitsFromSnasphot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return Visits(
      isCancelled: doc.data().toString().contains('cancelada')
          ? doc.get('cancelada')
          : false,
      clientReferenceId: doc.data().toString().contains('cliente')
          ? doc.get('cliente').id
          : '',
      isCompleted: doc.data().toString().contains('completada')
          ? doc.get('completada')
          : false,
      commentary: doc.data().toString().contains('comentario')
          ? doc.get('comentario')
          : '',
      madeByReferenceId: doc.data().toString().contains('creadoPor')
          ? doc.get('creadoPor').id
          : '',
      date: doc.data().toString().contains('fecha') ? doc.get('fecha') : '',
      noCobranza: doc.data().toString().contains('noCobranza')
          ? doc.get('noCobranza')
          : '',
      noPedido:
          doc.data().toString().contains('noPedido') ? doc.get('noPedido') : '',
      noVisita:
          doc.data().toString().contains('noVisita') ? doc.get('noVisita') : '',
      timeStampRegister: doc.data().toString().contains('timestampRegistro')
          ? doc.get('timestampRegistro')
          : '',
      lastModified: doc.data().toString().contains('ultimaModificacion')
          ? doc.get('ultimaModificacion')
          : '',
      sellerReferenceId: doc.data().toString().contains('vendedor')
          ? doc.get('vendedor').id
          : '',
      documentRefId: doc.reference.id,
    );
  }).toList();
}
