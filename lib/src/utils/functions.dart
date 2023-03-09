double exchangeAmount(String coin, double amount) {
  if (coin.contains('VED')) {
    return amount / 4.58;
  }
  if (coin.contains('EUR')) {
    return amount / 0.89;
  }
  if (coin.contains('MXN')) {
    return amount / 19.43;
  }
  return amount;
}
