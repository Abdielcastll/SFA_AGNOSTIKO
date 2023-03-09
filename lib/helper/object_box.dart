import 'package:pwa_sales2go_flutter/objectbox.g.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';

class ObjectBox {
  late final Store _store;
  late final Box<ShoppingCartProduct> _shoppingCartProductBox;

  ObjectBox._init(this._store) {
    _shoppingCartProductBox = Box<ShoppingCartProduct>(_store);
  }

  static Future<ObjectBox> init() async {
    final store = await openStore();

    return ObjectBox._init(store);
  }

  ShoppingCartProduct? getShoppingCartProduct(int id) =>
      _shoppingCartProductBox.get(id);

  Stream<List<ShoppingCartProduct>> getShoppingCartProducts() =>
      _shoppingCartProductBox
          .query()
          .watch(triggerImmediately: true)
          .map((query) => query.find());

  List<ShoppingCartProduct> getAllShoppingCartProducts() =>
      _shoppingCartProductBox.getAll();

  int insertShoppingCartProduct(ShoppingCartProduct newProduct) =>
      _shoppingCartProductBox.put(newProduct);

  insertManyShoppingCartProducts(List<ShoppingCartProduct> newProducts) =>
      _shoppingCartProductBox.putMany(newProducts);

  bool deleteShoppingCartProduct(int id) => _shoppingCartProductBox.remove(id);

  delelteAllShoppingCart() => _shoppingCartProductBox.removeAll();

  // updateShoppingCartProduct() => _shoppingCartProductBox.
}
