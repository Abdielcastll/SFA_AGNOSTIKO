// Get del provider de resumen de calidades

class QualitySummary {
  final summary;
  QualitySummary(this.summary);
}

QualitySummary qualitySummaryFromSnapshot(snapshot) {
  return QualitySummary(snapshot.get('nombres'));
}

// Get del provider de resumen de Categoria

class CategorieSummary {
  final summary;
  CategorieSummary(this.summary);
}

CategorieSummary categorieSummaryFromSnapshot(snapshot) {
  print('CATEGORIAS');
  var res = (snapshot.get('nombres') as Map<String, dynamic>);

  /* res.removeWhere((key, value) =>
      !value.toLowerCase().contains('aceite') &&
      !value.toLowerCase().contains('manteca'));
  print(res); */
  return CategorieSummary(res);
}

// Get del provider de resumen de disenos

class DesignSummary {
  final summary;
  DesignSummary(this.summary);
}

DesignSummary designSummaryFromSnapshot(snapshot) {
  return DesignSummary(snapshot.get('nombres'));
}

// Get del provider de resumen de lineas

class LineSummary {
  final summary;
  LineSummary(this.summary);
}

LineSummary lineSummaryFromSnapshot(snapshot) {
  return LineSummary(snapshot.get('nombres'));
}

// Get del provider de resumen de marcas

class BrandSummary {
  final summary;
  BrandSummary(this.summary);
}

BrandSummary brandSummaryFromSnapshot(snapshot) {
  return BrandSummary(snapshot.get('nombres'));
}

// Get del provider de resumen de nombres de los Roles

class RolesSummary {
  final summary;
  RolesSummary(this.summary);
}

RolesSummary rolesSummaryfromSnapshot(snapshot) {
  return RolesSummary(snapshot.get('nombres'));
}

// Get del provider de resumen de stock

class SubCategorieSummary {
  final summary;
  SubCategorieSummary(this.summary);
}

SubCategorieSummary subCategoriesFromSnapshot(snapshot) {
  return SubCategorieSummary(snapshot.get('nombres'));
}

// Get del provider de resumen de Tamanos

class SizeSummary {
  final summary;
  SizeSummary(this.summary);
}

SizeSummary sizeSummaryFromSnapshot(snapshot) {
  return SizeSummary(snapshot.get('nombres'));
}

// Get del provider de resumen de zonas

class ZoneSummary {
  final summary;
  ZoneSummary(this.summary);
}

ZoneSummary zoneSummaryFromSnapshot(snapshot) {
  return ZoneSummary(snapshot.get('nombres'));
}

// Get del provider de resumen de Bancos

class BankSummary {
  final summary;
  BankSummary(this.summary);
}

BankSummary bankSummaryFromSnapshot(snapshot) {
  return BankSummary(snapshot.get('nombres'));
}

// Get del provider de resumen de tipos de ID

class IdTypeSummary {
  final summary;
  IdTypeSummary(this.summary);
}

IdTypeSummary idTypeSummaryFromSnapshot(snapshot) {
  return IdTypeSummary(snapshot.get('nombres'));
}
// Resumen de nombres de precios

class PricesSummary {
  final summary;
  PricesSummary(this.summary);
}

PricesSummary pricesSummaryFromSnapshot(snapshot) {
  return PricesSummary(snapshot.get('nombres'));
}
