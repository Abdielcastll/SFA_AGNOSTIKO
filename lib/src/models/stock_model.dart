class StockModel {
  final stock;

  StockModel(
    this.stock,
  );
}

StockModel stockListfromSnapshot(doc) {
  print("stock from snapshot");
  print(doc);
  final Map<String, dynamic> valores = {
    '0': 0,
  };
  return StockModel(
    doc.data().toString().contains('valores') ? doc.get('valores') : valores,
    // (doc.get('valores')) ?? 'NaN',
  );
}
