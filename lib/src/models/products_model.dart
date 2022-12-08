import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
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
  final promotion;
  bool selected;

  Products({
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
    this.promotion,
    required this.selected,
  });
}

class ProductsWithPromotions {
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
  final promotion;
  bool selected;

  ProductsWithPromotions({
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
    this.promotion,
    required this.selected,
  });
}

class ProductsByDate {
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
  final promotion;
  bool selected;

  ProductsByDate({
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
    this.promotion,
    required this.selected,
  });
}

List<Products> productsListFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return Products(
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
      promotion: doc.data().toString().contains('promocion')
          ? doc.get('promocion').id
          : '',
      selected: false,
    );
  }).toList();
}

List<ProductsWithPromotions> productsWithPromotionListFromSnapshot(
    QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return ProductsWithPromotions(
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
      promotion: doc.data().toString().contains('promocion')
          ? doc.get('promocion').id
          : null,
      selected: false,
    );
  }).toList();
}

List<ProductsByDate> productsByDateListFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return ProductsByDate(
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
      promotion: doc.data().toString().contains('promocion')
          ? doc.get('promocion').id
          : null,
      selected: false,
    );
  }).toList();
}
