import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';

// Funciones de Visitas

Future createVisitData(
    String userUid, String clientDocumentId, DateTime date) async {
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
    String docId, String? status, String uid, String? commentary) async {
  print('// ACTUALIZAR ESTADO DE LA VISITA //');
  bool isCompleted = false;
  bool isCancelled = false;
  if (status != null) {
    if (status == 'Completada') {
      isCompleted = true;
    } else if (status == 'Cancelada') {
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

Future deleteVisit(String docId, String uid) async {
  print('Borrar Visita');
  return await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(uid)
      .collection('visitas')
      .doc(docId)
      .delete();
}

// Funciones de Pedidos

Future deleteOrder(String docId, String clientId) async {
  print('Borrar pedido');
  return await FirebaseFirestore.instance
      .collection('clientes')
      .doc(clientId)
      .collection('pedidos')
      .doc(docId)
      .delete();
}
