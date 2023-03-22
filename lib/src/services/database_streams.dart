import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/promotions_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';

class DatabaseServiceStreams {
  var prissa = FirebaseFirestore.instance
      .collection('marcas')
      .doc('fekpFNxAR5U9PZko1XWq');
  // Streams de productos

  // Stream de Productos completos

  Stream<List<Products>> get products {
    return productsCollection
        // .orderBy('nombre')
        // .limit(200)
        .snapshots()
        .map(productsListFromSnapshot);
  }

  // Stream de Productos con promociones

  Stream<List<ProductsWithPromotions>> get productsWithPromotions {
    return productsCollection
        .where('promocion', isNull: false)
        // .where('marca', isEqualTo: prissa)
        .snapshots()
        .map(productsWithPromotionListFromSnapshot);
  }

  // Stream de promociones

  Stream<List<Promotions>> get promotions {
    return promotionsCollection
        .where('fecha_vencimiento',
            isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
        .orderBy('fecha_vencimiento', descending: true)
        .snapshots()
        .map(promotionListfromSnapshot);
  }

  // Stream de los ultimos diez productos modificados en la base de datos

  Stream<List<ProductsByDate>> get productsByDate {
    return productsCollection
        .orderBy('modificado', descending: true)
        .where('marca', isEqualTo: prissa)
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

  // Streams de Clientes

  // Stream de Clientes completos

  Stream<List<Clients>> get clients {
    return clientsCollection.snapshots().map(clientListfromSnapshot);
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

  Stream<ZoneSummary> get zoneSummary {
    return zonesCollection
        .doc('resumen')
        .snapshots()
        .map(zoneSummaryFromSnapshot);
  }

  Stream<IdTypeSummary> get idTypeSummary {
    return idTypeCollection
        .doc('resumen')
        .snapshots()
        .map(idTypeSummaryFromSnapshot);
  }
}
