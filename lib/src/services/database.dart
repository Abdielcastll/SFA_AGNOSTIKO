import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/models/brands_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/idtype_model.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/promotions_model.dart';
import 'package:pwa_sales2go_flutter/src/models/sizes_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/subcategories_model.dart';
import 'package:pwa_sales2go_flutter/src/models/zones_model.dart';

class DatabaseService {
  // Coleccion de Productos
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('productos');
  // Coleccion de Zonas
  final CollectionReference zonesCollection =
      FirebaseFirestore.instance.collection('zonas');
  // Coleccion de tamanos
  final CollectionReference sizesCollection =
      FirebaseFirestore.instance.collection('tamanos');
  // Coleccion de sub categorias
  final CollectionReference subCategoriesCollection =
      FirebaseFirestore.instance.collection('subcategorias');
  // Coleccion de stock
  final CollectionReference stockCollection =
      FirebaseFirestore.instance.collection('stock');
  // Collecion de roles
  final CollectionReference rolesCollection =
      FirebaseFirestore.instance.collection('roles');
  // Collecion de promociones
  final CollectionReference promotionsCollection =
      FirebaseFirestore.instance.collection('promociones');
  // Collecion de monedas
  final CollectionReference coinCollection =
      FirebaseFirestore.instance.collection('monedas');
  // Collecion de precios
  final CollectionReference pricesCollection =
      FirebaseFirestore.instance.collection('lista_de_precios');
  // Collecion de lineas
  final CollectionReference linesCollection =
      FirebaseFirestore.instance.collection('lineas');
  // Collecion de equipos
  final CollectionReference teamsCollection =
      FirebaseFirestore.instance.collection('equipos');
  // Collecion de dispositivos
  final CollectionReference devicesCollection =
      FirebaseFirestore.instance.collection('dispositivos');
  // Collecion de disenos
  final CollectionReference designsCollection =
      FirebaseFirestore.instance.collection('disenos');
  // Collecion de config
  final CollectionReference configCollection =
      FirebaseFirestore.instance.collection('config');
  // Collecion de clientes
  final CollectionReference clientsCollection =
      FirebaseFirestore.instance.collection('clientes');
  // Collecion de categorias
  final CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection('categorias');
  // Collecion de catalogo
  final CollectionReference catalogueCollection =
      FirebaseFirestore.instance.collection('catalogos');
  // Collecion de catalogo_productos
  final CollectionReference catalogueProductsCollection =
      FirebaseFirestore.instance.collection('catalogo_productos');
  // Collecion de calidades
  final CollectionReference qualitiesCollection =
      FirebaseFirestore.instance.collection('calidades');
  // Collecion de bancos
  final CollectionReference banksCollection =
      FirebaseFirestore.instance.collection('bancos');
  // Collecion de bancos
  final CollectionReference idTypesCollection =
      FirebaseFirestore.instance.collection('tipos_id');
  // Collection de marcas
  final CollectionReference brandsCollection =
      FirebaseFirestore.instance.collection('marcas');

  DatabaseService();

  ////////////////////// Streams ///////////////////////////////

  // get products stream
  Stream<List<ProductModel>> get products {
    return productsCollection
        .snapshots()
        .map((ProductsFromSnashot().productListfromSnapshot));
  }

  // get zones stream
  Stream<List<ZonesModel>> get zones {
    return zonesCollection
        .snapshots()
        .map((ZonesfromSnapshot().zoneListfromSnapshot));
  }

  // get idTypes stream
  Stream<List<IdTypeModel>> get idTypes {
    return idTypesCollection
        .snapshots()
        .map((IdTypefromSnapshot().idTypeListfromSnapshot));
  }

  // get sizes stream
  Stream<List<SizesModel>> get sizes {
    return sizesCollection
        .snapshots()
        .map((SizefromSnapshot().sizesListfromSnapshot));
  }

  // get sub categorie stream
  Stream<List<SubCategoriesModel>> get subCategorie {
    return subCategoriesCollection
        .snapshots()
        .map((SubCategoriefromSnapshot().subCategorieListfromSnapshot));
  }

  // get stock stream
  Stream<List<StockModel>> get stock {
    return subCategoriesCollection
        .snapshots()
        .map((StockfromSnapshot().stockListfromSnapshot));
  }

  // get promotions stream
  Stream<List<PromotionModel>> get promotion {
    return promotionsCollection
        .snapshots()
        .map((PromotionfromSnapshot().promotionListfromSnapshot));
  }

  // get coin stream
  Stream<List<CoinModel>> get coin {
    return coinCollection
        .snapshots()
        .map((CoinfromSnapshot().coinListfromSnapshot));
  }

  // get line stream
  Stream<List<BrandModel>> get brand {
    return brandsCollection
        .snapshots()
        .map((BrandfromSnapshot().brandListfromSnapshot));
  }

  // get prices stream
  Stream<List<PricesModel>> get price {
    return pricesCollection
        .snapshots()
        .map((PricesfromSnapshot().priceListfromSnapshot));
  }
}
