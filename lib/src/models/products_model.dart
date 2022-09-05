import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final quality;
  final catalogue;
  final categorie;
  final code;
  final design;
  final line;
  final brand;
  final lastModifiedDate;
  final name;
  final subCategorie;
  final size;

  ProductModel({
    required this.quality,
    required this.catalogue,
    required this.categorie,
    required this.code,
    required this.design,
    required this.line,
    required this.brand,
    required this.lastModifiedDate,
    required this.name,
    required this.subCategorie,
    required this.size,
  });
}

List<ProductModel> productListfromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return ProductModel(
      quality: doc.get('calidad').id,
      catalogue: doc.get('catalogo').id,
      categorie: doc.get('categoria').id,
      code: doc.get('codigo'),
      design: doc.get('diseno').id,
      line: doc.get('linea').id,
      brand: doc.get('marca').id,
      lastModifiedDate: doc.get('modificado'),
      name: doc.get('nombre'),
      subCategorie: doc.get('subcategoria').id,
      size: doc.get('tamano').id,
    );
  }).toList();
}
