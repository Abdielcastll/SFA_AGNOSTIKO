enum ProductSize {
  xs("Extra chico"),
  s("Chico"),
  m("Mediano"),
  l("Grande"),
  xl("Extra grande"),
  std("Estandar");

  final String size;
  const ProductSize(this.size);

  @override
  String toString() => size;
}

extension ProductSizeExtension on ProductSize {
  static ProductSize fromString(String size) {
    switch (size.toLowerCase()) {
      case "extra chico":
      case "extra chica":
        return ProductSize.xs;
      case "chica":
      case "chico":
        return ProductSize.s;
      case "mediano":
      case "mediana":
        return ProductSize.m;
      case "grande":
        return ProductSize.l;
      case "extra grande":
        return ProductSize.xl;
      default:
        return ProductSize.std;
    }
  }
}
