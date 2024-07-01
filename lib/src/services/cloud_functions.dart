import 'package:cloud_functions/cloud_functions.dart';
import 'package:pwa_sales2go_flutter/src/utils/multitenant-config.dart';

Future<List> getDataFromBQ(String query) async {
  HttpsCallable function =
      FirebaseFunctions.instanceFor(app: multitenantConfig.tenantApp!)
          .httpsCallable('getDataFromBQ');

  final result = await function({
    "query": query,
  });
  return result.data as List;

  // print(result.data);
}

const queryProductosMasVendidos =
    '''SELECT Count(*) as cantidad, ped.codigo, ped.nombre, prod.catalogo, prod.linea, prod.calidad, prod.categoria, prod.diseno, prod.marca, prod.subcategoria, prod.tamano
FROM `pwa-sales2go.pedidos_export.pedidos_productos` as ped
INNER JOIN `pwa-sales2go.productos_export.productos` as prod
ON prod.codigo = ped.codigo
WHERE timestamp_diff(CURRENT_TIMESTAMP(), ped.fecha, DAY) <= 90
group by ped.codigo, ped.nombre, prod.catalogo, prod.linea, prod.calidad, prod.categoria, prod.diseno, prod.marca, prod.subcategoria, prod.tamano
order by cantidad desc
LIMIT 10''';

Future sendNotification(String subjectId, String title, String body) async {
  HttpsCallable function =
      FirebaseFunctions.instanceFor(app: multitenantConfig.tenantApp!)
          .httpsCallable('sendNotification');

  function({'recieverId': subjectId, 'title': title, 'body': body});
}
