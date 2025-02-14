enum CardBrand {
  visa("VISA", cardBrandId: 1),
  mastercard("MASTERCARD", cardBrandId: 2),
  amex("AMEX", cardBrandId: 3),
  otro("OTRO");

  final String brand;
  final int? cardBrandId;
  const CardBrand(this.brand, {this.cardBrandId});

  static const _brandIdMap = {
    1: CardBrand.visa,
    2: CardBrand.mastercard,
    3: CardBrand.amex,
  };

  static CardBrand fromBrandId(int? id) {
    if (id == null) return CardBrand.otro;

    return _brandIdMap[id] ?? CardBrand.otro;
  }
}