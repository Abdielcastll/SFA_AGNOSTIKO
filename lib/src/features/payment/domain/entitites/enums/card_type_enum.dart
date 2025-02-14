enum CardType {
  debito("DÉBITO", "DEBIT"),
  credito("CRÉDITO", "CREDIT"),
  otro("OTRO", "OTHER");

  final String mx;
  final String us;
  const CardType(this.mx, this.us);

  static const _typesMap = {
    "debit": CardType.debito,
    "debito": CardType.debito,
    "débito": CardType.debito,
    "credit": CardType.credito,
    "credito": CardType.credito,
    "crédito": CardType.credito,
  };

  static CardType fromString(String? cardType) {
    if (cardType == null) return CardType.otro;

    final sanitizedCard = cardType.trim().toLowerCase();
    return _typesMap[sanitizedCard] ?? CardType.otro;
  }
}