import 'package:cloud_functions/cloud_functions.dart';
import 'package:pwa_sales2go_flutter/src/utils/multitenant-config.dart';

Future<List?> getDataFromBQ() async {
  String projectId = multitenantConfig.tenantApp!.options.projectId!;
  String queryProductosMasVendidos =
      '''SELECT Count(*) as cantidad, ped.codigo, ped.nombre, prod.catalogo, prod.linea, prod.calidad, prod.categoria, prod.diseno, prod.marca, prod.subcategoria, prod.tamano
FROM `$projectId.pedidos_export.pedidos_productos` as ped
INNER JOIN `$projectId.productos_export.productos` as prod
ON prod.codigo = ped.codigo
WHERE timestamp_diff(CURRENT_TIMESTAMP(), ped.fecha, DAY) <= 90
group by ped.codigo, ped.nombre, prod.catalogo, prod.linea, prod.calidad, prod.categoria, prod.diseno, prod.marca, prod.subcategoria, prod.tamano
order by cantidad desc
LIMIT 10''';

  HttpsCallable function =
      FirebaseFunctions.instanceFor(app: multitenantConfig.tenantApp!)
          .httpsCallable('getDataFromBQ');

  final result = await function({
    "query": queryProductosMasVendidos,
  });
  print("result bq:");
  print(result.data);
  return result.data as List;

  // print(result.data);
}

Future sendNotification(String subjectId, String title, String body) async {
  HttpsCallable function =
      FirebaseFunctions.instanceFor(app: multitenantConfig.tenantApp!)
          .httpsCallable('sendNotification');

  function({'recieverId': subjectId, 'title': title, 'body': body});
}
