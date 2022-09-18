import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';

class DatabaseService {
  // Colecciones de informacion dentro de la DB

  // Colecciones de productos
  final productsCollection = FirebaseFirestore.instance.collection('productos');

  // Coleccion de Zonas
  final zonesCollection = FirebaseFirestore.instance.collection('zonas');

  // Coleccion de tamanos
  final sizesCollection = FirebaseFirestore.instance.collection('tamanos');

  // Coleccion de sub categorias
  final subCategoriesCollection =
      FirebaseFirestore.instance.collection('subcategorias');

  // Coleccion de stock
  final stockCollection = FirebaseFirestore.instance.collection('stock');

  // Collecion de roles
  final rolesCollection = FirebaseFirestore.instance.collection('roles');

  // Collecion de promociones
  final promotionsCollection =
      FirebaseFirestore.instance.collection('promociones');

  // Collecion de monedas
  final coinCollection = FirebaseFirestore.instance.collection('monedas');

  // Collecion de precios
  final pricesCollection =
      FirebaseFirestore.instance.collection('lista_de_precios');

  // Collecion de lineas
  final linesCollection = FirebaseFirestore.instance.collection('lineas');

  // Collecion de equipos
  final teamsCollection = FirebaseFirestore.instance.collection('equipos');

  // Collecion de dispositivos
  final devicesCollection =
      FirebaseFirestore.instance.collection('dispositivos');

  // Collecion de disenos
  final designsCollection = FirebaseFirestore.instance.collection('disenos');

  // Collecion de config
  final configCollection = FirebaseFirestore.instance.collection('config');

  // Collecion de clientes
  final clientsCollection = FirebaseFirestore.instance.collection('clientes');

  // Collecion de categorias
  final categoriesCollection =
      FirebaseFirestore.instance.collection('categorias');

  // Collecion de catalogo
  final catalogueCollection =
      FirebaseFirestore.instance.collection('catalogos');

  // Collecion de catalogo_productos
  final brandsCollection = FirebaseFirestore.instance.collection('marcas');

  //Coleccion de Calidades
  final qualityCollection = FirebaseFirestore.instance.collection('calidades');

  DatabaseService();

  // Streams

  // Stream de Productos completos

  Stream<List<Products>> get products {
    return productsCollection
        .orderBy('nombre')
        .limit(50)
        .snapshots()
        .map(productsListFromSnapshot);
  }

  // Stream de Productos con promociones

  Stream<List<ProductsWithPromotions>> get productsWithPromotions {
    return productsCollection
        .where('promocion', isNull: false)
        .snapshots()
        .map(productsWithPromotionListFromSnapshot);
  }

  // Stream de los ultimos diez productos modificados en la base de datos

  Stream<List<ProductsByDate>> get productsByDate {
    return productsCollection
        .orderBy('modificado')
        .limit(10)
        .snapshots()
        .map(productsByDateListFromSnapshot);
  }

  // Stream de Stock

  Stream<StockModel> get stockValues {
    return stockCollection
        .doc('productos')
        .snapshots()
        .map(stockListfromSnapshot);
  }

  // Streams de resumenes

  Stream<QualitySummary> get qualitySummary {
    return qualityCollection
        .doc('resumen')
        .snapshots()
        .map(qualitySummaryFromSnapshot);
  }

  Stream<CategorieSummary> get categorieSummary {
    return categoriesCollection
        .doc('resumen')
        .snapshots()
        .map(categorieSummaryFromSnapshot);
  }

  Stream<DesignSummary> get designSummary {
    return designsCollection
        .doc('resumen')
        .snapshots()
        .map(designSummaryFromSnapshot);
  }

  Stream<LineSummary> get lineSummary {
    return linesCollection
        .doc('resumen')
        .snapshots()
        .map(lineSummaryFromSnapshot);
  }

  Stream<BrandSummary> get brandSummary {
    return brandsCollection
        .doc('resumen')
        .snapshots()
        .map(brandSummaryFromSnapshot);
  }

  Stream<SubCategorieSummary> get subCategorieSummary {
    return subCategoriesCollection
        .doc('resumen')
        .snapshots()
        .map(subCategoriesFromSnapshot);
  }

  Stream<SizeSummary> get sizeSummary {
    return sizesCollection
        .doc('resumen')
        .snapshots()
        .map(sizeSummaryFromSnapshot);
  }
}
