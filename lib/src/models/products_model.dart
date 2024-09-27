import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  final quality;
  final String? catalogue;
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
  final barCode;
  bool selected;

  Products({
    required this.quality,
    this.catalogue,
    required this.categorie,
    required this.code,
    required this.design,
    required this.line,
    required this.brand,
    required this.lastModifiedDate,
    required this.name,
    required this.subCategorie,
    required this.size,
    required this.barCode,
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
  final barCode;
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
    required this.barCode,
    this.promotion,
    required this.selected,
  });
}

class ProductsByDate {
  final quality;
  //final catalogue;
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
  final barCode;
  bool selected;

  ProductsByDate({
    required this.quality,
    //required this.catalogue,
    required this.categorie,
    required this.code,
    required this.design,
    required this.line,
    required this.brand,
    required this.lastModifiedDate,
    required this.name,
    required this.subCategorie,
    required this.size,
    required this.barCode,
    this.promotion,
    required this.selected,
  });
}

List<Products> productsListFromSnapshot(QuerySnapshot snapshot) {
  print('FETCHING PRODUCTS');
  return snapshot.docs.map((doc) {
    return Products(
      quality: doc.data().toString().contains('calidad')
          ? doc.get('calidad').id
          : '',
      catalogue: doc.data().toString().contains('catalogo')
          ? doc.get('catalogo').id
          : '',
      categorie: doc.data().toString().contains('categoria')
          ? doc.get('categoria').id
          : '',
      code: doc.data().toString().contains('codigo') ? doc.get('codigo') : '',
      barCode: doc.data().toString().contains('codigoBarra')
          ? doc.get('codigoBarra')
          : '',
      design:
          doc.data().toString().contains('diseno') ? doc.get('diseno').id : '',
      line: doc.data().toString().contains('linea') ? doc.get('linea').id : '',
      brand: doc.data().toString().contains('marca') ? doc.get('marca').id : '',
      lastModifiedDate: doc.data().toString().contains('modificado')
          ? doc.get('modificado')
          : '',
      name: doc.data().toString().contains('nombre') ? doc.get('nombre') : '',
      subCategorie: doc.data().toString().contains('subcategoria')
          ? doc.get('subcategoria').id
          : '',
      size:
          doc.data().toString().contains('tamano') ? doc.get('tamano').id : '',
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
      // quality: doc.get('calidad').id,
      // catalogue: doc.get('catalogo').id,
      // categorie: doc.get('categoria').id,
      // code: doc.get('codigo'),
      // design: doc.get('diseno').id,
      // line: doc.get('linea').id,
      // brand: doc.get('marca').id,
      // lastModifiedDate: doc.get('modificado'),
      // name: doc.get('nombre'),
      // subCategorie: doc.get('subcategoria').id,
      // size: doc.get('tamano').id,
      // promotion: doc.data().toString().contains('promocion')
      //     ? doc.get('promocion').id
      //     : null,
      // selected: false,
      quality: doc.data().toString().contains('calidad')
          ? doc.get('calidad').id
          : '',
      catalogue: doc.data().toString().contains('catalogo')
          ? doc.get('catalogo').id
          : '',
      categorie: doc.data().toString().contains('categoria')
          ? doc.get('categoria').id
          : '',
      code: doc.data().toString().contains('codigo') ? doc.get('codigo') : '',
      barCode: doc.data().toString().contains('codigoBarra')
          ? doc.get('codigoBarra')
          : '',
      design:
          doc.data().toString().contains('diseno') ? doc.get('diseno').id : '',
      line: doc.data().toString().contains('linea') ? doc.get('linea').id : '',
      brand: doc.data().toString().contains('marca') ? doc.get('marca').id : '',
      lastModifiedDate: doc.data().toString().contains('modificado')
          ? doc.get('modificado')
          : '',
      name: doc.data().toString().contains('nombre') ? doc.get('nombre') : '',
      subCategorie: doc.data().toString().contains('subcategoria')
          ? doc.get('subcategoria').id
          : '',
      size:
          doc.data().toString().contains('tamano') ? doc.get('tamano').id : '',
      promotion: doc.data().toString().contains('promocion')
          ? doc.get('promocion').id
          : '',
      selected: false,
    );
  }).toList();
}

List<ProductsByDate> productsByDateListFromSnapshot(QuerySnapshot snapshot) {
  List<ProductsByDate> productList = snapshot.docs.map((doc) {
    return ProductsByDate(
      quality: doc.data().toString().contains('calidad')
          ? doc.get('calidad').id
          : '',
      // catalogue: doc.data().toString().contains('catalogo')
      //     ? doc.get('catalogo').id
      //     : '',
      categorie: doc.data().toString().contains('categoria')
          ? doc.get('categoria').id
          : '',
      code: doc.data().toString().contains('codigo') ? doc.get('codigo') : '',
      barCode: doc.data().toString().contains('codigoBarra')
          ? doc.get('codigoBarra')
          : '',
      design:
          doc.data().toString().contains('diseno') ? doc.get('diseno').id : '',
      line: doc.data().toString().contains('linea') ? doc.get('linea').id : '',
      brand: doc.data().toString().contains('marca') ? doc.get('marca').id : '',
      lastModifiedDate: doc.data().toString().contains('modificado')
          ? doc.get('modificado')
          : '',
      name: doc.data().toString().contains('nombre') ? doc.get('nombre') : '',
      subCategorie: doc.data().toString().contains('subcategoria')
          ? doc.get('subcategoria').id
          : '',
      size:
          doc.data().toString().contains('tamano') ? doc.get('tamano').id : '',
      promotion: doc.data().toString().contains('promocion')
          ? doc.get('promocion').id
          : '',
      selected: false,
    );
  }).toList();

  return productList;
}
