import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pwa_sales2go_flutter/src/models/banks_model.dart';
import 'package:pwa_sales2go_flutter/src/models/brands_model.dart';
import 'package:pwa_sales2go_flutter/src/models/catalogue_model.dart';
import 'package:pwa_sales2go_flutter/src/models/catalogue_products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/categories_model.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/design_model.dart';
import 'package:pwa_sales2go_flutter/src/models/devices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/idtype_model.dart';
import 'package:pwa_sales2go_flutter/src/models/lines_model.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/promotions_model.dart';
import 'package:pwa_sales2go_flutter/src/models/quality_model.dart';
import 'package:pwa_sales2go_flutter/src/models/sizes_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/subcategories_model.dart';
import 'package:pwa_sales2go_flutter/src/models/teams_model.dart';
import 'package:pwa_sales2go_flutter/src/models/zones_model.dart';

class DatabaseService {
  // Coleccion de Productos
  final productsCollection = FirebaseFirestore.instance
      .collection('productos')
      .orderBy('nombre')
      .limit(3);
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

  // get lines stream
  Stream<List<LineModel>> get line {
    return linesCollection
        .snapshots()
        .map((LinefromSnapshot().lineListfromSnapshot));
  }

  // get teams stream
  Stream<List<TeamsModel>> get team {
    return teamsCollection
        .snapshots()
        .map((TeamfromSnapshot().teamListfromSnapshot));
  }

  // get devices stream
  Stream<List<DeviceModel>> get device {
    return devicesCollection
        .snapshots()
        .map((DevicefromSnapshot().deviceListfromSnapshot));
  }

  // get designs stream
  Stream<List<DesignModel>> get design {
    return designsCollection
        .snapshots()
        .map((DesignfromSnapshot().designListfromSnapshot));
  }

  // get clients stream
  Stream<List<ClientModel>> get client {
    return clientsCollection
        .snapshots()
        .map((ClientfromSnapshot().clientListfromSnapshot));
  }

  // get categories stream
  Stream<List<CategorieModel>> get categorie {
    return categoriesCollection
        .snapshots()
        .map((CategoriefromSnapshot().categorieListfromSnapshot));
  }

  // get catalogue strema
  Stream<List<CatalogueModel>> get catalogue {
    return catalogueCollection
        .snapshots()
        .map((CataloguefromSnapshot().catalogueListfromSnapshot));
  }

  Stream<List<CatalogueProductsModel>> get catalogueProduct {
    return catalogueProductsCollection
        .snapshots()
        .map((CatalogueProductfromSnapshot().idTypeListfromSnapshot));
  }

  Stream<List<QualityModel>> get quality {
    return qualitiesCollection
        .snapshots()
        .map((QualityfromSnapshot().qualityListfromSnapshot));
  }

  Stream<List<BankModel>> get bank {
    return banksCollection
        .snapshots()
        .map((BankfromSnapshot().bankListfromSnapshot));
  }
}
