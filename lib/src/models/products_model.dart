import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String name;
  final String id;
  final dynamic quality;
  final dynamic catalogue;
  final dynamic categorie;
  final dynamic subCategorie;
  final dynamic size;
  final dynamic codeIndex;
  final dynamic design;
  final dynamic line;
  final dynamic brand;

  ProductModel({
    required this.name,
    required this.id,
    required this.quality,
    required this.catalogue,
    required this.categorie,
    required this.subCategorie,
    required this.size,
    required this.codeIndex,
    required this.design,
    required this.line,
    required this.brand,
  });
}

class ProductsFromSnashot {
  List<ProductModel> productListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ProductModel(
        name: doc.get('nombre'),
        id: doc.get('codigo'),
        quality: doc.get('calidad'),
        catalogue: doc.get('catalogo'),
        categorie: doc.get('categoria'),
        subCategorie: doc.get('subcategoria'),
        size: doc.get('tamano'),
        codeIndex: doc.get('codigoIndice'),
        design: doc.get('diseno'),
        line: doc.get('linea'),
        brand: doc.get('marca'),
      );
    }).toList();
  }
}
