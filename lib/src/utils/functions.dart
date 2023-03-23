double exchangeAmount(String coin, double amount) {
  var newAmount = amount;
  if (coin.contains('VED')) {
    newAmount = amount / 4.58;
  }
  if (coin.contains('EUR')) {
    newAmount = amount / 0.89;
  }
  if (coin.contains('MXN')) {
    newAmount = amount / 19.43;
  }
  return double.parse(newAmount.toStringAsFixed(4));
}

double priceToCurrencySelected(double productPrice, String coin) {
  double correctAmount = double.parse(productPrice.toStringAsFixed(2));

  if (coin.contains('USD')) {
    return correctAmount;
  } else if (coin.contains('VED')) {
    return double.parse((correctAmount * 4.58).toStringAsFixed(2));
  } else if (coin.contains('EUR')) {
    return double.parse((correctAmount * 0.89).toStringAsFixed(2));
  } else if (coin.contains('MXN')) {
    return double.parse((correctAmount * 19.43).toStringAsFixed(2));
  } else if (coin.contains('BTC')) {
    return double.parse((correctAmount * 0.00011).toStringAsFixed(2));
  } else {
    return double.parse((correctAmount * 4.58).toStringAsFixed(2));
  }
}
