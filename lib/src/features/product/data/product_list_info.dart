import 'package:pwa_sales2go_flutter/src/features/product/domain/entitites/base_product_entity.dart';
import 'package:pwa_sales2go_flutter/src/features/product/domain/repositories/product_list_repository.dart';

class ProductListInfo {
  static final ProductListInfo _instance = ProductListInfo._();
  static bool _initialized = false;
  static List<BaseProductEntity> _products = [];

  ProductListInfo._();
  
  static Future<ProductListInfo> get instance async {
    if(!_initialized || _products.isEmpty) {
      await _instance._fetchProducts();
      _initialized = true;
    }

    return _instance;
  }

  static List<BaseProductEntity> get products => _products;

  Future<void> _fetchProducts() async {
    _products = await getDataForSubcategoriesList();
  }  
}