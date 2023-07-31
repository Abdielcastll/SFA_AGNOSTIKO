class CatalogueExample {
  final String categorie;
  final String imageUrl;

  CatalogueExample({
    required this.categorie,
    required this.imageUrl,
  });
}

final allCategories = [
  CatalogueExample(
    categorie: 'SABANAS',
    imageUrl: 'https://i.imgur.com/BbieIdC.jpg',
  ),
  CatalogueExample(
    categorie: 'TOALLA',
    imageUrl: 'https://i.imgur.com/Jdg7o5B.jpg',
  ),
  CatalogueExample(
    categorie: 'COLCHON',
    imageUrl: 'https://i.imgur.com/R0eJfel.jpg',
  ),
  CatalogueExample(
    categorie: 'LENTES',
    imageUrl: 'https://i.imgur.com/3owelNd.jpg',
  ),
];
