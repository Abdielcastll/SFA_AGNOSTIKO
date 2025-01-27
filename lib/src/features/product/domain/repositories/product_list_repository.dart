import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:pwa_sales2go_flutter/src/features/product/domain/entitites/base_product_entity.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/utils/multitenant-config.dart'; // For compute

Future<List<BaseProductEntity>> getDataForSubcategoriesList() async {
  final HttpsCallable function =
      FirebaseFunctions.instanceFor(app: multitenantConfig.tenantApp!)
          .httpsCallable('getCatalogoProductos');

  try {
    final response = await function();
    // Check if data is a List and cast it accordingly
    if (response.data is List) {
      final data = List<Map<String, dynamic>>.from(
          (response.data as List<dynamic>)
              .map((e) => Map<String, dynamic>.from(e)));
      // Offload JSON parsing to a background thread
      return await compute(_parseProductList, data);
    } else {
      debugPrint("Expected List but got ${response.data.runtimeType}");
      return [];
    }
  } catch (e) {
    debugPrint("Error fetching product data: $e");
    return [];
  }
}

// Function to parse JSON in the background
List<BaseProductEntity> _parseProductList(List<Map<String, dynamic>> data) {
  return data.map((item) => BaseProductEntity.fromJson(item)).toList();
}

Future<String> getImageUrl(String code) async {
  return storage
      .ref()
      .child('imagenes')
      .child('productos')
      .child(code)
      .child('1')
      .getDownloadURL();
}
