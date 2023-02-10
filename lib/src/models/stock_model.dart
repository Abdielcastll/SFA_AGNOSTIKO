class StockModel {
  final stock;

  StockModel(
    this.stock,
  );
}

StockModel stockListfromSnapshot(doc) {
  return StockModel(
    doc.data().toString().contains('valores') ? doc.get('valores') : 0,
    // (doc.get('valores')) ?? 'NaN',
  );
}
